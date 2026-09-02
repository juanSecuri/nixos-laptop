{
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    python311Minimal
    python311Packages.pip
    python311Packages.virtualenv
    uv
    ruff
    mypy
    # OCR / document processing (contableIA, bookepping-cleanup-agent)
    tesseract
    poppler-utils
    qpdf
    imagemagick
    # The Profit Catalyst — Selenium / scraping (sistema-contable-dian-siigo)
    chromedriver
    geckodriver
    # Native libs for Python wheels (numpy, easyocr, etc.)
    zlib
    libffi
    openssl
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      fuse3
      icu
      nss
      openssl
      curl
      expat
    ];
  };
}
