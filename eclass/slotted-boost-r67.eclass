# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils flag-o-matic multiprocessing python-r1 toolchain-funcs multilib-minimal

MY_P="${PN}_$(ver_rs 1- _)"
MAJOR_V="$(ver_cut 1-2)"
MAJOR_PV="$(ver_rs 1- _ ${MAJOR_V})"

DESCRIPTION="Boost Libraries for C++"
HOMEPAGE="https://www.boost.org/"
SRC_URI="mirror://sourceforge/boost/${MY_P}.tar.bz2"

LICENSE="Boost-1.0"
SLOT="${MAJOR_V}/${PV}"
KEYWORDS="~x86 ~amd64"
IUSE="+context debug doc +eselect icu +nls mpi python static-libs +threads tools"

RDEPEND="icu? ( >=dev-libs/icu-3.6:=[${MULTILIB_USEDEP}] )
	!icu? ( virtual/libiconv[${MULTILIB_USEDEP}] )
	mpi? ( >=virtual/mpi-2.0-r4[${MULTILIB_USEDEP},cxx,threads] )
	python? (
		${PYTHON_DEPS}
		>dev-python/numpy-1.7[${PYTHON_USEDEP}]
	)
	app-arch/bzip2[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	eselect? ( >=app-admin/eselect-boost-0.5 )
	!eselect? ( !app-admin/eselect-boost )"
DEPEND="${RDEPEND}
	dev-util/boost-build:${MAJOR_V}"
REQUIRED_USE="
	mpi? ( threads )
	python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/${MY_P}"

# the tests will never fail because these are not intended as sanity
# tests at all. They are more a way for upstream to check their own code
# on new compilers. Since they would either be completely unreliable
# (failing for no good reason) or completely useless (never failing)
# there is no point in having them in the ebuild to begin with.
RESTRICT="test"

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
	local compiler compiler_version compiler_executable

	if [[ ${CHOST} == *-darwin* ]]; then
		compiler="darwin"
		compiler_version="$(gcc-fullversion)"
		compiler_executable="$(tc-getCXX)"
	else
		compiler="gcc"
		compiler_version="$(gcc-version)"
		compiler_executable="$(tc-getCXX)"
	fi
	local mpi_configuration python_configuration

	if use mpi; then
		mpi_configuration="using mpi ;"
	fi

	if python_bindings_needed; then
		# boost expects libpython$(pyver) and doesn't allow overrides
		# and the build system is so creepy that it's easier just to
		# provide a symlink (linker's going to use SONAME anyway)
		# TODO: replace it with proper override one day
		ln -f -s "$(python_get_library_path)" "${T}/lib${EPYTHON}$(get_libname)" || die

		if tc-is-cross-compiler; then
			python_configuration="using python : ${EPYTHON#python} : : ${SYSROOT:-${EROOT}}/usr/include/${EPYTHON} : ${SYSROOT:-${EROOT}}/usr/$(get_libdir) ;"
		else
			# note: we need to provide version explicitly because of
			# a bug in the build system:
			# https://github.com/boostorg/build/pull/104
			python_configuration="using python : ${EPYTHON#python} : ${PYTHON} : $(python_get_includedir) : ${T} ;"
		fi
	fi

	cat > "${BOOST_ROOT}/user-config.jam" << __EOF__ || die
using ${compiler} : ${compiler_version} : ${compiler_executable} : <cflags>"${CFLAGS}" <cxxflags>"${CXXFLAGS}" <linkflags>"${LDFLAGS}" ;
${mpi_configuration}
${python_configuration}
__EOF__
}

