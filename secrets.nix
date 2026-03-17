let
  alex = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPNPRzSLlLpDQwA9QpurZnREyON6z9wHiNJ9tZexFmgh";
in
{
  "secrets/lastfm-config.yaml.age".publicKeys = [ alex ];
}
