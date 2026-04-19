{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Unix tools
    ripgrep
    fd
    sd
    tree
    gnumake
    just
    eza
    dust
    procs
    httpie

    # Nix dev
    cachix
    nil
    nh
    nix-info
    nixpkgs-fmt

    # Dev
    tmate
    bun
    (python3.withPackages (python-pkgs: [ python-pkgs.numpy ]))
    ffmpeg
    bitwarden-cli
    tokei
    hyperfine
    opencode
    rtk
    
    vips
    libheif
    uv

    less

    # Nix tooling
    nix-output-monitor
    nix-tree

    # GUI apps (prefer nix over brew where possible)
    logseq
    audacity
    vscode

    # macOS-specific
    alt-tab-macos
    notion-app
    thunderbird-latest
  ];

  programs = {
    bat.enable = true;
    fzf.enable = true;
    jq.enable = true;
    btop.enable = true;

    eza = {
      enable = true;
      icons = "auto";
      git = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

  };
}
