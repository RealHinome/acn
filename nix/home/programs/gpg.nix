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

  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    defaultCacheTtl = 900;
    maxCacheTtl = 7200;
    pinentry.package = pkgs.pinentry_mac;
  };
}