pkg_setup() {
	if use context && [[ $(gcc-major-version) -lt 5 && $(gcc-minor-version) -lt 9 ]]; then
		eerror "Boost.context requires GCC 4.9"
		die
	fi

	# Bail out on unsupported build configuration, bug #456792
	if [[ -f "${EROOT%/}/etc/site-config.jam" ]]; then
		grep -q gentoorelease "${EROOT%/}/etc/site-config.jam" && grep -q gentoodebug "${EROOT%/}/etc/site-config.jam" ||
		(
			eerror "You are using custom ${EROOT%/}/etc/site-config.jam without defined gentoorelease/gentoodebug targets."
			eerror "Boost can not be built in such configuration."
			eerror "Please, either remove this file or add targets from ${EROOT%/}/usr/share/boost-build/site-config.jam to it."
			die
		)
	fi
}

src_prepare() {
	default

	for patch in "${BOOST_PATCHES[@]}"; do
		epatch "${FILESDIR%/}/${PN}-${patch}"
	done

	# Do not try to build missing 'wave' tool, bug #522682
	# Upstream bugreport - https://svn.boost.org/trac/boost/ticket/10507
	sed -i -e 's:wave/build//wave::' tools/Jamfile.v2 || die

	multilib_copy_sources
}

ejam() {
	local b2_opts=(
		"--user-config=${BOOST_ROOT}/user-config.jam"
		"$@"
	)
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
		$(usex icu "-sICU_PATH=${EPREFIX}/usr" '--disable-icu boost.locale.icu=off')
		$(usex mpi '' '--without-mpi')
		$(usex nls '' '--without-locale')
		$(usex context '' '--without-context --without-coroutine --without-fiber')
		$(usex threads '' '--without-thread')
		--boost-build="${EPREFIX}/usr/share/boost-build-${MAJOR_V}"
		--prefix="${ED%/}/usr"
		--layout=system
		# building with threading=single is currently not possible
		# https://svn.boost.org/trac/boost/ticket/7105
		threading=multi
		link=$(usex static-libs shared,static shared)
		$([[ ${CHOST} == *-winnt* ]] && printf -- '-sNO_BZIP2=1\n')
	)

	if [[ ${CHOST} == *-darwin* ]]; then
		# We need to add the prefix, and in two cases this exceeds, so prepare
		# for the largest possible space allocation.
		append-ldflags -Wl,-headerpad_max_install_names
	elif [[ ${CHOST} == *-winnt* ]]; then
		compiler=parity
		if [[ $($(tc-getCXX) -v) == *trunk* ]]; then
			compilerVersion=trunk
		else
			compilerVersion=$($(tc-getCXX) -v | sed '1q' \
				| sed -e 's,\([a-z]*\) \([0-9]\.[0-9]\.[0-9][^ \t]*\) .*,\2,') || die "sed failed"
		fi
		compilerExecutable=$(tc-getCXX)
	fi

	# bug 298489
	if use ppc || use ppc64; then
		[[ $(gcc-version) > 4.3 ]] && append-flags -mno-altivec
	fi

	# Use C++14 globally as of 1.62
	append-cxxflags -std=c++14

	if use static-libs; then
		LIBRARY_TARGETS="*.a.${PV} *$(get_libname ${PV})"
	else
		# There is no dynamically linked version of libboost_test_exec_monitor and libboost_exception.
		LIBRARY_TARGETS="libboost_test_exec_monitor.a.${PV} libboost_exception.a.${PV} *$(get_libname ${PV})"
	fi
}

