let
  alex = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPNPRzSLlLpDQwA9QpurZnREyON6z9wHiNJ9tZexFmgh";
  fi22264 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKwuud+4Cwa4hLVsI8MZWSMEj/d9JRo1qBwBubjeJWPi";
in
{
  "secrets/lastfm-config.yaml.age".publicKeys = [ alex fi22264 ];
}
