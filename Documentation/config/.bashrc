# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi

source /etc/profile

export PATH="$HOME/bin:$PATH"
export PYTHONPATH="${HOME}/python:${PYTHONPATH}"

export HISTFILESIZE=5000

export GPG_TTY=$(tty)

NJOBS=$(nproc)
export CTEST_OUTPUT_ON_FAILURE=1

if [ "$TERM" = screen ]; then
    export TERM="xterm"
fi

unset LANG
export LC_CTYPE="ru_RU.utf8"
export LC_COLLATE="POSIX"
export LC_MESSAGES="POSIX"
export LC_NUMERIC="POSIX"

function print_ecode() {
    local ecode="$1"; shift
    if [ $ecode -eq 0 ]; then
        echo -e "$@${@:+ }\033[01;32mSUCCEEDED\033[00m"
    else
        echo -e "$@${@:+ }\033[01;31mFAILED\033[00m (code $ecode)"
    fi
    return ${ecode}
}

function chk() {
    CLICOLOR_FORCE=1 "$@"
    local ecode=$?
    print_ecode $ecode
    return $ecode
}

function m() {
    chk make -j$NJOBS "$@"
}

alias CM="cmake -DCMAKE_BUILD_TYPE=Debug .. && gmake -j$NJOBS"
alias cm="cmake -DCMAKE_BUILD_TYPE=Release .. && gmake -j$NJOBS"

alias nltp="netstat -nltp"
alias nlup="netstat -nlup"
alias nlp="netstat -nltup"

alias ll='ls -l'

# Valgrind
alias calg="valgrind --tool=callgrind"
alias valg="valgrind --track-origins=yes --num-callers=30"
alias valm="valgrind --track-origins=yes --leak-check=full --show-leak-kinds=definite --num-callers=30"
alias valf="valgrind --track-origins=yes --leak-check=full --show-leak-kinds=all --num-callers=30"
alias helg="valgrind --tool=helgrind --free-is-write=yes"
alias masf="valgrind --tool=massif --heap=yes --stacks=no --depth=50 --max-snapshots=1000 --time-unit=ms"

function masf_dump() {
    local pids=${1:-$(pgrep massif)}
    for pid in ${pids}; do
        local dump_base="${2:-massif-${pid}}-$(date +%Y-%m-%d_%H-%M)"
        vgdb --pid=${pid} all_snapshots "${dump_base}.dump"
        ms_print "${dump_base}.dump" > "${dump_base}.txt"
    done
}


# Docker
for cmd in cp help info kill load ps save rm rmi run stop; do
    alias d${cmd}="docker $cmd"
done
alias dimg="docker images"
alias dbuild="docker build --force-rm=true --rm=true"
for cmd in stop kill; do
    alias d${cmd}all="docker ps -q | xargs --no-run-if-empty docker ${cmd}"
done

export UNCRUSTIFY_CONFIG=".uncrustify"

# Git
function ghead() {
    git lv --color=always ${1:-} | head -n ${2:-7}
}

function gheadn() {
    git lv | head -n ${1:-7}
}

function glast() {
    local head="${1:-HEAD}"
    local wday="$2"
    [ -z "$wday" ] && { [ $(date '+%w') -eq 1 ] && wday=3 || wday=1; }
    local date=$(date --date "${wday} days ago" '+%a, %e %b %Y' | sed 's/  / /')
    echo "Commits of $date"
    git lvf ${head} | grep "$(git config user.name).*$date"
}

function gcherry() {
    local upstream="${1:?no upstream}" # isn't used -- "$@"
    git cherry "$@" | while read act rev; do echo -n "$act "; git lv $rev | head -n 1; done
}

function gremote() {
    git rev-parse --abbrev-ref --symbolic-full-name @{u}
}

