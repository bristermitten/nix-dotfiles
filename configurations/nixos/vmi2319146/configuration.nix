{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix


  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.substituters = ["https://cache.garnix.io"  "https://cache.nixos.org/" "https://nix-community.cachix.org" ];
  nix.settings.trusted-public-keys = ["cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "vmi2319146";
  networking.domain = "contaboserver.net";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [ ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPNPRzSLlLpDQwA9QpurZnREyON6z9wHiNJ9tZexFmgh alex@Alexs-MacBook-Pro.local'' ];
  users.users.alex.openssh.authorizedKeys.keys = [ ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPNPRzSLlLpDQwA9QpurZnREyON6z9wHiNJ9tZexFmgh alex@Alexs-MacBook-Pro.local'' ];
  system.stateVersion = "23.11";

  nixpkgs.hostPlatform = "x86_64-linux";


  users.users."alex" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  security.sudo.wheelNeedsPassword = false;
}
