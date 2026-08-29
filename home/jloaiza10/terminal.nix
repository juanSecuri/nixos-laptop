{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    theme = "Catppuccin-Mocha";
    shellIntegration.enabled = "no-cursor";
    settings = {
      background_opacity = "0.92";
      confirm_os_window_close = 0;
      scrollback_lines = 10000;
      window_padding_width = 8;
      enable_audio_bell = false;
    };
  };

  home.packages = with pkgs; [
    kitty-themes
  ];
}
