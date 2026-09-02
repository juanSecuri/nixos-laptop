{ pkgs, lib, ... }:
let
  cava-dynamic = pkgs.writeShellScriptBin "cava" ''
    mkdir -p ~/.config/cava
    cat ~/.config/cava/config_base ~/.config/cava/colors > ~/.config/cava/config 2>/dev/null
    exec ${pkgs.cava}/bin/cava "$@"
  '';
in
{
  home.packages = [ (lib.hiPrio cava-dynamic) ];
  xdg.configFile."cava".source = ./.;
}
