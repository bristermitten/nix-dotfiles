{ pkgs, ... }:
{
  home.shellAliases = {
    g = "git";
    lg = "lazygit";
  };

  home.packages = [
    pkgs.gh
  ];

  # https://nixos.asia/en/git
  programs = {
    git = {
      enable = true;
      userName = "Alexander Wood";
      userEmail = "alexljwood24@hotmail.co.uk";
      ignores = [ "*~" "*.swp" ];
      aliases = {
        ci = "commit";
      };

      signing = {
        key = "~/.ssh/id_ed25519";
        signByDefault = true;
      };

      extraConfig = {
        # pull.rebase = "false";
        credential.helper =
          if pkgs.stdenvNoCC.isDarwin
          then "osxkeychain"
          else "cache --timeout=1000000000";

        commit.gpgsign = true;
        gpg.format = "ssh";

        init.defaultBranch = "main";
        pull.rebase = true;
      };



      difftastic.enable = true;
    };
    lazygit.enable = true;
  };

}
