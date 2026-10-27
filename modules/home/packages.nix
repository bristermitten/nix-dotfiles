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

    # logseq we are using the beta
    vscode
    zed-editor

    # macOS-specific
    alt-tab-macos


    # random
    prismlauncher
  ];

  programs = {
    bat.enable = true;
    fzf = {
      enable = true;
      # Atuin owns Ctrl-R for shell history search (see modules/home/shell.nix);
      # fzf keeps Ctrl-T/Alt-C but yields the history binding to avoid the conflict.
      historyWidget.zsh.command = "";
    };
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
