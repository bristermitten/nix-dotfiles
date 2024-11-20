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
      userEmail = "johndoe@Alexs-MacBook-Pro-3.com";
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
