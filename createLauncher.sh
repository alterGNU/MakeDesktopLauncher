#!/bin/bash
 
# ==================================================================================================
# CREATELAUNCHER.SH
# ==================================================================================================

# =[ ERRORS ]=======================================================================================
# ERROR11 => cleanup             : something goes wrong and cleanup function was called
# ERROR12 => checkPackage        : invalid number of arguments
# ERROR13 => createIcon          : no icon converted in folder

# =[ VARIABLES ]====================================================================================
trap cleanup 1 2 3 6

folderPath="${HOME}/.local/share/applications/"
folderName=""
imagePath=""
iconFullName=""

# -[ CLEANUP ]--------------------------------------------------------------------------------------
function cleanup(){
    echo -e "\nSomething goes wrong!"
    if [ "${folderName}" != "" ];then
        echo -e "removing ${folderPath}${folderName} folder"
        rm -rf ${folderPath}${folderName}
    fi
    exit 11
}

# -[ CALL CLEANUP AND EXIT ]------------------------------------------------------------------------
function killIfLastCmdFailed(){ [[ ${?} -ne 0 ]] && kill -s SIGINT ${$} ; }

# -[ CHECK REQUIREMENT PACKAGES ]-------------------------------------------------------------------
function checkPackage(){
    [[ $# -lt 1 || $# -gt 2 ]] && { echo -e "ERROR12: checkPackage() call failed, take 1 or 2 arguments." ; exit 12 ; }
    cmd=$1
    [[ -z $2 ]] && package=$1 || package=$2
    if ! which $1 > /dev/null;then
        echo -e "Command ${cmd} not found!Do you want to install ${package} with apt cmd?(y/n) \n"
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
    killIfLastCmdFailed
    compliantName=$(echo "${name//[!a-zA-Z0-9]/}")
    echo ${compliantName}
}

# -[ SELECT IMAGE ]---------------------------------------------------------------------------------
function selectImage(){
    imagePath=$(zenity --file-selection --title="Selectionner l'icône de l'application" --filename=/home/)
    killIfLastCmdFailed
    echo ${imagePath/\ /\\\ }
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
    iconPath="${folderPath}${folderName}/"
    if [ ${long} -gt 512 ] && [ ${larg} -gt 512 ];then
        iconFormat=512x512
        iconName="${folderName}_512x512.png"
    elif [ ${long} -lt ${larg} ];then
        iconFormat=${long}x${long}
        iconName="${folderName}_${long}x${long}.png"
    else
        iconFormat=${larg}x${larg}
        iconName="${folderName}_${larg}x${larg}.png"
    fi
    iconFullName=${iconPath}${iconName}
    eval convert ${imagePath} -resize ${iconFormat}! ${iconFullName}
    eval chmod +x ${iconFullName}
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
[[ -f ${iconFullName} ]] && echo "convert: create an icon '${iconFullName}'" || { echo "ERROR13: No icon was created" ; exit 13 ; }

echo -e "\nCreate Desktop file:"
# Create file
file="${folderPath}${folderName}/${folderName}.desktop"
touch $file
echo "touch: create desktop file '${file}'"

# Add HEADER
echo "[Desktop Entry]" >> $file

# Ask to choose between Types
typeApp=$(zenity --list --title="Select the Type" --text "Select the Type" --radiolist --column "Pick" --column "Answer" TRUE "Application" FALSE "Link" FALSE "Directory")
killIfLastCmdFailed
echo "Type=${typeApp}" >> $file

# Add for the name
echo "Name=${folderName}" >> $file

# Ask for comment (OPT)
comment=$(zenity --entry --title="(OPTIONNAL):ADD some comment" --text="Tooltip for the entry, for example 'View sites on the Internet'.")
killIfLastCmdFailed
[[ ${comment} != "" ]] && echo "Comment=${comment}" >> $file

# Add icon
echo "Icon=${iconFullName}" >> $file

# Ask for exec:2 choices
appOrCmd=$(zenity --list --title="Programm or Command to execute\nTwo choices:" --column="0" "Browse folders for the executable" "Write the command line to run")
killIfLastCmdFailed
while [ "${execAppOrCmd}" == "" ];do [[ "${appOrCmd}" == "Browse folders for the executable" ]] && { execAppOrCmd=$(zenity --file-selection --title="Browse folders for the executable" --filename=${HOME}/) ; killIfLastCmdFailed ; } || { execAppOrCmd=$(zenity --entry --title="Write the command line to run" --text="Write the command line to run") ; killIfLastCmdFailed ; };done
echo "Exec=\"${execAppOrCmd//\"/\\\"}\"" >> $file

exit 0
