{ config, lib, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    settings = {
      monitor = ",preferred,auto,1";

      exec-once = [
        "hyprpaper -c ${config.home.homeDirectory}/.config/hypr/hyprpaper.conf"
        "mako"
        "hypridle"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "QT_QPA_PLATFORM,wayland"
        "QT_QPA_PLATFORMTHEME,qt6ct"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "GTK_THEME,Catppuccin-Mocha-Standard-Mauve-Dark"
        "XCURSOR_THEME,Bibata-Modern-Classic"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 16;
        border_size = 3;
        "col.active_border" =
          lib.mkDefault "rgba(f38ba8ee) rgba(cba6f7ee) rgba(89b4faee) rgba(94e2d5ee) 45deg";
        "col.inactive_border" = lib.mkDefault "rgba(313244aa)";
        layout = "dwindle";
        resize_on_border = true;
      };

      decoration = {
        rounding = 14;
        active_opacity = 1.0;
        inactive_opacity = 0.94;
        blur = {
          enabled = true;
          size = 8;
          passes = 3;
          new_optimizations = true;
        };
        shadow = {
          enabled = true;
          range = 22;
          render_power = 3;
          color = "rgba(1a1a2ecc)";
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "smooth, 0.22, 1, 0.36, 1"
          "overshot, 0.34, 1.56, 0.64, 1"
        ];
        animation = [
          "windows, 1, 5, smooth, slide"
          "windowsOut, 1, 4, smooth, slide"
          "border, 1, 8, default"
          "fade, 1, 6, smooth"
          "workspaces, 1, 5, overshot, slide"
        ];
      };

      input = {
        kb_layout = "latam";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
          disable_while_typing = true;
        };
        sensitivity = 0;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master.new_status = "master";
      gestures.workspace_swipe = true;

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      "$mod" = "SUPER";

      bind = [
        "$mod, RETURN, exec, kitty"
        "$mod, Q, killactive,"
        "$mod, W, killactive,"
        "$mod SHIFT, Q, killactive,"
        "$mod, DELETE, killactive,"
        "$mod, M, exit,"
        "$mod, E, exec, thunar"
        "$mod, V, togglefloating,"
        "$mod, R, exec, rofi -show drun -show-icons"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, semicolon, movefocus, d"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod, F, fullscreen, 0"
        "$mod SHIFT, F, fullscreen, 1"
        "$mod, SPACE, exec, rofi -show drun -show-icons"
        "$mod SHIFT, B, exec, la-palabra-del-senor"
        "$mod SHIFT, E, exec, wlogout"
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "$mod, Print, exec, grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      layerrule = [
        "blur, rofi"
        "ignorezero, rofi"
        "blur, wlogout"
        "ignorezero, wlogout"
      ];

      windowrulev2 = [
        "float, class:^(pavucontrol)$"
        "float, class:^(blueman-manager)$"
        "float, class:^(file_progress)$"
        "float, class:^(confirm)$"
        "float, class:^(dialog)$"
        "float, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"
        "center, class:^(pavucontrol)$"
        "size 50% 60%, class:^(pavucontrol)$"
      ];
    };

    extraConfig = ''
      windowrulev2 = float, class:^(cursor)$
      windowrulev2 = size 85% 85%, class:^(cursor)$
      windowrulev2 = center, class:^(cursor)$
    '';
  };

  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ${config.home.homeDirectory}/Pictures/wallpaper.jpg
    wallpaper = ,${config.home.homeDirectory}/Pictures/wallpaper.jpg
  '';

  home.file."Pictures/wallpaper.jpg".source = ../../assets/wallpapers/wallpaper.jpg;
}
