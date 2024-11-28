{ config, pkgs, ... }: {

  home.file.".config/wlogout/assets" = {
    source = ./assets; # Relative to this nix file
    recursive = true; # Required for directories
  };

  programs.wlogout = {
    enable = true;
    # You might need to adjust this path to where your assets actually are
    style =
      let
        assets = "${config.home.homeDirectory}/.config/wlogout/assets";
      in
      ''
        window {
          background-color: rgba(0, 0, 0, 0.5);
        }

        button {
          border-color: transparent;
          background-color: rgba(255, 255, 255, 0.25);
          background-size: cover;
          background-position: center;
          background-size: 150px;
          margin: 0.5px;
        }

        button:focus, button:active, button:hover {
          outline-style: none;
          background-color: rgba(255, 255, 255, 0.114);
        }

        #lock {
          border-radius: 20px 0px 0px 0px;
          background-image: url('${assets}/lock.svg');
        }

        #logout {
          border-radius: 0;
          background-image: url('${assets}/logout.svg');
        }

        #suspend {
          border-radius: 0px 20px 0px 0px;
          background-image: url('${assets}/suspend.svg');
        }

        #hibernate {
          border-radius: 0px 0px 0px 20px;
          background-image: url('${assets}/hibernate.svg');
        }

        #shutdown {
          border-radius: 0;
          background-image: url('${assets}/shutdown.svg');
        }

        #reboot {
          border-radius: 0px 0px 20px 0px;
          background-image: url('${assets}/reboot.svg');
        }
      '';
  };
}
