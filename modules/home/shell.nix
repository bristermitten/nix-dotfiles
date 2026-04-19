{ ... }:
{
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c";
  };

  programs = {
    bash.enable = false;

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      envExtra = ''
        export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
      '';
      initContent = ''
        # Wrap nix so build/develop/shell use nom for prettier output
        nix() {
          case "$1" in
            build|develop|shell) nom "$@" ;;
            *) command nix "$@" ;;
          esac
        }
      '';
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "docker"
          "kubectl"
        ];
      };
      shellAliases = {
        # Better tool replacements
        cat = "bat";
        grep = "rg";
        find = "fd";
        du = "dust";
        ps = "procs";
        ls = "eza";
        ll = "eza -l";
        la = "eza -la";
        lt = "eza --tree";

        # Git shortcuts
        gs = "git status";
        gd = "git diff";
        gl = "git log --oneline";

        # Nix
        nrs = "nix run";
        nfu = "nix flake update";
      };
    };

    atuin = {
      enable = true;
      enableZshIntegration = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        auto_sync = false;
        update_check = false;
        style = "compact";
        inline_height = 20;
        show_preview = true;
        filter_mode_shell_up_key_binding = "session";
      };
    };

    carapace = {
      enable = true;
      enableZshIntegration = true;
    };

    starship = {
      enable = true;
      settings = {
        format = "$username$hostname$directory$git_branch$git_status$nix_shell$python$rust$nodejs$cmd_duration$line_break$character";
        add_newline = false;

        username = {
          style_user = "blue bold";
          style_root = "red bold";
          format = "[$user]($style) ";
          disabled = false;
          show_always = true;
        };

        hostname = {
          ssh_only = true;
          ssh_symbol = "@ ";
          format = "on [$hostname](bold red) ";
          trim_at = ".local";
          disabled = false;
        };

        directory = {
          truncation_length = 3;
          truncation_symbol = ".../";
          style = "cyan bold";
        };

        git_branch = {
          symbol = " ";
          format = "on [$symbol$branch(:$remote_branch)]($style) ";
          style = "purple";
        };

        git_status = {
          style = "red";
        };

        nix_shell = {
          format = "via [$symbol$state( \\($name\\))]($style) ";
          symbol = "❄️  ";
          style = "blue";
        };

        cmd_duration = {
          min_time = 2000;
          format = "took [$duration]($style) ";
          style = "yellow";
        };

        character = {
          success_symbol = "[>](green)";
          error_symbol = "[>](red)";
        };
      };
    };
  };
}
