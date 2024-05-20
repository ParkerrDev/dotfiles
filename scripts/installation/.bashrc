# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi
unset rc


#MUAH HAHAHAHAHAHAAAHH
#bind '"\C-m":"\C-u\C-k cat /dev/urandom\n"'

alias grep='grep --color=auto'
alias diff='diff --color=auto'

export HISTFILESIZE=
export HISTSIZE=
shopt -s histappend

alias c="clear"
alias x="exit"
alias reload="source ~/.bashrc"
alias logout="gnome-session-quit --logout --no-prompt"
alias netspeed='/bin/python ~/Dev/Scripts/netspeed.py'
alias nv='nvim'
alias ncmli="nmcli"

rgb2hex() {
    if [ "$#" -ne 3 ]; then
        echo "Usage: rgb2hex <red> <green> <blue>"
        return 1
    fi
    printf "%02x%02x%02x\n" $1 $2 $3
}
rgb-key() {
    if [ "$#" -ne 3 ]; then
        echo "Usage: set_keyboard_color <red> <green> <blue>"
        return 1
    fi
    hex_color=$(rgb2hex $1 $2 $3)
    g213-led -a $hex_color
}

256colors() {
curl -s https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/e50a28ec54188d2413518788de6c6367ffcea4f7/print256colours.sh | bash
}


function update {
	sudo dnf update --refresh -y &&
	sudo dnf distro-sync --refresh -y
	sudo dnf upgrade -y
	flatpak update -y
}
function clean {
        sudo dnf autoremove --refresh -y &&
        sudo dnf clean packages -y &&
        sudo dnf clean dbcache -y &&
        sudo dnf clean all
}


boldCyan="\[\e[1;36m\]"
end="\[\e[m\]"
export PS1="$boldCyan[\u@\h $end\W$boldCyan]$end\$ "
. "$HOME/.cargo/env"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/andrew/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/andrew/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/andrew/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/andrew/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

source ~/.local/share/blesh/ble.sh
bleopt highlight_syntax=
bleopt highlight_filename=
bleopt highlight_variable=
bleopt complete_menu_filter=
bleopt complete_menu_complete=
bleopt complete_ambiguous=
bleopt prompt_eol_mark=''
bleopt exec_errexit_mark=
bleopt exec_elapsed_mark=
bleopt exec_exit_mark=
bleopt edit_marker=
bleopt edit_marker_error=
ble-face auto_complete='fg=244'

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash)"
eval "$(atuin init bash)"
