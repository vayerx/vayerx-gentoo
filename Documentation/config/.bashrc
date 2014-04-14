# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi

source /etc/profile

export PATH="$HOME/bin:$PATH"

NJOBS=4

if [ "$TERM" = screen ]; then
    export TERM="xterm"
fi

unset LANG
export LC_CTYPE="ru_RU.utf8"
export LC_COLLATE="POSIX"
export LC_MESSAGES="POSIX"
export LC_NUMERIC="POSIX"

function m() {
    make -j$NJOBS "$@"
    local res="$?"
    case "$res" in
        0) echo -e "\033[01;32mOK\033[00m"  ;;
        *) echo -e "\033[01;31mFAILED\033[00m: code $res" ;;
    esac
    return $res
}

alias CM="cmake -DCMAKE_BUILD_TYPE=Debug .. && gmake -j$NJOBS"
alias cm="cmake -DCMAKE_BUILD_TYPE=Release .. && gmake -j$NJOBS"

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
    git co -b "${1:?no branch name}" "origin/${2:-$1}"
}

function grebase() {
    local target="origin/${1:-devel}"
    git stash
    git rebase $target
    git stash pop
}

function backtrace() {
    local exe="${1:?no exe file}"
    local core="${2:?no core file}"
    gdb ${exe} --core ${core} --batch --quiet \
        -ex "thread apply all bt full" \
        -ex "quit"
}

function sortit() {
    local src="${1:?no file}"
    local dest="$(mktemp)"
    LC_COLLATE="POSIX" sort -u $src > $dest && mv $dest $src || rm $dest
}

# Oh, Dear God, You can't imagine how much do I hate autotools (c) gtest.ebuild
function autofuck() {
    autoconf
    autoheader
    aclocal
    automake --add-missing
}

function xme() {
    local bin="${1:?no binary}"
    binary="$(which ${bin})"
    xinit "${binary}" -- :1
}
umask 0002
