{
  config,
  pkgs,
  ...
}:
{
  programs.waybar = {
    enable = true;
    # Only systemd — exec-once in hyprland caused duplicate bars
    systemd.enable = true;

    settings = [
      {
        layer = "top";
        position = "top";
        height = 36;
        spacing = 8;
        modules-left = [
          "custom/launcher"
          "hyprland/workspaces"
        ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "custom/faith"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "battery"
          "tray"
          "custom/power"
        ];

        "custom/launcher" = {
          format = "󰣇";
          tooltip = "Apps (Super+R)";
          on-click = "rofi -show drun -show-icons";
        };

        "custom/faith" = {
          format = "󰖨";
          tooltip = "La Palabra del Señor";
          on-click = "la-palabra-del-senor";
        };

        "custom/power" = {
          format = "󰐥";
          tooltip = "Power (Super+Shift+E)";
          on-click = "wlogout";
        };

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
          format-names = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "6" = "六";
            "7" = "七";
            "8" = "八";
            "9" = "九";
            "10" = "十";
          };
        };

        "hyprland/window" = {
          max-length = 56;
          format = "{title}";
          separate-outputs = true;
        };

        cpu = {
          format = "󰻠 {usage}%";
          interval = 5;
        };

        memory = {
          format = "󰍛 {percentage}%";
          interval = 5;
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };

        network = {
          format-wifi = "󰤨 {signalStrength}%";
          format-ethernet = "󰈀 Eth";
          format-disconnected = "󰤭 Off";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          format-icons = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };

        tray = {
          spacing = 10;
          icon-size = 16;
        };
      }
    ];

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", sans-serif;
        font-size: 12px;
        min-height: 0;
      }

      window#waybar {
        background-color: #181825;
        color: #cdd6f4;
        border-bottom: 2px solid #313244;
      }

      #custom-launcher,
      #custom-faith,
      #custom-power,
      #cpu,
      #memory,
      #battery,
      #network,
      #pulseaudio,
      #tray {
        background-color: #1e1e2e;
        color: #cdd6f4;
        border-radius: 12px;
        padding: 2px 12px;
        margin: 6px 4px;
        border: 1px solid #313244;
      }

      #workspaces button {
        background-color: transparent;
        color: #a6adc8;
        border-radius: 10px;
        padding: 2px 10px;
        margin: 6px 2px;
        font-size: 14px;
        border: 1px solid transparent;
      }

      #workspaces button.active {
        background-color: #cba6f7;
        color: #11111b;
        border-color: #b4befe;
      }

      #workspaces button.urgent {
        background-color: #f38ba8;
        color: #11111b;
      }

      #window {
        color: #b4befe;
        font-weight: 500;
        padding: 0 8px;
      }

      #custom-launcher {
        color: #cba6f7;
        font-size: 15px;
      }

      #custom-faith {
        color: #f9e2af;
      }

      #custom-power {
        color: #f38ba8;
      }

      #battery.warning {
        color: #f9e2af;
      }

      #battery.critical {
        color: #f38ba8;
      }

      tooltip {
        background-color: #1e1e2e;
        border: 1px solid #cba6f7;
        border-radius: 10px;
        color: #cdd6f4;
      }
    '';
  };
}
