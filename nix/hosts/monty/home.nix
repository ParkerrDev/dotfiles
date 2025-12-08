{ config, pkgs,  ... }:

{
  home.username = "parker";
  home.homeDirectory = "/Users/parker";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;


  programs.atuin = {
  enable = true;
  enableBashIntegration = true;

  settings = {
    sync_address = "http://atuin.parkerhunt.me";  # Replace with jarvis's actual IP

    auto_sync = true;
    sync_frequency = "1m";
    search_mode = "fuzzy";
    style = "compact";
    show_preview = true;
    filter_mode_shell_up_key_binding = "global";
    sync_on_cd = true;       # Sync when changing directories
    update_on_sync = true;   # Update local db immediately on sync
    filter_mode = "global";
  };
};

}
