# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3} )

inherit flag-o-matic multilib python-r1 toolchain-funcs versionator

MY_P=${PN}_$(replace_all_version_separators _)

DESCRIPTION="Boost Libraries for C++"
HOMEPAGE="http://www.boost.org/"
SRC_URI="mirror://sourceforge/boost/${MY_P}.tar.bz2"

LICENSE="Boost-1.0"
MAJOR_V="$(get_version_component_range 1-2)"
MAJOR_PV=$(replace_all_version_separators _ ${MAJOR_V})
SLOT="${MAJOR_V}"
KEYWORDS="~x86 ~amd64"
IUSE="debug doc +eselect icu mpi python static-libs tools"

RDEPEND="icu? ( >=dev-libs/icu-3.3 )
	mpi? ( || ( sys-cluster/openmpi[cxx] sys-cluster/mpich2[cxx,threads] ) )
	app-arch/bzip2
	sys-libs/zlib
	eselect? ( >=app-admin/eselect-boost-0.4-r1 )
	!eselect? ( !app-admin/eselect-boost )
	elibc_glibc? ( <sys-libs/glibc-2.16 )"
DEPEND="${RDEPEND}
	dev-util/boost-build:${MAJOR_V}"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S=${WORKDIR}/${MY_P}

BJAM="b2-${MAJOR_PV}"
LIBDIR="/usr/$(get_libdir)"
LIBEXT="$(get_libname)"

# Usage:
# _add_line <line-to-add> <profile>
# ... to add to specific profile
# or
# _add_line <line-to-add>
# ... to add to all profiles for which the use flag set

_add_line() {
	if [[ -z "$2" ]]; then
		echo "${1}" >> "${D}usr/share/boost-eselect/profiles/${MAJOR_V}/default"
		if use debug; then
			echo "${1}" >> "${D}usr/share/boost-eselect/profiles/${MAJOR_V}/debug"
		fi
	else
		echo "${1}" >> "${D}usr/share/boost-eselect/profiles/${MAJOR_V}/${2}"
	fi
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

	if use python; then
		python_configuration="using python : : ${PYTHON} ;"
	fi

	# The debug-symbols=none and optimization=none are not official upstream flags but a Gentoo
	# specific patch to make sure that all our CFLAGS/CXXFLAGS/LDFLAGS are being respected.
	# Using optimization=off would for example add "-O0" and override "-O2" set by the user.
	# Please take a look at the boost-build ebuild for more information.
	cat > user-config.jam << __EOF__
variant gentoorelease : release : <optimization>none <debug-symbols>none ;
variant gentoodebug : debug : <optimization>none ;

using ${compiler} : ${compiler_version} : ${compiler_executable} : <cflags>"${CFLAGS}" <cxxflags>"${CXXFLAGS}" <linkflags>"${LDFLAGS}" ;
${mpi_configuration}
${python_configuration}
__EOF__
}

src_prepare() {
	epatch \
		"${FILESDIR}/${PN}-1.48.0-mpi_python3.patch" \
		"${FILESDIR}/${PN}-1.48.0-respect_python-buildid.patch" \
		"${FILESDIR}/${PN}-1.48.0-support_dots_in_python-buildid.patch" \
		"${FILESDIR}/${PN}-1.48.0-no_strict_aliasing_python2.patch" \
		"${FILESDIR}/${PN}-1.48.0-disable_libboost_python3.patch" \
		"${FILESDIR}/${PN}-1.48.0-python_linking.patch" \
		"${FILESDIR}/${PN}-1.48.0-disable_icu_rpath.patch" \
		"${FILESDIR}/remove-toolset-1.48.0.patch"
}

ejam() {
	echo ${BJAM} "$@"
	${BJAM} "$@"
}

src_configure() {
	OPTIONS="$(usex debug gentoodebug gentoorelease) -j$(makeopts_jobs) -q -d+2 --user-config=${S}/user-config.jam"

	if [[ ${CHOST} == *-darwin* ]]; then
		# We need to add the prefix, and in two cases this exceeds, so prepare
		# for the largest possible space allocation.
		append-ldflags -Wl,-headerpad_max_install_names
	fi

	# bug 298489
	if use ppc || use ppc64; then
		[[ $(gcc-version) > 4.3 ]] && append-flags -mno-altivec
	fi

	use icu && OPTIONS+=" -sICU_PATH=/usr"
	use icu || OPTIONS+=" --disable-icu boost.locale.icu=off"
	use mpi || OPTIONS+=" --without-mpi"
	use python || OPTIONS+=" --without-python"

	# https://svn.boost.org/trac/boost/attachment/ticket/2597/add-disable-long-double.patch
	if use sparc || { use mips && [[ ${ABI} = "o32" ]]; } || use hppa || use arm || use x86-fbsd || use sh; then
		OPTIONS+=" --disable-long-double"
	fi

	OPTIONS+=" pch=off --boost-build=/usr/share/boost-build-${MAJOR_PV} --prefix=\"${D}usr\" --layout=system"

	if use static-libs; then
		OPTIONS+=" link=shared,static"
		LIBRARY_TARGETS="*.a.${PV} *$(get_libname ${PV})"
	else
		OPTIONS+=" link=shared"
		# There is no dynamically linked version of libboost_test_exec_monitor and libboost_exception.
		LIBRARY_TARGETS="libboost_test_exec_monitor.a.${PV} libboost_exception.a.${PV} *$(get_libname ${PV})"
	fi
}

