#!/bin/bash
sudo true

function install_blesh {
	git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
	make -C ble.sh install PREFIX=~/.local
	echo 'source ~/.local/share/blesh/ble.sh' >> ~/.bashrc
}

function install_fzf {
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install

}

function fix_bluetooth {
    # Fix bluetooth wih airpods
    sudo sed -i 's/#ControllerMode = dual/ControllerMode = bredr/g' /etc/bluetooth/main.conf
    sudo systemctl restart bluetooth.service
}

function set_gnome_settings {
    # Gnome Settings
    gsettings set org.gnome.desktop.interface clock-format '12h' # Set clock format to 12 hour
    gsettings set org.gnome.desktop.interface clock-show-seconds true # Show seconds
    gsettings set org.gnome.desktop.interface clock-show-weekday true # Show Weekday
    gsettings set org.gnome.desktop.interface clock-show-date true # Show date
    gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true # Set tap-to-click
    gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true # Turn Night Light on
    gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic false # Make Night light always on
    gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close' # Show Minimize and Maximize buttons
}

function install_dnf_packages {
    # Install everything dnf

    sudo dnf group install "Development Tools" -y

    # Virtualization
    sudo dnf group install --with-optional virtualization -y
    sudo systemctl enable --now libvirtd
    sudo dnf install virt-manager -y
    
    # Hardware Acceleration
    sudo dnf install libva-utils
    sudo dnf install intel-media-driver
    
    # Remove GNOME-Classic as it is not necessary.
    #sudo dnf remove gnome-classic-session

    # System
    sudo dnf install tlp -y
    sudo dnf install git -y
    sudo dnf install python3-pip -y
    sudo dnf install libappindicator-gtk3 -y 
    #sudo dnf install gnome-tweaks -y
    #sudo dnf install gnome-extensions-app -y
    #sudo dnf install gnome-shell-extension-appindicator -y

    # Tomb Dependancies
    sudo dnf install zsh -y
    sudo dnf install file -y
    sudo dnf install gnupg -y
    sudo dnf install cryptsetup -y
    
    # Applications
    sudo dnf install tilix -y
    #sudo dnf install gimp -y
    sudo dnf install rpi-imager -y
    #sudo dnf install bleachbit -y
    sudo dnf install vlc -y
    sudo dnf install calibre -y

    # Hacking Tools
    sudo dnf install nmap -y
    sudo dnf install wireshark -y
    sudo dnf install ettercap -y
    sudo dnf install bettercap -y
    sudo dnf install netcat -y

    # install tomb
    # install vscode
    # install steam
    # install motrix
    # install widnscribe
    # install solanum
}

function install_protonvpn {
    #Install latest release of ProtonVPN for Fedora 36+
    url="https://repo.protonvpn.com/fedora-36-stable/release-packages/"
    html=$(curl -s "$url")
    rpm_package=$(echo "$html" | grep -o 'protonvpn-.*\.rpm' | tail -1 | sed 's/">.*//')
    curl -o "$rpm_package" "$url/$rpm_package"
    sudo dnf install "$rpm_package"
    sudo dnf install protonvpn -y
    pip3 install --user 'dnspython>=1.16.0'
}

function install_brave_browser {
    #Install Brave Browser
    sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/ -y &&
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc &&
    sudo dnf install brave-browser -y
}

function install_balena_etcher {
    # Install Balena Etcher
    curl -L https://api.github.com/repos/balena-io/etcher/releases -o etcher.json
    URL=$(grep -o "https://github.com/balena-io/etcher/releases/download/.*\.rpm" etcher.json | head -1)
    curl -L $URL -o etcher.rpm
    sudo dnf install etcher.rpm -y
    rm etcher.json etcher.rpm
}

function install_flatpaks {
    #flatpak install flathub org.gtk.Gtk3theme.adw-gtk3-dark -y
    flatpak install flathub io.github.shiftey.Desktop -y
    #flatpak install flathub com.slack.Slack -y
    flatpak install flathub com.notesnook.Notesnook -y
    #flatpak install flathub com.google.AndroidStudio -y
    flatpak install flathub org.qbittorrent.qBittorrent -y
    flatpak install flathub com.discordapp.Discord -y
}

function clean {
    # Remove anything unecessary.
    sudo dnf autoremove -y
    sudo dnf clean packages -y
    sudo dnf clean dbcache -y
    sudo dnf clean all
}

#fix_bluetooth
#install_theme
#set_gnome_settings
install_dnf_packages
#install_protonvpn
install_brave_browser
#install_balena_etcher
install_flatpaks

