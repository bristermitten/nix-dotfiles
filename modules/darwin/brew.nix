{ ... }: {
  homebrew = {
    enable = true;

    taps = [
      "tw93/tap"
    ];

    brews = [
      "tw93/tap/mole"
    ];

    casks = [
      "activitywatch"
      "arc"
      "bitwarden"
      "brightintosh"
      "claude"
      "ghostty"
      "google-chrome"
      "ishare"
      "jordanbaird-ice"
      "lens"
      "nextcloud"
      "music-presence"
      "obs"
      "orbstack"
      "plex"
      "prismlauncher"
      "raycast"
      "shadow"
      "steam"
      "tailscale-app"
      "the-unarchiver"
      "vlc"
      "whatsapp"
      "zotero"
    ];
  };

}
