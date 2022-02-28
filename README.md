# MakeDesktopLauncher

This BashScript allows you to create a custom launcher for any app or command you want to launch graphically using the
app menu or favorites bar.

## TODO
### V1
- [ ] Multiples choices (tag, categories)
- [ ] Tests 
- [ ] Fix:logout needed
- [ ] Fix:sometimes no iconFullName add to the desktop file
- [ ] Example : inception + tuto + gif
- [ ] Example : chrome profile + tuto + gif
### V2
- [ ] Make an Icone theme
- [ ] Use XDG Directory structure and algo.

## About the script
In its first version, this script will not use the following notions:
- XDG Base Directory
- Icon Theme

Instead, it'll create one folder per launcher in the directory $HOME/.local/share/applicacions/.

Each of these folders created by this script will contain:
- An image converted to the format to use as an icon
- A .desktop file to launch the application
- (If necessary)the executable to launch the application

## Installation
Clone the repo
```bash
git clone https://github.com/alterGNU/MakeDesktopLauncher.git
```

## Requirements:
_I'm using ubuntu 20.04.4 LTS with GNOME_
### Image
Before running this script, you must already have an image that you want to turn into an icon of your program.
- This image's size must be at least 512x512
- This image's extension must be one off these extension: .png, .wpm or svg
### Packages (commands)
- zenity (for `zenity` command)
- imagemagick (for `identify` and `convert` commands)

## Usage
- step 1: get the executable or command you want to run
- step 2: get the image you want to turn into an icon
- step 3: execute createLauncher.sh and then follow his instructions...:)
```bash
cd MakeDesktopLauncher.git && ./createLauncher.sh
```

## Useful Commands
- `convert -list Format` -> list of supported Format

# Sources
## Bash-Scripting
- [Advanced bash-scripting guide by@mandelCooper](https://tldp.org/LDP/abs/html/abs-guide.html)
- [Advanced bash-scripting guide:CH24.Functions](https://tldp.org/LDP/abs/html/complexfunct.html)
- [Pb:path with space doesn't work](https://stackoverflow.com/questions/589149/bash-script-to-cd-to-directory-with-spaces-in-pathname)

## Desktop Extension Format
### Specifications:
- [specifications.freedesktop.org: Desktop Entry Specification](https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html)
- [specifications.freedesktop.org: XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
- [specifications.freedesktop.org: Icon Theme Specification](https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html)
### Forums and Tutorials
- [LinuxConfig.org:How to create custom desktop files for launchers on linux](https://linuxconfig.org/how-to-create-custom-desktop-files-for-launchers-on-linux)
- [askubuntu.com:How to change launcher icon](https://askubuntu.com/questions/190170/how-to-change-launcher-icon)
- [askubuntu.com: Icons put in /usr/local/share/icons/hicolor/...](https://askubuntu.com/questions/1291597/icons-put-in-usr-local-share-icons-hicolor-apps)

## Image manipulation
### man pages
- [die.net : imagemagick(1)](https://linux.die.net/man/1/imagemagick)
- [die.net : convert(1)](https://linux.die.net/man/1/convert)
- [legacy.imagemagick.org : identify format attribute](https://legacy.imagemagick.org/script/escape.php)
### Forums and Tutorials
- [HowToGeek: How to Quicly Resize, Convert & Modify Images from the linux Terminal](https://www.howtogeek.com/109369/how-to-quickly-resize-convert-modify-images-from-the-linux-terminal/)

## GUI Dialog Boxes
- [die.net:dialog man page](https://linux.die.net/man/1/dialog)
### GNOME:zenity GTK+ 
- [die.net:zenity](https://linux.die.net/man/1/zenity)
- [wikiUbuntu-fr:zenity](https://doc.ubuntu-fr.org/zenity)
### KDE:Kdialog
- [develop.kde.org:Shell scripting with KDE Dialogs](https://develop.kde.org/deploy/kdialog/)
