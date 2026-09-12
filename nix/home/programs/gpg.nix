{pkgs, ...}: {
  programs.gpg = {
    enable = true;
    settings = {
      keyid-format = "long";
      with-fingerprint = true;
      require-cross-certification = true;
      no-symkey-cache = true;
    };
  };

  home.packages = [pkgs.pinentry_mac];

  home.file.".gnupg/gpg-agent.conf" = {
    text = ''
      pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
      default-cache-ttl 900
      max-cache-ttl 7200
    '';
  };
}
