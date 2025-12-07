{ config, pkgs, lib, ... }:

{
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        #################################
        # 1. Brightness dimming
        #################################

        # On battery (1 min → dim)
        {
          timeout = 60;
          on-timeout = ''systemd-ac-power && echo "AC—skip dim" || brightnessctl -s set 10'';
          on-resume = "brightnessctl -r";
        }

        # On AC (5 min → dim)
        {
          timeout = 300;
          on-timeout = ''systemd-ac-power && brightnessctl -s set 10 || echo "Battery—skip dim"'';
          on-resume = "brightnessctl -r";
        }

        #################################
        # 2. Keyboard backlight
        #################################

        # On battery (1 min → off)
        {
          timeout = 60;
          on-timeout = ''systemd-ac-power && echo "AC—skip kbd off" || asusctl --kbd-bright off'';
          on-resume = "asusctl -p";
        }

        # On AC (5 min → off)
        {
          timeout = 300;
          on-timeout = ''systemd-ac-power && asusctl --kbd-bright low || echo "Battery—skip kbd off"'';
          on-resume = "asusctl -p";
        }

        #################################
        # 3. Lock screen
        #################################

        # On battery (2 min → lock)
        {
          timeout = 120;
          on-timeout = ''systemd-ac-power && echo "AC—skip lock" || hyprlock'';
        }

        # On AC (2 min → lock)
        {
          timeout = 120;
          on-timeout = ''systemd-ac-power && hyprlock || echo "Battery—skip lock"'';
        }

        #################################
        # 4. DPMS off (screen off) + reset night-light
        #################################

        # On battery (5 min → off)
        {
          timeout = 300;
          on-timeout = ''systemd-ac-power && echo "AC—skip dpms off" || hyprctl dispatch dpms off'';
          on-resume = "hyprctl dispatch dpms on && brightnessctl -r && hyprsunset -t 4000";
        }

        # On AC (10 min → off)
        {
          timeout = 600;
          on-timeout = ''systemd-ac-power && hyprctl dispatch dpms off || echo "Battery—skip dpms off"'';
          on-resume = "hyprctl dispatch dpms on && brightnessctl -r && hyprsunset -t 4000";
        }

        #################################
        # 5. Suspend
        #################################

        # On battery (20 min → suspend)
        {
          timeout = 1200;
          on-timeout = ''systemd-ac-power && echo "AC—skip suspend" || systemctl suspend'';
        }

        # On AC (60 min → suspend)
        {
          timeout = 3600;
          on-timeout = ''systemd-ac-power && systemctl suspend || echo "Battery—skip suspend"'';
        }
      ];
    };
  };
}
