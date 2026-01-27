{ pkgs, ... }: {
  home.packages = with pkgs; [
    jetbrains-toolbox
    jetbrains.idea
    jetbrains.webstorm
    # jetbrains.clion
    # jetbrains.rider
    # jetbrains.rust-rover
    # jetbrains.pycharm-professional
  ];
}
