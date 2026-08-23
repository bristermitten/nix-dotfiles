{ ... }:
{
  # Use the homelab (x86_64-linux, 4 cores / 15GB) as a remote builder.
  # This Mac is aarch64-darwin and can't build Linux closures natively, so
  # anything targeting x86_64-linux gets offloaded there instead of failing
  # or needing emulation.
  #
  # Note `nix.enable = false` in ./default.nix: Determinate Nix owns
  # /etc/nix, so nix-darwin's `nix.buildMachines` option is a no-op here and
  # would silently do nothing. Builders have to go through
  # determinateNix.customSettings, which lands in /etc/nix/nix.custom.conf.
  determinateNix.customSettings = {
    builders = "ssh-ng://nixremote@homelab-builder x86_64-linux /Users/alex/.ssh/nixremote_ed25519 4 1 kvm,benchmark,big-parallel";

    # Have the builder fetch dependencies from cache.nixos.org itself rather
    # than this Mac downloading them and re-uploading over SSH. Without
    # this, a large closure means shipping every dependency over the wire
    # twice.
    builders-use-substitutes = true;
  };

  # The Nix daemon runs as root, so it never reads alex's home-manager SSH
  # config — this alias has to be system-wide to be visible to it.
  #
  # Location-aware: if homelab's SSH port answers on the LAN we go direct
  # (fast, closures can be GB-sized); otherwise we fall back to the VPS
  # jump host over WireGuard. Match blocks come first because ssh_config
  # takes the *first* value obtained for each keyword.
  #
  # The jump hop reuses alex's existing key (already authorised for VPS
  # root, and passphrase-less so the daemon can use it non-interactively).
  # The build hop uses the dedicated nixremote key, which is authorised
  # only for the build account on homelab.
  environment.etc."ssh/ssh_config.d/100-nix-remote-builder.conf".text = ''
    Match host homelab-builder exec "/usr/bin/nc -z -w1 192.168.1.100 22 >/dev/null 2>&1"
      HostName 192.168.1.100

    Match host homelab-builder
      HostName 10.0.1.2
      ProxyJump nix-builder-jump

    Host homelab-builder
      User nixremote
      IdentityFile /Users/alex/.ssh/nixremote_ed25519
      IdentitiesOnly yes
      StrictHostKeyChecking accept-new
      UserKnownHostsFile /var/root/.ssh/known_hosts

    Host nix-builder-jump
      HostName 217.174.245.147
      User root
      IdentityFile /Users/alex/.ssh/id_ed25519
      IdentitiesOnly yes
      StrictHostKeyChecking accept-new
      UserKnownHostsFile /var/root/.ssh/known_hosts
  '';
}
