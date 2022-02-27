#!/bin/bash
 
# ==================================================================================================
# CREATELAUNCHER.SH
# ==================================================================================================
 
# =[ CHECK REQUIREMENT PACKAGES ]===================================================================
function checkPackage(){
    [[ $# -lt 1 || $# -gt 2 ]] &&(echo "command checkPackage failed, take 1 or 2 arguments.";exit 12)
    cmd=$1
    [[ -z $2 ]] && package=$1 || package=$2
    if ! which $1 > /dev/null;then
        echo -e "Command ${cmd} not found!Do you want to install ${package}? (y/n) \n"
        read
        if [ ${REPLY} == "y" ];then
            sudo apt install $package
        else
            echo -e "Unfortunately, since ${package} is required to use this script and you don't want to install it, this script will stop here.:'("
        fi
    else
        echo "${cmd}..OK! ${package} is installed"
    fi
}
 
# ==================================================================================================
# MAIN
# ==================================================================================================

checkPackage zenity               # CheckIf zenity cmd is available
checkPackage convert imagemagick  # CheckIf convert cmd from imagemagick package is available
