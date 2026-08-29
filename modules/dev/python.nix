{
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    python311
    python311Packages.pip
    python311Packages.virtualenv
    uv
    ruff
    mypy
    # OCR / document processing (contableIA, bookepping-cleanup-agent)
    tesseract
    tesseract5
    poppler_utils
    qpdf
    imagemagick
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
