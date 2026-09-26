# Doom Emacs via https://github.com/marienz/nix-doom-emacs-unstraightened
# Declarative: no `doom sync`; edit ./doom/*.el and rebuild instead.
{ flake, pkgs, ... }:
{
  imports = [
    flake.inputs.nix-doom-emacs-unstraightened.homeModule
  ];

  programs.doom-emacs = {
    enable = true;
    doomDir = ./doom;

    # Native macOS (Cocoa) build. Swap for pkgs.emacs-macport for smoother scrolling.
    emacs = pkgs.emacs;

    # On PATH inside Emacs (also for the launchd daemon, which has a bare PATH)
    extraBinPackages = with pkgs; [
      git
      ripgrep
      fd
      direnv
      nil
      nixpkgs-fmt
      shellcheck
    ];

    # Tree-sitter grammars for the +tree-sitter modules
    extraPackages = epkgs: [ epkgs.treesit-grammars.with-all-grammars ];
  };

  # Background daemon (launchd agent). Attach with `emacsclient -c -n`.
  services.emacs.enable = true;

  home.packages = [
    pkgs.elan # Lean toolchain manager; run `elan default stable` once
    pkgs.nerd-fonts.symbols-only # icons for doom-modeline / nerd-icons
  ];
}
