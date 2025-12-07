# Directory Overview

This directory contains the personal dotfiles for a NixOS system. The configuration is managed using Nix Flakes and is organized into modules and hosts. The primary host is `strixy`, which is a highly customized NixOS installation running the Hyprland window manager.

## Key Files

*   `nix/hosts/strixy/configuration.nix`: The main entry point for the `strixy` host's system configuration. It imports other modules and defines the overall system state, including hardware, services, and packages.
*   `nix/hosts/strixy/home.nix`: Configures the user-specific environment for the `parker` user using `home-manager`. This includes shell settings, application configurations, and user-level services.
*   `nix/modules/hypr/hyprland.nix`: Configures the Hyprland window manager, including keybindings, window rules, and visual settings.
*   `flake.nix`: The Nix Flake entry point, which defines the inputs (like `nixpkgs`) and outputs (the NixOS configurations) for the project.

## Usage

This repository is used to declaratively manage a NixOS system. To apply the configuration to a new machine, you would typically install NixOS and then use the `nixos-rebuild` command with the flake in this repository.

**Building and Running:**

To build and switch to the configuration for the `strixy` host, you would run the following command from the root of this repository:

```bash
nixos-rebuild switch --flake .#strixy
```

**Development Conventions:**

*   The configuration is structured to separate system-level concerns (`configuration.nix`) from user-level concerns (`home.nix`).
*   Reusable configuration snippets are abstracted into modules under the `nix/modules/` directory.
*   Host-specific configurations are located in the `nix/hosts/` directory.
