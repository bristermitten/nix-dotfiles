# Language toolchains on demand, never on the global PATH.
#
# - ~/scratch/<lang>/ has an .envrc that loads the matching devShell from this
#   flake (see modules/flake-parts/devshells.nix), so scratch files get a
#   compiler + LSP with no per-project flake. nix-direnv caches it, so it's
#   instant after the first load and stays in the store.
# - `lsp-nix` is the editor-side fallback for files outside any project.
{ config, lib, pkgs, ... }:
let
  flakeDir = "${config.home.homeDirectory}/nix-dotfiles";
  languages = [ "haskell" "lean" "rust" "python" ];

  # lsp-nix <shell> <cmd> [args...]: run cmd if already on PATH (project devShell
  # via direnv), otherwise run it inside this flake's <shell> devShell.
  lspNix = pkgs.writeShellScriptBin "lsp-nix" ''
    export PATH="/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH"
    shell="$1"; shift
    if command -v "$1" >/dev/null 2>&1; then exec "$@"; fi
    exec nix develop "${flakeDir}#$shell" --command "$@"
  '';
in
{
  home.packages = [ lspNix ];

  # The Emacs daemon (launchd) has a bare PATH
  programs.doom-emacs.extraBinPackages = [ lspNix ];

  # Real files (not store symlinks) so `direnv allow` sticks.
  home.activation.scratchEnvrc = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for lang in ${lib.concatStringsSep " " languages}; do
      dir="$HOME/scratch/$lang"
      mkdir -p "$dir"
      echo "use flake ${flakeDir}#$lang" > "$dir/.envrc"
      ${pkgs.direnv}/bin/direnv allow "$dir" 2>/dev/null || true
    done
  '';
}
