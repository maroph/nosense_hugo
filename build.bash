#!/bin/bash
#
####################################################
# Copyright (c) 2025 by Manfred Rosenboom          #
# https://maroph.github.io/ (maroph@pm.me)         #
#                                                  #
# This work is licensed under a CC-BY 4.0 License. #
# https://creativecommons.org/licenses/by/4.0/     #
####################################################
COPYRIGHT="Copyright (C) 2025 Manfred Rosenboom."
LICENSE="License: CC-BY 4.0 <https://creativecommons.org/licenses/by/4.0/>"
#
declare -r SCRIPT_NAME=$(basename $0)
declare -r VERSION="0.1.0"
declare -r VERSION_DATE="23-AUG-2025"
declare -r VERSION_STRING="${SCRIPT_NAME}  ${VERSION}  (${VERSION_DATE})"
#
###############################################################################
#
SCRIPT_DIR=`dirname $0`
cwd=`pwd`
if [ "${SCRIPT_DIR}" = "." ]
then
    SCRIPT_DIR=$cwd
else
    cd ${SCRIPT_DIR}
    SCRIPT_DIR=`pwd`
    cd $cwd
fi
cwd=
unset cwd
declare -r SCRIPT_DIR
#
###############################################################################
#
export LANG="en_US.UTF-8"
#
if [ -d ${SCRIPT_DIR}/.git ]
then
    gitrepo=1
else
    gitrepo=0
fi
#
GHP_IMPORT=""
if [ -x ~/bin/ghp-import.bash ]
then
    GHP_IMPORT="~/bin/ghp-import.bash"
fi
#
###############################################################################
#
print_usage() {
    cat - <<EOT

Usage: ${SCRIPT_NAME} [option(s)] [build|deploy|serve|shut]
       Call Hugo to build the web site related files

Options:
  -h|--help       : show this help and exit
  -V|--version    : show version information and exit

  Arguments
  build         : create the site data (default)
                  Location: public
  serve         : create the site and run the Hugo development web server
  shut          : shutdown Hugo development web server
  deploy        : create the site and push all data to branch gh-pages

  Working directory : ${SCRIPT_DIR}

  Deployment is only availabe from within a Git repository and the installed
  Python module ghp-import (https://pypi.org/project/ghp-import/).

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
            echo ${VERSION_STRING}
            echo "${COPYRIGHT}"
            echo "${LICENSE}"
            exit 0
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
if [ "$1" != "" ]
then
    case "$1" in
        build)  ;;
        deploy) ;;
        serve)  ;;
        shut)
            echo "${SCRIPT_NAME}: shutdown Hugo development web server"
            pkill -15 hugo || exit 1
            exit 0
            ;;
        *)
            echo "${SCRIPT_NAME}: '$1' : unknown build command"
            exit 1
            ;;
    esac
fi
#
###############################################################################
#
cd ${SCRIPT_DIR} || exit 1
#
if [ "$(type -p hugo)" = "" ]
then
    echo "${SCRIPT_NAME}: can't find command hugo"
    exit 1
fi
#
###############################################################################
#
if [ "$1" = "deploy" ]
then
    if [ ${gitrepo} -eq 0 ]
    then
        echo "${SCRIPT_NAME}: current directory is not a Git repository"
        exit 1
    fi
#
    if [ "${GHP_IMPORT}" = "" ]
    then
        python3 -m pip show ghp-import >/dev/null 2>/dev/null
        if [ $? -ne 0 ]
        then
            echo "${SCRIPT_NAME}: Python module ghp-import not available"
            exit 1
        fi

#
        GHP_IMPORT="ghp-import"
    fi
#
    echo "${SCRIPT_NAME}: hugo build "
    hugo build || exit 1
    echo ""
#
    echo "${SCRIPT_NAME}: ghp-import --no-jekyll --push --no-history ./public"
    ${GHP_IMPORT} --no-jekyll --push --no-history ./public || exit 1
    echo ""
    exit 0
fi
#
###############################################################################
#
if [ "$1" = "serve" ]
then
    echo "${SCRIPT_NAME}: hugo server ..."
    hugo server --disableFastRender &
    exit 0
fi
#
###############################################################################
#
echo "${SCRIPT_NAME}: hugo build"
hugo build || exit 1
echo ""
#
if [ ${gitrepo} -eq 1 ]
then
    echo "${SCRIPT_NAME}: git status"
    git status
fi
#
###############################################################################
#
exit 0
