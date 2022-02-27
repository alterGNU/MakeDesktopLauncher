#!/bin/bash
 
# ==================================================================================================
# CREATELAUNCHER.SH
# ==================================================================================================

# =[ ERRORS ]=======================================================================================
# ERROR12 => checkPackage         : invalid number of arguments

# =[ VARIABLES ]====================================================================================
folderPath="${HOME}/.local/share/applications/"
folderName=""
imagePath=""

# =[ CHECK REQUIREMENT PACKAGES ]===================================================================
function checkPackage(){
    [[ $# -lt 1 || $# -gt 2 ]] && { echo -e "ERROR12: checkPackage() call failed, take 1 or 2 arguments." ; exit 12 ; }
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
        echo -e " - ${cmd}..OK! ${package} is installed"
    fi
}
 
# -[ ASK USER FOLDER'S NAME ]-----------------------------------------------------------------------
function askName(){
    name=$(zenity --entry --title="Creating the launcher" --text="Enter the name of the application")
    compliantName=$(echo "${name//[!a-zA-Z0-9]/}")
    echo ${compliantName}
}

# -[ SELECT IMAGE ]---------------------------------------------------------------------------------
function selectImage(){
    imagePath=$(zenity --file-selection --title="Selectionner l'icône de l'application" --filename=/home/)
    echo \"${imagePath}\"
}

# -[ CHECK IMAGE EXTENSION ]------------------------------------------------------------------------
function isNotASupportedFormat(){
    if eval identify ${@} &> /dev/null ;then
        ext=$(eval identify -format '%m' ${@})
        if [ "${ext}" = "JPEG" ] || [ "${ext}" = "XPM" ] || [ "${ext}" = "SVG" ] || [ "${ext}" = "PNG" ];then
            return 1
        else
            return 0
        fi
    else
        return 0
    fi
}

# -[ CREATE ICON ]----------------------------------------------------------------------------------
function createIcon(){
    long=$(eval identify -format '%W' ${imagePath})
    larg=$(eval identify -format '%H' ${imagePath})
    if [ ${long} -gt 512 ] && [ ${larg} -gt 512 ];then
        format=512x512
        fileName="${folderPath}${folderName}/${folderName}_512x512.png"
    elif [ ${long} -lt ${larg} ];then
        format=${long}x${long}
        fileName="${folderPath}${folderName}/${folderName}_${long}x${long}.png"
    else
        format=${larg}x${larg}
        fileName="${folderPath}${folderName}/${folderName}_${larg}x${larg}.png"
    eval convert ${imagePath} -resize ${format}! ${fileName}
    eval chmod +x ${fileName}
    echo "convert: create an icon '${fileName}'"
    fi
}

# ==================================================================================================
# MAIN
# ==================================================================================================

echo -e "Check Requirements Packages:"
checkPackage zenity               # CheckIf zenity cmd is available
checkPackage identify imagemagick # CheckIf convert cmd from imagemagick package is available
checkPackage convert imagemagick  # CheckIf convert cmd from imagemagick package is available

echo -e "\nCreate Folder:"
# ask a folder name while it's is empty or already taken
while [ -e "${folderPath}${folderName}" ] || [ "${folderName}" == "" ] ;do folderName=$(askName);done
mkdir -p "${folderPath}${folderName}/" -v

echo -e "\nCreate Icon:"
# ask for a path to an image that can be used as an icon until it is
while [ "${imagePath}" == "" ] || isNotASupportedFormat ${imagePath};do imagePath=$(selectImage);done
createIcon
