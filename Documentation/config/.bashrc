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

# Valgrind
alias calg="valgrind --tool=callgrind"
alias valg="valgrind --track-origins=yes --num-callers=30"
alias valm="valgrind --track-origins=yes --leak-check=full --show-leak-kinds=definite --num-callers=30"
alias helg="valgrind --tool=helgrind --free-is-write=yes"

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
    git lv ${1:-} | head -n ${2:-5}
}

function gheadn() {
    git lv | head -n ${1:-7}
}

function glast() {
    local wday="$1"
    [ -z "$wday" ] && { [ $(date '+%w') -eq 1 ] && wday=3 || wday=1; }
    local date=$(date --date "${wday} days ago" '+%a, %e %b %Y' | sed 's/  / /')
    echo "Commits of $date"
    git lvf | grep "$(git config user.name).*$date"
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

function gpull() {
    git stash
    git pull $@
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

function sortitru() {
    local src="${1:?no file}"
    local dest="$(mktemp)"
    LC_COLLATE="ru_RU.utf8" sort -u $src > $dest && mv $dest $src || rm $dest
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

alias emerge-update="emerge -quDN --keep-going --verbose-conflicts --with-bdeps\=y world"
alias emerge-preserved="emerge -q --keep-going @preserved-rebuild"
alias emerge-modules="emerge -q --keep-going @module-rebuild"
alias emerge-x11-modules="emerge -q --keep-going @x11-module-rebuild"
alias emerge-update-world="emerge -avquDN --keep-going --with-bdeps=y --verbose-conflicts world"

umask 0002
