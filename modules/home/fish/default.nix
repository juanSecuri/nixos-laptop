{ pkgs, ... }:
let
  configFish = builtins.readFile ./config.fish;
in
{
  programs.fish = {
    enable = true;
    interactiveShellInit = configFish;
  };
}
