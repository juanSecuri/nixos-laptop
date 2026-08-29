{ config, lib, pkgs, ... }:
let
  accent = "#cba6f7";
  mocha = {
    base = "#1e1e2e";
    mantle = "#181825";
    crust = "#11111b";
    surface0 = "#313244";
    surface1 = "#45475a";
    text = "#cdd6f4";
    subtext = "#a6adc8";
    lavender = "#b4befe";
    mauve = "#cba6f7";
    blue = "#89b4fa";
    green = "#a6e3a1";
    red = "#f38ba8";
    yellow = "#f9e2af";
  };
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    systemd.enable = true;

    settings = {
      monitor = ",preferred,auto,1";

      exec-once = [
        "waybar"
        "mako"
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
      ];

      general = {
        gaps_in = 6;
        gaps_out = 12;
        border_size = 2;
        "col.active_border" = "rgba(cba6f7ee) rgba(89b4faee) 45deg";
        "col.inactive_border" = "rgba(313244aa)";
        layout = "dwindle";
        resize_on_border = true;
      };

      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 0.92;
        blur = {
          enabled = true;
          size = 6;
          passes = 2;
          new_optimizations = true;
        };
        shadow = {
          enabled = true;
          range = 18;
          render_power = 3;
          color = "rgba(1a1a2eee)";
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
        kb_layout = "us";
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

      master = {
        new_status = "master";
      };

      gestures = {
        workspace_swipe = true;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      # Catppuccin Mocha base until you set a wallpaper in ~/Pictures/wallpaper.jpg
      # exec-once = hyprpaper can be added after placing a wallpaper

      "$mod" = "SUPER";

      bind = [
        "$mod, RETURN, exec, kitty"
        "$mod, Q, killactive,"
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

      windowrulev2 = [
        "float, class:^(pavucontrol)$"
        "float, class:^(blueman-manager)$"
        "float, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"
      ];
    };

    extraConfig = ''
      # Cursor IDE — tile by default
      windowrulev2 = float, class:^(cursor)$
      windowrulev2 = size 85% 85%, class:^(cursor)$
      windowrulev2 = center, class:^(cursor)$
    '';
  };

  home.file.".config/rofi/config.rasi".text = ''
    configuration {
      modi: "drun,run,window";
      show-icons: true;
      icon-theme: "Papirus-Dark";
      font: "JetBrainsMono Nerd Font 11";
      display-drun: "Apps";
      drun-display-format: "{name}";
      location: 0;
      yoffset: 15;
      xoffset: 0;
      fixed-num-lines: false;
      lines: 8;
      columns: 1;
      width: 36;
      terminal: kitty;
    }

    * {
      background-color: transparent;
      text-color: ${mocha.text};
      border: 0;
    }

    window {
      background-color: ${mocha.base};
      border: 2px;
      border-color: ${mocha.mauve};
      border-radius: 16px;
      padding: 16px;
    }

    inputbar {
      background-color: ${mocha.mantle};
      border-radius: 12px;
      padding: 12px 16px;
      margin-bottom: 12px;
      children: [prompt, entry];
    }

    prompt {
      text-color: ${mocha.mauve};
      margin-right: 8px;
    }

    entry {
      text-color: ${mocha.text};
    }

    element {
      padding: 10px 14px;
      border-radius: 10px;
    }

    element selected {
      background-color: ${mocha.surface0};
      text-color: ${mocha.lavender};
    }

    element-text {
      background-color: transparent;
    }

    element-icon {
      size: 24px;
    }
  '';

  home.packages = with pkgs; [
    hyprlock
    hypridle
  ];
}
