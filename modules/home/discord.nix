{ pkgs, ... }:
{


  home.packages = [
    (pkgs.discord.override {
      withOpenASAR = true;
      withVencord = false;
    })

    pkgs.discord-canary
  ];
}