multilib_src_compile() {
	local -x BOOST_ROOT="${BUILD_DIR}"
	PYTHON_DIRS=""
	MPI_PYTHON_MODULE=""

	building() {
		create_user-config.jam

		local PYTHON_OPTIONS
		if python_bindings_needed; then
			PYTHON_OPTIONS=" --python-buildid=${EPYTHON#python}"
		else
			PYTHON_OPTIONS=" --without-python"
		fi

		ejam \
			"${OPTIONS[@]}" \
			${PYTHON_OPTIONS} \
			|| die "Building of Boost libraries failed"

		if python_bindings_needed; then
			if [[ -z "${PYTHON_DIRS}" ]]; then
				PYTHON_DIRS="$(find bin.v2/libs -name python | sort)"
			else
				if [[ "${PYTHON_DIRS}" != "$(find bin.v2/libs -name python | sort)" ]]; then
					die "Inconsistent structure of build directories"
				fi
			fi

			local dir
			for dir in ${PYTHON_DIRS}; do
				mv ${dir} ${dir}-${EPYTHON} \
					|| die "Renaming of '${dir}' to '${dir}-${EPYTHON}' failed"
			done

			if use mpi; then
				if [[ -z "${MPI_PYTHON_MODULE}" ]]; then
					MPI_PYTHON_MODULE="$(find bin.v2/libs/mpi/build/*/gentoo* -name mpi.so)"
					if [[ "$(echo "${MPI_PYTHON_MODULE}" | wc -l)" -ne 1 ]]; then
						die "Multiple mpi.so files found"
					fi
				else
					if [[ "${MPI_PYTHON_MODULE}" != "$(find bin.v2/libs/mpi/build/*/gentoo* -name mpi.so)" ]]; then
						die "Inconsistent structure of build directories"
					fi
				fi

				mv stage/lib/mpi.so stage/lib/mpi.so-${EPYTHON} \
					|| die "Renaming of 'stage/lib/mpi.so' to 'stage/lib/mpi.so-${EPYTHON}' failed"
			fi
		fi
	}
	if python_bindings_needed; then
		python_foreach_impl building
	else
		building
	fi

	if tools_needed; then
		pushd tools >/dev/null || die

		ejam \
			"${OPTIONS[@]}" \
			${PYTHON_OPTIONS} \
			|| die "Building of Boost tools failed"
		popd >/dev/null || die
	fi
}

multilib_src_install_all() {
	if ! use python; then
		rm -r "${ED%/}"/usr/include/boost-${MAJOR_V}/python* || die
	fi

	if ! use nls; then
		rm -r "${ED%/}"/usr/include/boost-${MAJOR_V}/locale || die
	fi

	if ! use context; then
		rm -r "${ED%/}"/usr/include/boost-${MAJOR_V}/context || die
		rm -r "${ED%/}"/usr/include/boost-${MAJOR_V}/coroutine{,2} || die
		rm    "${ED%/}"/usr/include/boost-${MAJOR_V}/asio/spawn.hpp || die
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

		dosym /usr/include/boost-${MAJOR_V} /usr/share/doc/${PF}/html/boost
	fi
}

