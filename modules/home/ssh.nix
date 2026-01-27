{ ... }: {
  programs.ssh = {
    enable = true;
    includes = [ "config.d/*" ];
    enableDefaultConfig = false;

    # default config options for all hosts
    matchBlocks."*" = {
      forwardAgent = false;
      identityAgent = "~/.bitwarden-ssh-agent.sock";
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };

    matchBlocks."github-uni" = {
      hostname = "github.com";
      user = "git";
      identityFile = "~/.ssh/id_ed25519_uni";
      identitiesOnly = true;
    };

    matchBlocks."lab" = {
      hostname = "rd-mvb-linuxlab.bristol.ac.uk";
      proxyJump = "seis";
      user = "fi22264";
    };

    matchBlocks."seis" = {
      hostname = "seis.bris.ac.uk";
      user = "fi22264";
      forwardAgent = true;
    };
  };
}
