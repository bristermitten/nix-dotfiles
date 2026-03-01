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
      "audacity"
      "bitwarden"
      "brightintosh"
      "claude"
      "ghostty"
      "google-chrome"
      "ishare"
      "jordanbaird-ice"
      "lens"
      "logseq"
      "nextcloud"
      "obs"
      "orbstack"
      "plex"
      "prismlauncher"
      "raycast"
      "shadow"
      "steam"
      "tailscale"
      "the-unarchiver"
      "vlc"
      "whatsapp"
      "wireguard-tools"
      "zotero"
    ];
  };

}
