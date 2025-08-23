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
declare -r VERSION_DATE="23-AUG-2025"
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
: ${EDITOR=/usr/bin/vi}
: ${VISUAL=$EDITOR}
umask 0027
#
do_edit=1
is_page=0
draft="false"
#
###############################################################################
#
print_usage() {
    cat <<EOT

Usage: ${SCRIPT_NAME} [<options>] <filename>
       Create a new Pelican item (post or page) file.

    Options:
    -h|--help     : show this help text and exit
    -V|--version  : show version information and exit
    --list        : TODO
    --list-pages  : TODO
    --list-posts  : TODO
    --list-static : TODO
    -n|--no-edit  : TODO
    -p|--page     : create a page (default: post)
    --draft       : set draft to true

    Argument:
    filename : name of Markdown file (*.md) to create

    The given path of the file name will be prepend with
     "content/posts/" (post) or "content/pages/" (page).

EOT
}
#
###############################################################################
#
cd ${SCRIPT_DIR} || exit 1 
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
        --list)
            find content -print | sed -e '/^content$/d' -e 's!^content/!!'
            exit 0
            ;;
        --list-pages)
            find content/pages -print | sed -e '/^content.pages$/d' -e 's!^content/pages/!!' -e '/^pages$/d'
            exit 0
            ;;
        --list-posts)
            find content/posts -print | sed -e '/^content.posts$/d' -e 's!^content/posts/!!' -e '/^posts$/d'
            exit 0
            ;;
        --list-static)
            find static -print | sed -e '/^static$/d' -e 's!^static/!!'
            exit 0
            ;;
        -n | --no-edit)
            do_edit=0
            ;;
        -p | --page)
            is_page=1
            ;;
        --draft)
            draft="true"
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
# https://wizardzines.com/comics/bash-errors/
set -eo pipefail
# set -euo pipefail
# set -e          : stop script on error
# set -u          : stop script on unset variables
# set -o pipefail : make pipe fail if any command fails
#
###############################################################################
#
if [ $# -eq 0 ]
then
    echo "${SCRIPT_NAME}: item filename missing"
    exit 1
fi
#
if [ ${is_page} -eq 1 ]
then
    file="content/pages/$1"
else
    file="content/posts/$1"
fi
#
###############################################################################
#
if [ -f ${file} ]
then
    # echo "${SCRIPT_NAME}: item file already exist: ${file}"
    # exit 1
    ${VISUAL} ${file}
    exit $?
fi
#
if [ ${is_page} -eq 0 ]
then
    if [[ ${file} == content/pages/* ]]
    then
        echo "${SCRIPT_NAME}: don't create post items in the pages directory"
        exit 1
    fi
fi
#
# echo "file : $file"
#dir=$(dirname ${file})
dir=${file%/*}
ext="${file##*.}"
#
#echo "dir  : $dir"
#echo "ext  : $ext"
#
if [ "${ext}" != "md" ]
then
    echo "${SCRIPT_NAME}: ${ext}: wrong file extension"
    exit 1
fi
#
###############################################################################
#
mkdir -p ${dir} || exit 1
touch ${file} || exit 1
#
###############################################################################
#
title=$(basename ${file} .md | tr '-' ' ' | tr '_' ' ')
#
arr=( ${title} )
title="${arr[@]^}"
#
if [ ${is_page} -eq 1 ]
then
    echo "${SCRIPT_NAME}: create page item file ${file}"
else
    echo "${SCRIPT_NAME}: create post item file ${file}"
fi
#
#
# item metadata:
# https://gohugo.io/content-management/front-matter/
#
echo "+++" > ${file}
echo "date = '$(date +"%Y-%m-%dT%H:%M:%S%:z")'" >> ${file}
echo "draft = ${draft}" >> ${file}
echo "title = '${title}'" >> ${file}
echo "+++" >> ${file}
#
echo "" >> ${file}
echo "Text goes here" >> ${file}
#
###############################################################################
#
if [ ${do_edit} -eq 1 ]
then
    ${VISUAL} ${file}
fi
#
###############################################################################
#
exit 0

