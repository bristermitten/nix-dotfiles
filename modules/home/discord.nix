{ pkgs, ... }:
{


  home.packages = [
    (pkgs.discord.override {
      withOpenASAR = false;
      withVencord = false; # can do this here too
    })
  ];
}