multilib_src_install() {
	local -x BOOST_ROOT="${BUILD_DIR}"
	installation() {
		create_user-config.jam

		local PYTHON_OPTIONS
		if python_bindings_needed; then
			local dir
			for dir in ${PYTHON_DIRS}; do
				cp -pr ${dir}-${EPYTHON} ${dir} \
					|| die "Copying of '${dir}-${EPYTHON}' to '${dir}' failed"
			done

			if use mpi; then
				cp -p stage/lib/mpi.so-${EPYTHON} "${MPI_PYTHON_MODULE}" \
					|| die "Copying of 'stage/lib/mpi.so-${EPYTHON}' to '${MPI_PYTHON_MODULE}' failed"
				cp -p stage/lib/mpi.so-${EPYTHON} stage/lib/mpi.so \
					|| die "Copying of 'stage/lib/mpi.so-${EPYTHON}' to 'stage/lib/mpi.so' failed"
			fi
			PYTHON_OPTIONS=" --python-buildid=${EPYTHON#python}"
		else
			PYTHON_OPTIONS=" --without-python"
		fi

		ejam \
			"${OPTIONS[@]}" \
			${PYTHON_OPTIONS} \
			--includedir="${ED%/}/usr/include/boost-${MAJOR_V}" \
			--libdir="${ED%/}/usr/$(get_libdir)" \
			install || die "Installation of Boost libraries failed"

		if python_bindings_needed; then
			rm -r ${PYTHON_DIRS} || die

			# Move mpi.so Python module to Python site-packages directory.
			# https://svn.boost.org/trac/boost/ticket/2838
			if use mpi; then
				local moddir=$(python_get_sitedir)/boost_${MAJOR_V}
				# moddir already includes eprefix
				mkdir -p "${D}${moddir}" || die
				mv "${ED%/}/usr/$(get_libdir)/mpi.so" "${D}${moddir}" || die
				cat << EOF > "${D}${moddir}/__init__.py" || die
import sys
if sys.platform.startswith('linux'):
	import DLFCN
	flags = sys.getdlopenflags()
	sys.setdlopenflags(DLFCN.RTLD_NOW | DLFCN.RTLD_GLOBAL)
	from . import mpi
	sys.setdlopenflags(flags)
	del DLFCN, flags
else:
	from . import mpi
del sys
EOF
				_add_line "$(python_get_sitedir)/mpi.py:boost_${MAJOR_V}.mpi"
			fi

			python_optimize
		fi
	}

	touch_profile() {
		local profile="${1:?no profile was specified}"
		dodir "/usr/share/boost-eselect/profiles/${MAJOR_V}/${profile}" || die
		touch "${D%/}/usr/share/boost-eselect/profiles/${MAJOR_V}/${profile}/${MULTILIB_ABI_FLAG:-native}" || die
	}

	multilib_foreach_abi touch_profile default
	if use debug; then
		multilib_foreach_abi touch_profile debug
	fi

	if python_bindings_needed; then
		python_foreach_impl installation
	else
		installation
	fi

	if use mpi && python_bindings_needed; then
		_add_line "\""
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

	if use debug; then
		_add_line "libs=\"" debug
		local f
		for f in $(ls -1 ${LIBRARY_TARGETS} | grep debug); do
			dosym ../${f} ${LIBDIR}-debug/${f/-${MAJOR_V}-debug}
			_add_line "${LIBDIR}/${f}" debug
		done
		_add_line "\"" debug

		_add_line "suffix=\"-debug\"" debug

		if use threads; then
			if use static-libs; then
				THREAD_DEBUG_LIBS="libboost_thread-mt.${MAJOR_V}-debug${LIBEXT} libboost_thread-mt.${MAJOR_V}-debug.a"
			else
				THREAD_DEBUG_LIBS="libboost_thread-mt.${MAJOR_V}-debug${LIBEXT}"
			fi
		fi

		local lib
		for lib in ${THREAD_DEBUG_LIBS}; do
			dosym ${lib} "${LIBDIR}/${lib/-mt/}"
		done
	fi

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

	# boost's build system truely sucks for not having a destdir.  Because for
	# this reason we are forced to build with a prefix that includes the
	# DESTROOT, dynamic libraries on Darwin end messed up, referencing the
	# DESTROOT instread of the actual EPREFIX.  There is no way out of here
	# but to do it the dirty way of manually setting the right install_names.
	if [[ ${CHOST} == *-darwin* ]]; then
		einfo "Working around completely broken build-system(tm)"
		local d
		for d in "${ED%/}"/usr/lib/*.dylib; do
			if [[ -f ${d} ]]; then
				# fix the "soname"
				ebegin "  correcting install_name of ${d#${ED}}"
				install_name_tool -id "/${d#${D}}" "${d}"
				eend $?
				# fix references to other libs
				refs=$(otool -XL "${d}" | \
					sed -e '1d' -e 's/^\t//' | \
					grep "^libboost_" | \
					cut -f1 -d' ')
				local r
				for r in ${refs}; do
					ebegin "    correcting reference to ${r}"
					install_name_tool -change \
						"${r}" \
						"${EPREFIX}/usr/lib/${r}" \
						"${d}"
					eend $?
				done
			fi
		done
	fi
}

pkg_postinst() {
	if use eselect && [[ ! -h "${ROOT}etc/eselect/boost/active" || ! -f $(readlink -f "${ROOT}etc/eselect/boost/active") ]]; then
		elog "No active boost version found. Calling eselect to select one..."
		eselect boost update || ewarn "eselect boost update failed."
	fi
}
