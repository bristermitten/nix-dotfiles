# This is your nix-darwin configuration.
# For home configuration, see /modules/home/*
{ flake, pkgs, lib, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports =
    with builtins;
    map
      (fn: ./${fn})
      (filter (fn: fn != "default.nix") (attrNames (readDir ./.)));
# ...

  nixpkgs.overlays = [
    (final: prev: {
      direnv = prev.direnv.overrideAttrs (old: {
        env = (old.env or { }) // {
          CGO_ENABLED = "1";
        };
      });
    })

    (self: super: {
      discord = super.discord.overrideAttrs (old: rec {
        version = "0.0.394";
        src = super.fetchurl {
          url = "https://stable.dl2.discordapp.net/distro/app/stable/osx/universal/${version}/full.distro";
          hash = "sha256-X2Iy2Y3344tryx1sdv0diij1GQFPS0iU8Z5vne5IICA=";
        };
      });
    })
  ];

  security.pam.services.sudo_local.touchIdAuth = true;

  determinateNix.customSettings = {
    trusted-users = [ "root" "alex" "@wheel" ];
    lazy-trees = true;
    sandbox = false;
  };



  nix.enable = false;
  # Configure macOS system
  # More Alexs-MacBook-Pro-3s => https://github.com/ryan4yin/nix-darwin-kickstarter/blob/main/rich-demo/modules/system.nix
  system = {
    defaults = {

      finder = {
        _FXShowPosixPathInTitle = true; # show full path in finder title
        AppleShowAllExtensions = true; # show all file extensions
        FXEnableExtensionChangeWarning = false; # disable warning when changing file extension
        QuitMenuItem = true; # enable quit menu item
        ShowPathbar = true; # show path bar
        ShowStatusBar = true; # show status bar
      };
    };

    keyboard = { };
  };

}
