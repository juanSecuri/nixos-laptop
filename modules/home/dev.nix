{ pkgs, lib, ... }:
{
  home.sessionVariables = {
    EDITOR = lib.mkForce "cursor";
    VISUAL = lib.mkForce "cursor";
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

  # Remove leftover configs from the old Waybar/Rofi/SDDM stack
  home.activation.removeStaleDesktopConfigs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    rm -rf "$HOME/.config/rofi" "$HOME/.config/waybar" "$HOME/.config/wlogout" 2>/dev/null || true
  '';
}
