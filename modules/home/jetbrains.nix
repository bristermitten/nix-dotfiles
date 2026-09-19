{ pkgs, ... }: {
  home.packages = with pkgs; [
    jetbrains.idea
    jetbrains.webstorm
    jetbrains.clion
    jetbrains-mono
    # jetbrains.rider
    jetbrains.rust-rover
    # jetbrains.pycharm-professional
  ];
}
