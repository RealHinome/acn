{pkgs, ...}: let
  dnsMode = pkgs.writeShellApplication {
    name = "dns-mode";
    text = ''
      service="Wi-Fi"

      case "''${1:-status}" in
        cloudflare)
          /usr/bin/sudo /usr/sbin/networksetup -setdnsservers "$service" \
            1.1.1.1 1.0.0.1 \
            2606:4700:4700::1111 2606:4700:4700::1001
          ;;
        network)
          cat >&2 <<'WARNING'
      WARNING: this accepts DNS servers supplied by the current network.
      A hostile network can manipulate DNS answers. TLS still authenticates
      HTTPS endpoints, but DNS metadata and non-TLS traffic remain exposed.
      Use this only for networks or captive portals that require their DNS.
      WARNING

          if [[ "''${2:-}" != "--yes" ]]; then
            read -r -p "Temporarily accept network-provided DNS? [y/N] " answer
            [[ "$answer" == [yY] ]] || exit 1
          fi

          /usr/bin/sudo /usr/sbin/networksetup -setdnsservers "$service" empty
          ;;
        status)
          /usr/sbin/networksetup -getdnsservers "$service"
          ;;
        *)
          echo "usage: dns-mode {status|cloudflare|network [--yes]}" >&2
          exit 2
          ;;
      esac
    '';
  };
in {
  environment.systemPackages = [dnsMode];

  networking = {
    dns = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];

    knownNetworkServices = ["Wi-Fi"];

    applicationFirewall = {
      enable = true;
      blockAllIncoming = true;
      enableStealthMode = true;

      # Do not implicitly punch firewall holes merely because an app is signed.
      allowSigned = false;
      allowSignedApp = false;
    };
  };
}
