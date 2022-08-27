#!/usr/bin/env bash
# -*- coding: UTF-8 -*-
## Helper script to sync Adwaita from upstream to a destination folder
## usage:
##
##      gnome-shell-sync.sh --destination <path>
##
## options:
##    -d, --destination <path>    Destination folder - mandatory
##    -b, --branch <name>         Branch name
# CLInt GENERATED_CODE: start

# No-arguments is not allowed
[ $# -eq 0 ] && sed -ne 's/^## \(.*\)/\1/p' $0 && exit 1

# Converting long-options into short ones
for arg in "$@"; do
  shift
  case "$arg" in
"--destination") set -- "$@" "-d";;
"--branch") set -- "$@" "-b";;
  *) set -- "$@" "$arg"
  esac
done

function print_illegal() {
    echo Unexpected flag in command line \"$@\"
}

# Parsing flags and arguments
while getopts 'hab:d:' OPT; do
    case $OPT in
        h) sed -ne 's/^## \(.*\)/\1/p' $0
           exit 1 ;;
        d) _destination=$OPTARG ;;
        b) _branch=$OPTARG ;;
        \?) print_illegal $@ >&2;
            echo "---"
            sed -ne 's/^## \(.*\)/\1/p' $0
            exit 1
            ;;
    esac
done

pushd /tmp
git clone --branch ${_branch} --depth 1 https://gitlab.gnome.org/GNOME/gnome-shell.git
popd

rm -rf ${_destination}
mkdir -p ${_destination} ${_destination}/data
cp -a /tmp/gnome-shell/data/theme ${_destination}
cp -a /tmp/gnome-shell/data/gnome-shell-theme.gresource.xml ${_destination}/data/
cp -a /tmp/gnome-shell/data/gnome-shell-icons.gresource.xml ${_destination}/data/
cp -a /tmp/gnome-shell/data/icons ${_destination}/data/

rm -rf /tmp/gnome-shell
