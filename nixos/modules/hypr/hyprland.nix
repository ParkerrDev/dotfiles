{ config, pkgs, lib, inputs, ... }:

{
  options = {
    hyprlandLayout = lib.mkOption {
      default = "master";
      description = ''
        hyprland window layout
       '';
    };
  };

  config = { 
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;

      settings = {
        # Monitor configuration
        monitor = [
          "eDP-2,highres,0x0,auto"
          "eDP-1,highres,0x0,auto"
          # ",highres,auto,auto"
        ];

        # Xwayland
        xwayland.force_zero_scaling = true;

        # Environment variables
        env = [
          "BROWSER, brave-browser"
          "EDITOR, code"
          "TERM, kitty"
          "XDG_CURRENT_DESKTOP, Hyprland"
          "XDG_SESSION_DESKTOP, Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "ELECTRON_OZONE_PLATFORM_HINT,auto"
          "LIBVA_DRIVER_NAME,nvidia"
          "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          "NVD_BACKEND,direct"
          "GDK_DPI_SCALE,1"
          "GDK_SCALE,1"
          "XCURSOR_SIZE,24"
          # "QT_AUTO_SCREEN_SCALE_FACTOR,\"1.50\""
          # "QT_QPA_PLATFORM,\"wayland;xcb\""
          # "QT_WAYLAND_DISABLE_WINDOWDECORATION,\"1\""
          # "QT_QPA_PLATFORMTHEME,\"gtk4\""
        ];

        # Autostart
        exec-once = [
          "hyprpaper"
          "hyprsunset -t 4000"
          "waybar"
          "nm-applet --indicator"
          "blueman-applet"
          "systemctl --user start hyprpolkitagent"
          "udiskie"
          "ydotoold"
          "bash ~/Desktop/dotfiles/scripts/random-wallpaper.sh"
          "swayidle -w timeout 300 '$lock' timeout 300 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep '$lock'"
          "hypridle"
          "ollama serve"
        ];

        # Layer rules
        layerrule = [
          "blur,waybar"
          "ignorealpha 0, waybar"
          "blur,wofi"
          "ignorealpha 0, wofi"
          "blur, ags"
          "ignorealpha 0, ags"
          "blur, logout_dialog"
          "ignorealpha 0, logout_dialog"
        ];

        # Variables
        "$terminal" = "kitty";
        "$fileManager" = "nautilus";
        "$menu" = "pgrep -x .wofi-wrapped >/dev/null 2>&1 || wofi -p \"Search Apps\" --show drun --width 500 --height 400 -I --matching multi-contains --insensitive";
        "$mainMod" = "SUPER";
        "$lock" = "hyprlock";

        # Input
        input = {
          kb_layout = "us";
          follow_mouse = 0;
          touchpad = {
            natural_scroll = false;
          };
          sensitivity = 0.25;
        };

        # General
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 0;
          layout = config.hyprlandLayout;
          allow_tearing = false;
        };

        # Decoration
        decoration = {
          rounding = 15;
          blur = {
            enabled = true;
            size = 4;
            passes = 3;
          };
        };

        # Animations
        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        # Dwindle
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        # Gestures
        gestures = {
          workspace_swipe = true;
          workspace_swipe_fingers = 3;
        };

        # Misc
        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
        };

        # Keybinds
        bind = [
          "CTRL+ALT,T, exec, $terminal"
          "$mainMod, W, killactive,"
          "$mainMod, END, exit,"
          "$mainMod, F, exec, $fileManager"
          "$mainMod, A, togglefloating,"
          "$mainMod, TAB, exec, $menu"
          "$mainMod, U, pseudo,"
          "$mainMod, S, togglesplit,"
          "$mainMod, R, exec, hyprctl reload && pkill waybar && waybar &"
          "$mainMod, P, pin"
          ",F11, fullscreen"
          "$mainMod, G, togglegroup"
          "$mainMod, C, changegroupactive, f"
          "$mainMod+SHIFT, C, changegroupactive, b"
          "$mainMod, E, exec, ~/Desktop/wofi-emoji/wofi-emoji --matching multi-contains --insensitive"
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
          "$mainMod SHIFT, left, movewindow, l"
          "$mainMod SHIFT, right, movewindow, r"
          "$mainMod SHIFT, up, movewindow, u"
          "$mainMod SHIFT, down, movewindow, d"
          "$mainMod SHIFT, TAB, workspace, e+1"
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"
          "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
          "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
          "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
          "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
          "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
          "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
          "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
          "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
          "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
          "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
          "$mainMod, M, togglespecialworkspace, magic"
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
          "$mainMod, ESCAPE, exec, hyprshot -m region -o ~/Pictures/Screenshots;"
          "$mainMod+SHIFT, ESCAPE, exec, grim -g \"$(slurp)\" - | tesseract stdin stdout | wl-copy;"
          "$mainMod, L, exec, $lock"
          ",XF86AudioMute, exec, pamixer -t"
          ",XF86AudioPlay, exec, playerctl play-pause"
          ",XF86AudioNext, exec, playerctl next"
          ",XF86AudioPrev, exec, playerctl previous"
          ",XF86AudioStop, exec, playerctl stop"
        ];

        binde = [
          ", 135, exec, ydotool click 0xC0"
          "$mainMod+CTRL+ALT, up, exec, ydotool mousemove -w -x 0 -y 1"
          "$mainMod+CTRL+ALT, down, exec, ydotool mousemove -w -x 0 -y -1"
          ", 110, exec, ydotool mousemove -x -15 -y 0"
          "SHIFT, 110, exec, ydotool mousemove -x -80 -y 0"
          ", 115, exec, ydotool mousemove -x 15 -y 0"
          "SHIFT, 115, exec, ydotool mousemove -x 80 -y 0"
          ", 117, exec, ydotool mousemove -x 0 -y 15"
          "SHIFT, 117, exec, ydotool mousemove -x 0 -y 80"
          ", 112, exec, ydotool mousemove -x 0 -y -15"
          "SHIFT, 112, exec, ydotool mousemove -x 0 -y -80"
          ",XF86AudioRaiseVolume, exec, pamixer -i 1"
          ",XF86AudioLowerVolume, exec, pamixer -d 1"
          ",XF86MonBrightnessUp, exec, brightnessctl set +1%"
          ",XF86MonBrightnessDown, exec, brightnessctl set 1%-"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];
      };

      # Enable systemd integration to make sure environment variables are properly set
      systemd.variables = ["--all"];
    };
  };
}
