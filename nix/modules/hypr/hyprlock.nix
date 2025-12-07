{ config, pkgs, lib, ... }:

{
  programs.hyprlock = {
    enable = true;

    settings = {
      # BACKGROUND
      background = [{
        monitor = "";
        path = "~/Pictures/Wallpapers/wallpaper.jpg";
        blur_passes = 2;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      }];

      # GENERAL
      general = {
        grace = 0;
      };

      # INPUT FIELD
      input-field = [{
        monitor = "";
        size = "250, 60";
        outline_thickness = 2;
        dots_size = 0.2;
        dots_spacing = 0.2;
        dots_center = true;
        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = "rgba(100, 114, 125, 0.4)";
        font_color = "rgb(200, 200, 200)";
        fade_on_empty = false;
        font_family = "SF Pro Display Bold";
        placeholder_text = ''<i><span foreground="##ffffff99">Enter Pass</span></i>'';
        hide_input = false;
        position = "0, -225";
        halign = "center";
        valign = "center";
      }];

      # Labels
      label = [
        # Time
        {
          monitor = "";
          text = ''cmd[update:1000] echo "<span>$(date +"%H:%M")</span>"'';
          color = "rgba(216, 222, 233, 0.70)";
          font_size = 130;
          font_family = "SF Pro Display Bold";
          position = "0, 240";
          halign = "center";
          valign = "center";
        }
        # Day-Month-Date
        {
          monitor = "";
          text = ''cmd[update:1000] echo -e "$(date +"%A, %d %B")"'';
          color = "rgba(216, 222, 233, 0.70)";
          font_size = 30;
          font_family = "SF Pro Display Bold";
          position = "0, 105";
          halign = "center";
          valign = "center";
        }
        # USER
        {
          monitor = "";
          text = "Hi, $USER";
          color = "rgba(216, 222, 233, 0.70)";
          font_size = 25;
          font_family = "SF Pro Display Bold";
          position = "0, -130";
          halign = "center";
          valign = "center";
        }
      ];

      # Profile Photo
      image = [{
        monitor = "";
        path = "/home/$USER/.config/hypr/memoji-615.png";
        border_color = "0xffdddddd";
        border_size = 0;
        size = 120;
        rounding = -1;
        rotate = 0;
        reload_time = -1;
        reload_cmd = "";
        position = "0, -20";
        halign = "center";
        valign = "center";
      }];
    };
  };
}
