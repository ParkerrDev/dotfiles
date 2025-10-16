{ config, pkgs, ... }: {
  # Enable waybar
  programs.waybar = {
    enable = true;
    style = builtins.readFile ./waybar.css;
    settings = {
      mainBar = {
        margin = "8px 10px -2px 10px";
        layer = "top";

        modules-left = [ "custom/wmname" "clock" "hyprland/window" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "custom/ddcutil" "backlight" "pulseaudio" "network" "tray" "battery" "custom/powermenu" ];

        "hyprland/window" = {
          format = "{title}";
          max-length = 10;
          separate-outputs = false;
        };

        /* Modules configuration */
        "hyprland/workspaces" = {
          active-only = "false";
          # on-scroll-up = "hyprctl dispatch workspace e+1";
          # on-scroll-down = "hyprctl dispatch workspace e-1";
          # disable-scroll = "false";
          all-outputs = "true";
          format = "{icon}";
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = " ";
            deactivated = " ";
          };
        };

        "tray" = {
          spacing = 8;
          layer = "overlay";
        };

        "clock" = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = " {:%H:%M}"; #format = " {:%I:%M}"; <-- 12 hour format
          format-alt = " {:%A, %B %d, %Y}";
        };

        "cpu" = {
          format = " {usage}%";
          tooltip = "false";
        };

        "memory" = {
          format = " {}%";
        };

        "backlight" = {
          format = "{icon}{percent}%";
          format-icons = [ "󰃞 " "󰃟 " "󰃠 " ];
          on-scroll-up = "brightnessctl set 1%+";
          on-scroll-down = "brightnessctl set 1%-";
        };

        "battery" = {
          states = {
            warning = "30";
            critical = "15";
          };
          format = "{icon}{capacity}%";
          tooltip-format = "{timeTo} {capacity}%";
          format-charging = "󱐋{capacity}%";
          format-plugged = "";
          format-alt = "{time} {icon}";
          format-icons = [ "  " "  " "  " "  " "  " ];
        };

        "network" = {
          format-wifi = " {essid} {signalStrength}%";
          format-ethernet = "{ifname}: {ipaddr}/{cidr}  ";
          format-linked = "{ifname} (No IP)  ";
          format-disconnected = "󰤮 Disconnected";
          on-click = "wifi-menu";
          on-click-release = "sleep 0";
          tooltip-format = "{essid} {signalStrength}%";
        };

        "pulseaudio" = {
          format = "{icon}{volume}% {format_source}";
          format-bluetooth = "{icon} {volume}%";
          format-bluetooth-muted = "   {volume}%";
          format-source = "";
          format-source-muted = " ";
          format-muted = "  {format_source}";
          format-icons = {
            headphone = " ";
            hands-free = " ";
            headset = " ";
            phone = " ";
            portable = " ";
            car = " ";
            default = [ " " " " "  " ];
          };
          tooltip-format = "{desc} {volume}%";
          on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          on-click-right = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          on-click-middle = "pavucontrol";
          on-click-release = "sleep 0";
          on-click-middle-release = "sleep 0";
        };

        "custom/wmname" = {
          format = " ";
          on-click = "wofi -p 'Search Apps' --show drun --width 500 --height 400 -I --matching multi-contains --insensitive";
          on-click-release = "sleep 0";
        };

        "custom/powermenu" = {
          format = " ";
          on-click = "wlogout -s";
        };

        "custom/ddcutil" = {
          type = "custom";
          exec = "ddcutil -b 13 getvcp 10 -t | perl -nE 'if (/ C (\\d+) /) { say $1; }'";
          exec-if = "command -v ddcutil";
          format = "{icon} {}%";
          format-icons = [ "" ];
          interval = 5;
          on-scroll-up = "ddcutil -b 13 setvcp 10 + 1";
          on-scroll-down = "ddcutil -b 13 setvcp 10 - 1";
        };
      };
    };
  };
}
