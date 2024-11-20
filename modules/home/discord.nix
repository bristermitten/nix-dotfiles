{ pkgs, home, environment, ... }:
{
 environment.systemPackages = with pkgs; [
    (discord.override {
      withOpenASAR = true;
      # withVencord = true; # can do this here too
    })
  ]; 

  home.packages = [
    pkgs.discord
    ];
}