function gchr() {
    gcherry $(gremote) "$@"
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

function git_branch() {
    git br 2>/dev/null | sed -n 's/* \(.*\)/(\1) /p'
}


function backtrace() {
    local exe="${1:?no exe file}"
    local core="${2:?no core file}"
    local opts="${3}"
    gdb ${exe} --core ${core} --batch --quiet \
        -ex "thread apply all bt ${opts}" \
        -ex "quit"
}

function sortit() {
    local src="${1:?no file}"
    for src in "$@"; do
        local dest="$(mktemp)"
        LC_COLLATE="POSIX" sort -u $src > $dest && mv $dest $src || rm $dest
    done
}

function sortitru() {
    local src="${1:?no file}"
    for src in "$@"; do
        local dest="$(mktemp)"
        LC_COLLATE="ru_RU.utf8" sort -u $src > $dest && mv $dest $src || rm $dest
    done
}

# Oh, Dear God, You can't imagine how much do I hate autotools (c) gtest.ebuild
function autofuck() {
    for op in "autoconf -i" autoheader aclocal "automake --add-missing"; do
        ${op}
        print_ecode $? ${op} || return $?
    done
}

function autorefuck() {
    autoreconf --install
}

function xme() {
    local bin="${1:?no binary}"
    binary="$(which ${bin})"
    xinit "${binary}" -- :1
}

alias nunah="echo -e \\033c"
alias blya="xrandr --fb 3840x1080 --output DVI-0 --mode 1920x1080 --pos 0x0 --output DisplayPort-0 --mode 1920x1080 --pos 1920x0"

function fciv() {
    local file="${1:+--file $1}"
    local fcdb="${HOME}/.freeciv/fcdb.conf"
    if [[ ! -f "$fcdb" ]]; then
        mkdir -p $(dirname "$fcdb")
        cat <<EOF > $fcdb
[fcdb]
backend="sqlite"
database="${HOME}/.freeciv/fcdb.sqlite"
EOF
    fi

    freeciv-server --saves ${HOME}/.freeciv/net --scenarios /usr/share/games/freeciv/scenarios --Database ${HOME}/.freeciv/fcdb.conf --auth --Newusers $file
}

function exif2date() {
    fname="${1:?no file specified}"
    touch -t $(exiftool -p '$DateTimeOriginal' "$fname" | sed 's/[: ]//g;s/\(..$\)/\.\1/') "$fname"
}

function e2d_dir() {
    dir="${1:-.}"
    find "$dir" -iname '*.jpg' -or -iname '*.nef' | while read fname; do echo $fname; exif2date "$fname"; done

}

alias emerge-min-update="emerge -quDN --keep-going --verbose-conflicts"
alias emerge-update="emerge-min-update --with-bdeps\=y --changed-deps"
alias emerge-preserved="emerge -q --keep-going @preserved-rebuild"
alias emerge-modules="emerge -q --keep-going @module-rebuild"
alias emerge-x11-modules="emerge -q --keep-going @x11-module-rebuild"
alias emerge="emerge --verbose-conflicts"

alias pretty_json="python -c 'import sys, json; json.dump(json.load(sys.stdin), sys.stdout, indent=4, sort_keys=True)'"

function upkernel() {
    genkernel --kernel-config=/etc/kernels/kernel-config-$(uname -r) "$@" all
    emerge-modules
    grub-mkconfig -o /boot/grub/grub.cfg
}

alias quickpkg="quickpkg --include-config=y"
alias wget="wget --no-use-server-timestamps"


# Change the window title of X terminals
case ${TERM} in
    [kx]term*|gnome*|konsole*)
        PS1='\[\033]0;\u@\h:\w\007\]'
        ;;
    screen*)
        PS1='\[\033k\u@\h:\w\033\\\]'
        ;;
    *)
    unset PS1
        ;;
esac

if [[ ${EUID} == 0 ]] ; then
    PS1+='\[\033[01;31m\]\h\[\033[01;34m\] \w \$\[\033[00m\] '
else
    PS1+='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \[\033[33m\]`git_branch`\[\033[01;34m\]\$\[\033[00m\] '
fi

umask 0002
