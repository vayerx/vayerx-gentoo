# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils flag-o-matic multiprocessing python-r1 toolchain-funcs multilib-minimal

MY_P="${PN}_$(ver_rs 1- _)"
MAJOR="$(ver_cut 1-1)"
MAJOR_V="$(ver_cut 1-2)"
MAJOR_PV="$(ver_rs 1- _ ${MAJOR_V})"

DESCRIPTION="Boost Libraries for C++"
HOMEPAGE="https://www.boost.org/"
SRC_URI="mirror://sourceforge/boost/${MY_P}.tar.bz2"

LICENSE="Boost-1.0"
SLOT="${MAJOR_V}/${PV}"
KEYWORDS="~x86 ~amd64"
IUSE="+bzip2 +context debug doc +eselect icu +lzma +nls mpi numpy python static-libs +threads tools +zlib zstd"
REQUIRED_USE="
	mpi? ( threads )
	python? ( ${PYTHON_REQUIRED_USE} )"

# the tests will never fail because these are not intended as sanity
# tests at all. They are more a way for upstream to check their own code
# on new compilers. Since they would either be completely unreliable
# (failing for no good reason) or completely useless (never failing)
# there is no point in having them in the ebuild to begin with.
RESTRICT="test"

RDEPEND="
	bzip2? ( app-arch/bzip2:=[${MULTILIB_USEDEP}] )
	icu? ( >=dev-libs/icu-3.6:=[${MULTILIB_USEDEP}] )
	eselect? ( >=app-admin/eselect-boost-0.5 )
	!eselect? ( !app-admin/eselect-boost )
	!icu? ( virtual/libiconv[${MULTILIB_USEDEP}] )
	lzma? ( app-arch/xz-utils:=[${MULTILIB_USEDEP}] )
	mpi? ( >=virtual/mpi-2.0-r4[${MULTILIB_USEDEP},cxx,threads] )
	python? (
		${PYTHON_DEPS}
		numpy? ( >=dev-python/numpy-1.14.5[${PYTHON_USEDEP}] )
	)
	zlib? ( sys-libs/zlib:=[${MULTILIB_USEDEP}] )
	zstd? ( app-arch/zstd:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

BDEPEND="dev-util/boost-build:${MAJOR_V}"

S="${WORKDIR}/${MY_P}"

python_bindings_needed() {
	multilib_is_native_abi && use python
}

tools_needed() {
	multilib_is_native_abi && use tools
}

BJAM="b2-${MAJOR_PV}"
LIBEXT="$(get_libname)"

# Usage:
# _add_line <line-to-add> <profile>
# ... to add to specific profile
# or
# _add_line <line-to-add>
# ... to add to all profiles for which the use flag set

_add_line() {
	local profile="default"
	if [[ -z "$2" ]]; then
		if use debug; then
			profile="debug"
		else
			eerror "unknown profile"
			die
		fi
	else
		profile="${2}"
	fi
	echo "${1}" >> "${D%/}/usr/share/boost-eselect/profiles/${MAJOR_V}/${profile}/${MULTILIB_ABI_FLAG:-native}"
}

create_user-config.jam() {
	local user_config_jam="${BUILD_DIR}"/user-config.jam
	if [[ -s ${user_config_jam} ]]; then
		einfo "${user_config_jam} already exists, skipping configuration"
		return
	else
		einfo "Creating configuration in ${user_config_jam}"
	fi

	local compiler compiler_version compiler_executable="$(tc-getCXX)"
	if [[ ${CHOST} == *-darwin* ]]; then
		compiler="darwin"
		compiler_version="$(gcc-fullversion)"
	else
		compiler="gcc"
		compiler_version="$(gcc-version)"
	fi

	if use mpi; then
		local mpi_configuration="using mpi ;"
	fi

	cat > "${user_config_jam}" <<- __EOF__ || die
		using ${compiler} : ${compiler_version} : ${compiler_executable} : <cflags>"${CFLAGS}" <cxxflags>"${CXXFLAGS}" <linkflags>"${LDFLAGS}" ;
		${mpi_configuration}
	__EOF__

	if python_bindings_needed; then
		append_to_user_config() {
			local py_config
			if tc-is-cross-compiler; then
				py_config="using python : ${EPYTHON#python} : : ${ESYSROOT}/usr/include/${EPYTHON} : ${ESYSROOT}/usr/$(get_libdir) ;"
			else
				py_config="using python : ${EPYTHON#python} : ${PYTHON} : $(python_get_includedir) ;"
			fi
			echo "${py_config}" >> "${user_config_jam}" || die
		}
		python_foreach_impl append_to_user_config
	fi

	if python_bindings_needed && use numpy; then
		einfo "Enabling support for NumPy extensions in Boost.Python"
	else
		einfo "Disabling support for NumPy extensions in Boost.Python"

		# Boost.Build does not allow for disabling of numpy
		# extensions, thereby leading to automagic numpy
		# https://github.com/boostorg/python/issues/111#issuecomment-280447482
		sed \
			-e 's/\[ unless \[ python\.numpy \] : <build>no \]/<build>no/g' \
			-i "${BUILD_DIR}"/libs/python/build/Jamfile || die
	fi
}

pkg_setup() {
	# Bail out on unsupported build configuration, bug #456792
	if [[ -f "${EROOT}/etc/site-config.jam" ]]; then
		if ! grep -q 'gentoo\(debug\|release\)' "${EROOT}/etc/site-config.jam"; then
			eerror "You are using custom ${EROOT}/etc/site-config.jam without defined gentoorelease/gentoodebug targets."
			eerror "Boost can not be built in such configuration."
			eerror "Please, either remove this file or add targets from ${EROOT}/usr/share/boost-build/site-config.jam to it."
			die "Unsupported target in ${EROOT}/etc/site-config.jam"
		fi
	fi
}

src_prepare() {
	default

	for patch in "${BOOST_PATCHES[@]}"; do
		eapply "${FILESDIR%/}/${PN}-${patch}"
	done

	# Do not try to build missing 'wave' tool, bug #522682
	# Upstream bugreport - https://svn.boost.org/trac/boost/ticket/10507
	sed -i -e 's:wave/build//wave::' tools/Jamfile.v2 || die

	multilib_copy_sources
}

ejam() {
	create_user-config.jam

	local b2_opts=( "--user-config=${BUILD_DIR}/user-config.jam" )
	if python_bindings_needed; then
		append_to_b2_opts() {
			b2_opts+=( python="${EPYTHON#python}" )
		}
		python_foreach_impl append_to_b2_opts
	else
		b2_opts+=( --without-python )
	fi
	b2_opts+=( "$@" )

	echo ${BJAM} "${b2_opts[@]}"
	${BJAM} "${b2_opts[@]}"
}

src_configure() {
	# Workaround for too many parallel processes requested, bug #506064
	[[ "$(makeopts_jobs)" -gt 64 ]] && MAKEOPTS="${MAKEOPTS} -j64"

	OPTIONS=(
		$(usex debug gentoodebug gentoorelease)
		"-j$(makeopts_jobs)"
		-q
		-d+2
		pch=off
		$(usex icu "-sICU_PATH=${ESYSROOT}/usr" '--disable-icu boost.locale.icu=off')
		$(usex mpi '' '--without-mpi')
		$(usex nls '' '--without-locale')
		$(usex context '' '--without-context --without-coroutine --without-fiber')
		$(usex threads '' '--without-thread')
		# --without-stacktrace
		--boost-build="${BROOT}"/usr/share/boost-build-${MAJOR_PV}
		--prefix="${ED%/}/usr"
		--layout=system
		# CMake has issues working with multiple python impls,
		# disable cmake config generation for the time being
		# https://github.com/boostorg/python/issues/262#issuecomment-483069294
		--no-cmake-config
		# building with threading=single is currently not possible
		# https://svn.boost.org/trac/boost/ticket/7105
		threading=multi
		link=$(usex static-libs shared,static shared)
		# this seems to be the only way to disable compression algorithms
		# https://www.boost.org/doc/libs/1_70_0/libs/iostreams/doc/installation.html#boost-build
		-sNO_BZIP2=$(usex bzip2 0 1)
		-sNO_LZMA=$(usex lzma 0 1)
		-sNO_ZLIB=$(usex zlib 0 1)
		-sNO_ZSTD=$(usex zstd 0 1)
	)

	if [[ ${CHOST} == *-darwin* ]]; then
		# We need to add the prefix, and in two cases this exceeds, so prepare
		# for the largest possible space allocation.
		append-ldflags -Wl,-headerpad_max_install_names
	fi

	# Use C++14 globally as of 1.62
	append-cxxflags -std=c++14

	if use static-libs; then
		LIBRARY_TARGETS="*.a.${PV} *$(get_libname ${PV})"
	else
		LIBRARY_TARGETS="*$(get_libname ${PV})"
	fi
}

multilib_src_compile() {
	ejam "${OPTIONS[@]}" || die

	if tools_needed; then
		pushd tools >/dev/null || die
		ejam \
			"${OPTIONS[@]}" \
			|| die "Building of Boost tools failed"
		popd >/dev/null || die
	fi
}

multilib_src_install_all() {
	if ! use numpy; then
		rm -r "${ED%/}"/usr/include/boost-${MAJOR_V}/boost/python/numpy* || die
	fi

	if ! use python; then
		rm -r "${ED%/}"/usr/include/boost-${MAJOR_V}/boost/{python*,mpi/python*,parameter/aux_/python,parameter/python*} || die
	fi

	if ! use nls; then
		rm -r "${ED%/}"/usr/include/boost-${MAJOR_V}/boost/locale || die
	fi

	if ! use context; then
		rm -r "${ED%/}"/usr/include/boost-${MAJOR_V}/boost/context || die
		rm -r "${ED%/}"/usr/include/boost-${MAJOR_V}/boost/coroutine{,2} || die
		rm    "${ED%/}"/usr/include/boost-${MAJOR_V}/boost/asio/spawn.hpp || die
	fi

	if use doc; then
		# find extraneous files that shouldn't be installed
		# as part of the documentation and remove them.
		find libs/*/* \( -iname 'test' -o -iname 'src' \) -exec rm -rf '{}' + || die
		find doc \( -name 'Jamfile.v2' -o -name 'build' -o -name '*.manifest' \) -exec rm -rf '{}' + || die
		find tools \( -name 'Jamfile.v2' -o -name 'src' -o -name '*.cpp' -o -name '*.hpp' \) -exec rm -rf '{}' + || die

		docinto html
		dodoc *.{htm,html,png,css}
		dodoc -r doc libs more tools

		# To avoid broken links
		dodoc LICENSE_1_0.txt

		dosym ../../../../include/boost-${MAJOR_V} /usr/share/doc/${PF}/html/boost
	fi
}

multilib_src_install() {
	ejam \
		"${OPTIONS[@]}" \
		--includedir="${ED}/usr/include/boost-${MAJOR_V}" \
		--libdir="${ED}/usr/$(get_libdir)" \
		install || die "Installation of Boost libraries failed"

	pushd "${ED}/usr/$(get_libdir)" >/dev/null || die

	touch_profile() {
		local profile="${1:?no profile was specified}"
		dodir "/usr/share/boost-eselect/profiles/${MAJOR_V}/${profile}" || die
		touch "${D%/}/usr/share/boost-eselect/profiles/${MAJOR_V}/${profile}/${MULTILIB_ABI_FLAG:-native}" || die
	}

	multilib_foreach_abi touch_profile default
	if use debug; then
		multilib_foreach_abi touch_profile debug
	fi

	pushd "${ED%/}/usr/$(get_libdir)" >/dev/null || die

	# Remove (unversioned) symlinks
	# And check for what we remove to catch bugs
	# got a better idea how to do it? tell me!
	local f
	for f in $(ls -1 ${LIBRARY_TARGETS} | grep -v "${MAJOR_V}"); do
		[[ -L "${f}" ]] && rm "${f}"
	done

	local ext
	# Fix static libraries naming -- add version
	ext=".a"
	for f in *${ext}; do
		mv "${f}" "${f}.${PV}"
	done

	# delete libraries with only major version suffix (not backward-compatible)
	for ext in a so; do
		for f in *.${ext}; do
			rm -f "${f}.${MAJOR}"
		done
	done

	local -x LIBDIR="/usr/$(get_libdir)"
	_add_line "libs=\"" default

	# Add "-mt" suffix if threads are enabled
	ext="$(get_libname ${PV})"
	if use threads; then
		local f
		for f in *${ext}; do
			local slot_target="${f/${ext}/-mt${LIBEXT}}"
			local slot_source="${slot_target}.${MAJOR_V}"
			[[ -e "${slot_source}" ]] || dosym "${LIBDIR}/${f}" "${LIBDIR}/${slot_source}"	# install major-version
			[[ -L "${slot_target}" ]] && rm "${slot_target}"
			_add_line "${LIBDIR}/${slot_source}" default
		done
	fi

	local f
	for f in $(ls -1 ${LIBRARY_TARGETS} | grep -v debug); do
		if [[ -e "${f}" ]]; then
			local slot_target="${f//.${PV}}"
			local slot_source="${slot_target}.${MAJOR_V}"
			[[ -e "${slot_source}" ]] || dosym "${LIBDIR}/${f}" "${LIBDIR}/${slot_source}"	# install major-version
			[[ -L "${slot_target}" ]] && rm "${slot_target}"
			_add_line "${LIBDIR}/${slot_source}" default
		else
			ewarn "Missing or invalid library name: ${f}"
		fi
	done
	_add_line "\"" default

	if is_final_abi; then
		_add_line "includes=\"/usr/include/boost-${MAJOR_V}/boost\"" default
	fi

	popd >/dev/null || die

	if tools_needed; then
		pushd dist/bin > /dev/null || die

		# Append version postfix to binaries for slotting
		_add_line "bins=\""
		local b
		for b in *; do
			newbin "${b}" "${b}-${MAJOR_PV}"
			_add_line "/usr/bin/${b}-${MAJOR_PV}"
		done
		_add_line "\""
		popd > /dev/null || die

		insinto /usr/share
		doins -r dist/share/boostbook

		# Append version postfix for slotting
		mv "${D%/}/usr/share/boostbook" "${D%/}/usr/share/boostbook-${MAJOR_PV}" || die
		_add_line "dirs=\"/usr/share/boostbook-${MAJOR_PV}\""
		# TODO dosym /usr/share/boostbook-${MAJOR_PV} /usr/share/boostbook
	fi
}

pkg_postinst() {
	if use eselect && [[ ! -h "${ROOT}etc/eselect/boost/active" || ! -f $(readlink -f "${ROOT}etc/eselect/boost/active") ]]; then
		elog "No active boost version found. Calling eselect to select one..."
		eselect boost update || ewarn "eselect boost update failed."
	fi
}
