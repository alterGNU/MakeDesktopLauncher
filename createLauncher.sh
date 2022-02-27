#!/bin/bash
 
# ==================================================================================================
# CREATELAUNCHER.SH
# ==================================================================================================

# =[ ERRORS ]=======================================================================================
# ERROR12 => checkPackage: invalid number of arguments
# ERROR13 => createFolder: invalid number of arguments
# ERROR14 => createFolder: folder to be created already exists

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
 
# =[ CREATE FOLDER ]================================================================================
function createFolder(){
    [[ $# -ne 1 ]] && { echo -e "ERROR13: createFolder() call failed, take only 1 argument, the folder's name." ; exit 13 ; }
    absolutePath="${folderPath}${1}/"
    if [ -d ${absolutePath} ];then
        echo "Error14: a folder with the same name already exists"
        exit 14
    else
        mkdir -p ${absolutePath} -v
    fi
}

# -[ ASK USER FOLDER'S NAME ]-----------------------------------------------------------------------
function askName(){
    name=$(zenity --entry --title="Creating the launcher" --text="Enter the name of the application")
    compliantName=$(echo "${name//[!a-zA-Z0-9]/}")
    echo ${compliantName}
}

# -[ SELECT ICONE ]---------------------------------------------------------------------------------
function selectImage(){
    imagePath=$(zenity --file-selection --title="Selectionner l'icône de l'application" --filename=/home/)
    echo ${imagePath}
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
createFolder ${folderName}
# ask for a path to an image that can be used as an icon until it is
while ! identify ${imagePath} &> /dev/null || [ "${imagePath}" == "" ] ;do imagePath=$(selectImage);done
