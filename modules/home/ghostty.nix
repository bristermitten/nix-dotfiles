{ ... }: {
  # Ghostty itself is installed via the Homebrew cask (modules/darwin/brew.nix);
  # this just manages ~/.config/ghostty/config.
  programs.ghostty = {
    enable = true;
    package = null;

    settings = {
      # Fullscreen resizes in place instead of moving into a dedicated
      # macOS Space, so toggling it (cmd+enter) can never break a
      # Split View pairing or strand the window in the wrong Space.
      macos-non-native-fullscreen = true;
    };
  };
}
