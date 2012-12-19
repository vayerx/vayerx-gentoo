source /etc/profile

export PATH="$HOME/bin:$PATH"

function m() {
	make -j4 "$@"
	local res="$?"
	case "$res" in
		0) echo -e "\033[01;32mOK\033[00m"  ;;
		*) echo -e "\033[01;31mFAILED\033[00m: code $res" ;;
	esac
	return $res
}

alias valg="valgrind --track-origins=yes"
alias nltp="netstat -nltp"
alias ll='ls -l'

function ghead() {
	git lv ${1:-} | head -n ${2:-5}
}

backtrace() {
	local exe="$1"
	local core="$2"
	gdb ${exe} --core ${core} --batch --quiet \
		-ex "thread apply all bt full" \
		-ex "quit"
}
