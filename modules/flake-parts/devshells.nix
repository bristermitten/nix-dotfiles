# Per-language toolchains + LSPs, available on demand via `use flake ~/nix-dotfiles#<lang>`
# (see modules/home/devshells.nix). Nothing here is installed globally.
_:
{
  perSystem = { pkgs, ... }: {
    devShells = {
      haskell = pkgs.mkShell {
        packages = with pkgs.haskellPackages; [
          ghc
          cabal-install
          haskell-language-server # built against the same ghc above
        ];
      };

      lean = pkgs.mkShell {
        # Scratch files. Projects pinning a lean-toolchain should use elan (global).
        packages = [ pkgs.lean4 ];
      };

      rust = pkgs.mkShell {
        packages = with pkgs; [ cargo rustc clippy rustfmt rust-analyzer ];
      };

      python = pkgs.mkShell {
        packages = with pkgs; [ python3 uv ruff pyright ];
      };
    };
  };
}
