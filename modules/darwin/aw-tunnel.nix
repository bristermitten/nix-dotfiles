# WireGuard tunnel to the homelab (via the VPS hub) so the laptops can reach the
# central ActivityWatch server at 10.0.1.2:5600. nix-darwin has no
# networking.wireguard, so this is a launchd daemon around wg-quick.
#
# The private key is generated on the laptop at first start and never leaves it;
# print the public key with `sudo wg pubkey < /var/lib/wireguard/aw.key` and add
# it as a peer in nixos-stuff's vps-proxy/proxy-logic.nix.
{ config, lib, pkgs, ... }:
let
  cfg = config.services.awTunnel;
  iface = "awtunnel";
  path = lib.makeBinPath (with pkgs; [ wireguard-tools wireguard-go bash coreutils gnugrep ]);

  up = pkgs.writeShellScript "aw-tunnel-up" ''
    set -eu
    export PATH="${path}:/usr/sbin:/sbin:/usr/bin:/bin"

    # Re-run every StartInterval seconds; no-op while the tunnel is healthy.
    # (macOS names the device utunN, so `wg show ${iface}` can't be used.)
    wg show interfaces 2>/dev/null | grep -q . && exit 0

    umask 077
    mkdir -p /var/lib/wireguard /etc/wireguard
    key=/var/lib/wireguard/aw.key
    [ -s "$key" ] || wg genkey > "$key"

    cat > /etc/wireguard/${iface}.conf <<EOF
    [Interface]
    PrivateKey = $(cat "$key")
    Address = ${cfg.address}/32

    [Peer]
    # VPS (hub) - same key as the homelab's wg-proxy peer
    PublicKey = ${cfg.vpsPublicKey}
    Endpoint = ${cfg.endpoint}
    # Only the homelab: this tunnel carries no other traffic.
    AllowedIPs = ${cfg.homelabAddress}/32
    PersistentKeepalive = 25
    EOF

    exec wg-quick up ${iface}
  '';
in
{
  options.services.awTunnel = {
    enable = lib.mkEnableOption "WireGuard tunnel to the homelab ActivityWatch server";
    address = lib.mkOption {
      type = lib.types.str;
      example = "10.0.1.3";
      description = "This laptop's tunnel IP; must match its peer entry on the VPS.";
    };
    homelabAddress = lib.mkOption { type = lib.types.str; default = "10.0.1.2"; };
    endpoint = lib.mkOption { type = lib.types.str; default = "217.174.245.147:51820"; };
    vpsPublicKey = lib.mkOption {
      type = lib.types.str;
      default = "JblBsKEdr0KVHt83FfpfRui2g1+DTaaWdoVhs4khnR8=";
    };
  };

  config = lib.mkIf cfg.enable {
    launchd.daemons.aw-tunnel.serviceConfig = {
      ProgramArguments = [ "${up}" ];
      RunAtLoad = true;
      StartInterval = 60;
      StandardOutPath = "/var/log/aw-tunnel.log";
      StandardErrorPath = "/var/log/aw-tunnel.log";
    };
  };
}
