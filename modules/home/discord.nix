{ pkgs, ... }:
{


  home.packages = [
    (pkgs.discord.override {
      withOpenASAR = false;
      withVencord = false;
    })

    pkgs.discord-canary
  ];
}
