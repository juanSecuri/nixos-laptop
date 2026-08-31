{ pkgs, ... }:
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 1;
      };

      background = [
        {
          path = "~/Pictures/wallpaper.jpg";
          blur_size = 8;
          blur_passes = 2;
          brightness = 0.5;
        }
      ];

      input-field = {
        size = "300, 50";
        outline_thickness = 2;
        outer_color = "rgba(cba6f7ee)";
        inner_color = "rgba(30, 30, 46, 0.8)";
        font_color = "rgba(cdd6f4ff)";
        placeholder_text = "Contraseña...";
        check_color = "rgba(a6e3a1ff)";
        fail_color = "rgba(f38ba8ff)";
        fade_on_empty = false;
        rounding = 10;
        position = "0, -20";
        halign = "center";
        valign = "center";
      };

      label = [
        {
          text = "cmd[update] echo $(date +'%A %d %B  %H:%M')";
          color = "rgba(cba6f7ff)";
          font_size = 28;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
        {
          text = "lenovo-v14";
          color = "rgba(a6adc8ff)";
          font_size = 14;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 120";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
