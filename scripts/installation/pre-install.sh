#!/bin/bash
sudo true

# RUN THIS SCRIPT ON X11 NOT WAYLAND!!

SCRIPT_PATH=$(dirname "$0")
cd "$SCRIPT_PATH"

function install_config_files {
    cp .bashrc ~/.bashrc
    sudo cp 'dnf.conf' '/etc/dnf/dnf.conf'
}

function add_rpm {
    # Add RPM Fusion
    sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
}

function update {
    # Update everything.
    sudo dnf update --refresh -y
    sudo dnf distro-sync --refresh -y
    sudo dnf remove firefox -y
    sudo dnf autoremove -y

}

function add_flatpak {
    # Add flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &&
    sudo dnf groupupdate core -y
}

install_config_files
add_rpm
update
add_flatpak
