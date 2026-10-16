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
      vscode = prev.vscode.overrideAttrs (oldAttrs: {
        postPatch = builtins.replaceStrings
          [ "Contents/Resources/app/node_modules/@vscode/ripgrep-universal" ]
          [ "Contents/Resources/app/node_modules.asar.unpacked/@vscode/ripgrep-universal" ]
          (oldAttrs.postPatch or "");
      });
    })
  ];

  security.pam.services.sudo_local.touchIdAuth = true;

  determinateNix.customSettings = {
    trusted-users = [ "root" "alex" "fi22264" "@wheel" ];
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

      CustomUserPreferences."com.apple.symbolichotkeys".AppleSymbolicHotKeys = {
        # "Switch to Desktop N" (default combo is ctrl+N), off by default in System Settings
        "118" = { enabled = true; }; # Desktop 1
        "119" = { enabled = true; }; # Desktop 2
        "120" = { enabled = true; }; # Desktop 3
        "121" = { enabled = true; }; # Desktop 4
      };
    };

    keyboard = { };
  };

}
