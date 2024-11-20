{ ... }:
{
  home.shellAliases = {
    g = "git";
    lg = "lazygit";
  };

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
      extraConfig = {
        # pull.rebase = "false";
      };
    };
    lazygit.enable = true;
  };

}
