# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

source /etc/profile

export PATH="$HOME/bin:$PATH"

unset LANG
export LC_CTYPE="ru_RU.utf8"
export LC_COLLATE="POSIX"
export LC_MESSAGES="POSIX"
export LC_NUMERIC="POSIX"

function m() {
	make -j4 "$@"
	local res="$?"
	case "$res" in
		0) echo -e "\033[01;32mOK\033[00m"  ;;
		*) echo -e "\033[01;31mFAILED\033[00m: code $res" ;;
	esac
	return $res
}

alias CM="cmake -DCMAKE_BUILD_TYPE=Debug .. && gmake -j6"
alias cm="cmake -DCMAKE_BUILD_TYPE=Release .. && gmake -j6"

alias nltp="netstat -nltp"
alias nlup="netstat -nlup"
alias nlp="netstat -nltup"

alias ll='ls -l'

alias calg="valgrind --tool=callgrind"
alias valg="valgrind --track-origins=yes"

export UNCRUSTIFY_CONFIG=".uncrustify"

function ghead() {
	git lv ${1:-} | head -n ${2:-5}
}

function gbr() {
	git co -b "${1}" "origin/${2:-$1}"
}

backtrace() {
	local exe="$1"
	local core="$2"
	gdb ${exe} --core ${core} --batch --quiet \
		-ex "thread apply all bt full" \
		-ex "quit"
}
