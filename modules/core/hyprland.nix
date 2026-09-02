{ ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    XCURSOR_THEME = "Nordic-cursors";
    XCURSOR_SIZE = "24";
    HYPRCURSOR_THEME = "Nordic-cursors";
    HYPRCURSOR_SIZE = "24";
  };
}