src_compile() {
	local jobs
	jobs=$( echo " ${MAKEOPTS} " | \
		sed -e 's/ --jobs[= ]/ -j /g' \
			-e 's/ -j \([1-9][0-9]*\)/ -j\1/g' \
			-e 's/ -j\>/ -j1/g' | \
			( while read -d ' ' j; do if [[ "${j#-j}" = "$j" ]]; then continue; fi; jobs="${j#-j}"; done; echo ${jobs} ) )
	if [[ "${jobs}" != "" ]]; then NUMJOBS="-j"${jobs}; fi

	export BOOST_ROOT="${S}"
	PYTHON_DIRS=""
	MPI_PYTHON_MODULE=""

	building() {
		create_user-config.jam

		ejam ${OPTIONS} \
			$(use python && echo --python-buildid=${EPYTHON#python}) \
			|| die "Building of Boost libraries failed"

		# ... and do the whole thing one more time to get the debug libs
		if use debug; then

			ejam ${OPTIONS} \
				--buildid=debug \
				$(use python && echo --python-buildid=${EPYTHON}) \
				|| die "Building of Boost debug libraries failed"
		fi

		if use python; then
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
	if use python; then
		python_foreach_impl building
	else
		building
	fi

	if use tools; then
		pushd tools > /dev/null || die

		ejam ${OPTIONS} \
			|| die "Building of Boost tools failed"
		popd > /dev/null || die
	fi
}

src_install () {
	installation() {
		create_user-config.jam

		if use python; then
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
		fi

		ejam ${OPTIONS} \
			--includedir="${ED}usr/include/boost-${MAJOR_V}" \
			--libdir="${ED}usr/$(get_libdir)" \
			$(use python && echo --python-buildid=${EPYTHON#python}) \
			install || die "Installation of Boost libraries failed"

		if use debug; then

			ejam -q -d+2 \
				gentoodebug \
				--user-config=user-config.jam \
				${OPTIONS} \
				threading=single,multi ${LINK_OPTS} runtime-link=shared \
				--includedir="${D}usr/include" \
				--libdir="${D}usr/$(get_libdir)" \
				--buildid=debug \
				$(use python && echo --python-buildid=${EPYTHON}) \
				install || die "Installation of Boost debug libraries failed"
		fi

		if use python; then
			rm -r ${PYTHON_DIRS} || die

			# Move mpi.so Python module to Python site-packages directory and make sure it is slotted.
			# https://svn.boost.org/trac/boost/ticket/2838
			if use mpi; then
				local moddir=$(python_get_sitedir)/boost_${MAJOR_V}
				# moddir already includes eprefix
				mkdir -p "${D}${moddir}" || die
				mv "${ED}usr/$(get_libdir)/mpi.so" "${D}${moddir}" || die
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

	dodir /usr/share/boost-eselect/profiles/${MAJOR_V}
	touch "${D}usr/share/boost-eselect/profiles/${MAJOR_V}/default" || die
	if use debug; then
		touch "${D}usr/share/boost-eselect/profiles/${MAJOR_V}/debug" || die
	fi

	if use python; then
		python_foreach_impl installation
	else
		installation
	fi

	if use mpi && use python; then
		_add_line "\""
	fi

	if ! use python; then
		rm -rf "${ED}"usr/include/boost-${MAJOR_V}/boost/python* || die
	fi

	if use doc; then
		find libs/*/* -iname "test" -or -iname "src" | xargs rm -rf
		dohtml \
			-A pdf,txt,cpp,hpp \
			*.{htm,html,png,css} \
			-r doc
		dohtml -A pdf,txt -r tools
		insinto /usr/share/doc/${PF}/html
		doins -r libs
		doins -r more

		# To avoid broken links
		insinto /usr/share/doc/${PF}/html
		doins LICENSE_1_0.txt

		dosym /usr/include/boost-${MAJOR_V}/boost /usr/share/doc/${PF}/html/boost
	fi

	pushd "${ED}"usr/$(get_libdir) > /dev/null || die

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
		[[ -e "${f}" ]] || die  "Can not add version to ${f} -- file does not exist"
		mv "${f}" "${f}.${PV}"
	done

	_add_line "libs=\"" default
	local f
	for f in $(ls -1 ${LIBRARY_TARGETS} | grep -v debug); do
		if [[ -e "${f}" ]]; then
			local slot_target="${f//.${PV}}"
			local slot_source="${slot_target}.${MAJOR_V}"
			[[ -e "${slot_source}" ]] || dosym "${LIBDIR}/${f}" "${LIBDIR}/${slot_source}"	# install major-version
			# [[ -e "${slot_target}" ]] || dosym "${LIBDIR}/${f}" "${LIBDIR}/${slot_target}"	# install final target (versionless)
			_add_line "${LIBDIR}/${slot_source}" default
		else
			ewarn "Missing or invalid library name: ${f}"
		fi
	done
	_add_line "\"" default

	# The same goes for the mpi libs
	if use mpi; then
		if use static-libs; then
			MPI_LIBS="libboost_mpi-mt.${MAJOR_V}.a libboost_mpi-mt.${MAJOR_V}${LIBEXT}"
		else
			MPI_LIBS="libboost_mpi-mt.${MAJOR_V}${LIBEXT}"
		fi
		local lib
		for lib in ${MPI_LIBS}; do
			dosym ${lib} "${LIBDIR}/${lib/-mt/}"
		done
	fi

	if use debug; then
		if use static-libs; then
			THREAD_DEBUG_LIBS="libboost_thread-mt.${MAJOR_V}-debug${LIBEXT} libboost_thread-mt.${MAJOR_V}-debug.a"
		else
			THREAD_DEBUG_LIBS="libboost_thread-mt.${MAJOR_V}-debug${LIBEXT}"
		fi

		local lib
		for lib in ${THREAD_DEBUG_LIBS}; do
			dosym ${lib} "${LIBDIR}/${lib/-mt/}"
		done

		if use mpi; then
			if use static-libs; then
				MPI_DEBUG_LIBS="libboost_mpi-mt.${MAJOR_V}-debug.a libboost_mpi-mt.${MAJOR_V}-debug${LIBEXT}"
			else
				MPI_DEBUG_LIBS="libboost_mpi-mt.${MAJOR_V}-debug${LIBEXT}"
			fi

			local lib
			for lib in ${MPI_DEBUG_LIBS}; do
				dosym ${lib} "${LIBDIR}/${lib/-mt/}"
			done
		fi
	fi

	_add_line "includes=\"/usr/include/boost-${MAJOR_V}/boost\"" default
	# dosym /usr/include/boost-${MAJOR_V}/boost /usr/include/boost

	popd > /dev/null || die

	if use tools; then
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

		pushd dist > /dev/null || die
		insinto /usr/share
		doins -r share/boostbook
		# Append version postfix for slotting
		mv "${D}usr/share/boostbook" "${D}usr/share/boostbook-${MAJOR_PV}" || die
		_add_line "dirs=\"/usr/share/boostbook-${MAJOR_PV}\""
		# dosym /usr/share/boostbook-${MAJOR_PV} /usr/share/boostbook
		popd > /dev/null || die
	fi

	pushd status > /dev/null || die
	if [[ -f regress.log ]]; then
		docinto status
		dohtml *.html ../boost.png
		dodoc regress.log
	fi
	popd > /dev/null || die

	# boost's build system truely sucks for not having a destdir.  Because for
	# this reason we are forced to build with a prefix that includes the
	# DESTROOT, dynamic libraries on Darwin end messed up, referencing the
	# DESTROOT instread of the actual EPREFIX.  There is no way out of here
	# but to do it the dirty way of manually setting the right install_names.
	if [[ ${CHOST} == *-darwin* ]]; then
		einfo "Working around completely broken build-system(tm)"
		local d
		for d in "${ED}"usr/lib/*.dylib; do
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

pkg_preinst() {
	# Yai for having symlinks that are nigh-impossible to remove without
	# resorting to dirty hacks like these. Removes lingering symlinks
	# from the slotted versions.
	local symlink
	for symlink in "${EROOT}usr/include/boost" "${EROOT}usr/share/boostbook"; do
		[[ -L ${symlink} ]] && rm -f "${symlink}"
	done
}

# the tests will never fail because these are not intended as sanity
# tests at all. They are more a way for upstream to check their own code
# on new compilers. Since they would either be completely unreliable
# (failing for no good reason) or completely useless (never failing)
# there is no point in having them in the ebuild to begin with.
src_test() { :; }

pkg_postinst() {
	if use eselect; then
		eselect boost update || ewarn "eselect boost update failed."
	fi

	if [[ ! -h "${ROOT}etc/eselect/boost/active" ]]; then
		elog "No active boost version found. Calling eselect to select one..."
		eselect boost update || ewarn "eselect boost update failed."
	fi
}