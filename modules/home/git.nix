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

      ignores = [ "*~" "*.swp" ];


      signing = {
        key = "~/.ssh/id_ed25519";
        signByDefault = true;
      };

      settings = {
        user.name = "Alexander Wood";
        user.email = "alexljwood24@hotmail.co.uk";
        pull.rebase = true;

        credential.helper =
          if pkgs.stdenvNoCC.isDarwin
          then "osxkeychain"
          else "cache --timeout=1000000000";

        commit.gpgsign = true;
        gpg.format = "ssh";

        init.defaultBranch = "main";
      };
    };
    lazygit.enable = true;
  };
  programs.difftastic.enable = true;
  programs.difftastic.git.enable = true;

}
