{ pkgs, home, environment, ... }:
{


  home.packages = [
    (pkgs.discord.override {
      withOpenASAR = true;
      # withVencord = true; # can do this here too
    })
  ];
}
