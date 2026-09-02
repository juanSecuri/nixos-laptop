{ pkgs, ... }:
{
  home.sessionVariables = {
    EDITOR = "cursor";
    VISUAL = "cursor";
    TERMINAL = "alacritty";
    BROWSER = "librewolf";
    XDG_CURRENT_DESKTOP = "Hyprland";
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
