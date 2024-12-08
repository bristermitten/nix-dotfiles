{ pkgs, ... }:
{


  home.packages =
    if pkgs.stdenv.isDarwin then [
      pkgs.vscode
    ] else [ ];
}
