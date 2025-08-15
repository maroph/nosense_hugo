#!/bin/bash
#
##############################################
# Copyright (c) 2025 by Manfred Rosenboom    #
# https://maroph.github.io/ (maroph@pm.me)   #
#                                            #
# This work is licensed under a MIT License. #
# https://choosealicense.com/licenses/mit/   #
##############################################
COPYRIGHT="Copyright (C) 2025 Manfred Rosenboom"
LICENSE="License: MIT <https://choosealicense.com/licenses/mit/>"
#
###############################################################################
#
declare -r SCRIPT_NAME=$(basename $0)
declare -r VERSION="0.1.0"
declare -r VERSION_DATE="15-AUG-2025"
declare -r VERSION_STRING="${SCRIPT_NAME}  ${VERSION}  (${VERSION_DATE})"
#
SCRIPT_DIR=$(dirname $0)
#
cwd=$(pwd)
if [ "${SCRIPT_DIR}" = "." ]
then
    SCRIPT_DIR=${cwd}
else
    cd ${SCRIPT_DIR} || exit 1 
    SCRIPT_DIR=$(pwd)
    cd ${cwd} || exit 1
fi
cwd=
unset cwd
#
declare -r SCRIPT_DIR
#
###############################################################################
#
dryrun=0
#
###############################################################################
#
print_usage() {
    cat <<EOT

Usage: ${SCRIPT_NAME} [<options>]
       Create static site and deploy data to the gh-pages branch"

    Options:
    -h|--help    : show this help text and exit
    -V|--version : show version information and exit
    --dry-run    : Don't actually execute ${SCRIPT_NAME}, just print
                   what would be invoked.

EOT
}
#
###############################################################################
#
while :
do
    option=$1
    case "$1" in
        -h | --help)    
            print_usage
            exit 0
            ;;
        -V | --version)
            echo "${VERSION_STRING}"
            echo "${COPYRIGHT}"
            echo "${LICENSE}"
            exit 0
            ;;
        --dry-run)
            dryrun=1
            ;;
        --*)
            echo "${SCRIPT_NAME}: '$1' : unknown option"
            exit 1
            ;;
        -*)
            echo "${SCRIPT_NAME}: '$1' : unknown option"
            exit 1
            ;;
        *)  break;;
    esac
#
    shift 1
done
#
###############################################################################
#
if [ $# -ne 0 ]
then
    echo "${SCRIPT_NAME}: no argument(s) expected"
    exit 1
fi
#
###############################################################################
#
h=$(type -p hugo)
if [ "$h" = "" ]
then
    echo "${SCRIPT_NAME}: can't find command hugo"
    exit 1
fi
unset h
#
g=$(type -p ghp-import)
if [ "$g" = "" ]
then
    echo "${SCRIPT_NAME}: can't find command ghp-import"
    exit 1
fi
unset g
#
###############################################################################
#
echo "${SCRIPT_NAME}: hugo build ..."
if [ ${dryrun} -eq 0 ]
then
    hugo build || exit 1
else
    echo "${SCRIPT_NAME}: hugo build"
fi
echo ""
echo "----------"
echo ""
#
###############################################################################
#
echo "${SCRIPT_NAME}: ghp-import ./public ..."
if [ ${dryrun} -eq 0 ]
then
    ghp-import --no-jekyll --push --no-history ./public || exit 1
else
    echo "${SCRIPT_NAME}: ghp-import --no-jekyll --push --no-history ./public"
fi
#
###############################################################################
#
exit 0

