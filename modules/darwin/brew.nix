{ ... }: {
  # Dev/utility casks shared across all machines.
  # Machine-specific extras (e.g. personal gaming/media apps) live in the
  # relevant configurations/darwin/<host>.nix instead of here.
  homebrew = {
    enable = true;
    global.autoUpdate = true;
    taps = [
      "tw93/tap"
    ];

    brews = [
      "tw93/tap/mole"
    ];

    casks = [
      "activitywatch"
      "arc"
      "audacity"
      "bitwarden"
      "claude"
      "discord"
      "ghostty"
      "google-chrome"
      "ishare"
      "jordanbaird-ice"
      "lens"
      "nextcloud"
      "obs"
      "orbstack"
      "raycast"
      "tailscale-app"
      "the-unarchiver"
      "vlc"
      "zotero"
    ];
  };

}
