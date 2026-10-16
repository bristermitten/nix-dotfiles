{ pkgs, ... }: {
  home.packages = [ pkgs.mosh ];

  programs.ssh = {
    enable = true;
    includes = [ "config.d/*" ];
    enableDefaultConfig = false;

<<<<<<< HEAD
    # default config options for all hosts
    settings."*" = {
      ForwardAgent = false;
      IdentityAgent = "~/.bitwarden-ssh-agent.sock";
      Compression = false;
      # Detect a dead connection instead of hanging silently — matters most
      # for the homelab remote builder, which can sit mid-build for a long
      # time over the VPS jump-host fallback.
      ServerAliveInterval = 30;
      ServerAliveCountMax = 3;
      HashKnownHosts = false;
      UserKnownHostsFile = "~/.ssh/known_hosts";
      # Multiplex repeat connections to the same host onto one already-
      # authenticated TCP connection instead of renegotiating every time.
      ControlMaster = "auto";
      ControlPath = "~/.ssh/master-%r@%n:%p";
      ControlPersist = "10m";
    };

    settings."github-uni" = {
      HostName = "github.com";
      User = "git";
      IdentityFile = "~/.ssh/id_ed25519_uni";
      IdentitiesOnly = true;
    };

    settings."lab" = {
      HostName = "rd-mvb-linuxlab.bristol.ac.uk";
      ProxyJump = "seis";
      User = "fi22264";
    };

    settings."seis" = {
      HostName = "seis.bris.ac.uk";
      User = "fi22264";
      ForwardAgent = true;
    };

    # Interactive access to the homelab/VPS, for alex directly (separate
    # from the root-only ssh_config.d entries in
    # modules/darwin/remote-builder.nix that the nix-daemon uses for
    # remote builds). Reuses alex's regular key, which is already
    # authorised on both. mosh works well here since neither hop needs
    # its own UDP passthrough — the VPS is directly reachable, and the
    # homelab is reached over the WireGuard address via that VPS jump.
    settings."vps" = {
      HostName = "217.174.245.147";
      User = "root";
      IdentityFile = "~/.ssh/id_ed25519";
      IdentitiesOnly = true;
    };

    settings."homelab" = {
      HostName = "10.0.1.2";
      ProxyJump = "vps";
      User = "alex";
      IdentityFile = "~/.ssh/id_ed25519";
      IdentitiesOnly = true;
=======
    settings = {
      "*" = {
        ForwardAgent = false;
        IdentityAgent = "~/.bitwarden-ssh-agent.sock";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };

      "github-uni" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519_uni";
        IdentitiesOnly = true;
      };

      "lab" = {
        HostName = "rd-mvb-linuxlab.bristol.ac.uk";
        ProxyJump = "seis";
        User = "fi22264";
      };

      "seis" = {
        HostName = "seis.bris.ac.uk";
        User = "fi22264";
        ForwardAgent = true;
      };
>>>>>>> b856c7b (update uni laptop config: ghostty, ssh settings, brew, flake.lock)
    };
  };
}
