{ ... }:
{
  programs = {
    # on macOS, you probably don't need this
    bash = {
      enable = false;
      initExtra = ''
        # Custom bash profile goes here
      '';
    };

    # For macOS's default shell.
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      envExtra = ''
        # Custom zshrc goes here
      '';
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" ];
      };

    };


    # Better shell prmot!
    starship = {
      enable = true;
      settings = {
        username = {
          style_user = "blue bold";
          style_root = "red bold";
          format = "[$user]($style) ";
          disabled = false;
          show_always = true;
        };
        hostname = {
          ssh_only = true;
          ssh_symbol = "🌐 ";
          format = "on [$hostname](bold red) ";
          trim_at = ".local";
          disabled = false;
        };
      };
    };
  nushell = {
    enable = false; # TODO fix eventually
    
    # Temporary workaround for configuration sourcing.
    configFile.source = ./shell.nu;
  };
  };
}
