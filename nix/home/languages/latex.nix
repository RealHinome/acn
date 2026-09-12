{pkgs, ...}: {
  home.packages = with pkgs; [
    tectonic
    texlab
    biber
  ];
}
