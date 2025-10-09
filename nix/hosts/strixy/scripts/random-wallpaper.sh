#!/usr/bin/env bash

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
# Path for the symlink to the current wallpaper
CURRENT_WALLPAPER_SYMLINK="$HOME/.config/hypr/current_wallpaper.jpg"
# Path for hyprlock compatibility
HYPRLOCK_WALLPAPER_SYMLINK="$WALLPAPER_DIR/wallpaper.jpg"

# Make sure wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    mkdir -p "$WALLPAPER_DIR"
    echo "Created wallpaper directory at $WALLPAPER_DIR"
    echo "Please add some wallpapers to this directory"
    exit 1
fi

# Make sure the directory for the symlink exists
if [ ! -d "$(dirname "$CURRENT_WALLPAPER_SYMLINK")" ]; then
    mkdir -p "$(dirname "$CURRENT_WALLPAPER_SYMLINK")"
    echo "Created directory for wallpaper symlink at $(dirname "$CURRENT_WALLPAPER_SYMLINK")"
fi

# Get a random wallpaper, excluding the symlinks themselves
WALLPAPER=$(find "$WALLPAPER_DIR" -type f -not -path "$(readlink -f "$CURRENT_WALLPAPER_SYMLINK" 2>/dev/null || echo "nonexistent-path")" -not -path "$HYPRLOCK_WALLPAPER_SYMLINK" | shuf -n 1)

if [ -z "$WALLPAPER" ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Remove any existing symlinks
if [ -e "$CURRENT_WALLPAPER_SYMLINK" ]; then
    rm "$CURRENT_WALLPAPER_SYMLINK"
fi

if [ -e "$HYPRLOCK_WALLPAPER_SYMLINK" ]; then
    rm "$HYPRLOCK_WALLPAPER_SYMLINK"
fi

# Create symlinks to the selected wallpaper
ln -s "$WALLPAPER" "$CURRENT_WALLPAPER_SYMLINK"
ln -s "$WALLPAPER" "$HYPRLOCK_WALLPAPER_SYMLINK"

# Set the wallpaper with hyprpaper
hyprctl hyprpaper reload ,"$WALLPAPER"

echo "Set wallpaper to: $WALLPAPER"
