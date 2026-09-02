{
  config,
  pkgs,
  ...
}:
let
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

  pill = ''
    background-color: ${mocha.surface0};
    color: ${mocha.text};
    border-radius: 14px;
    padding: 2px 12px;
    margin: 6px 3px;
    border: 1px solid ${mocha.surface1};
  '';
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        height = 38;
        spacing = 4;
        modules-left = [
          "custom/launcher"
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [ "clock" ];
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
          tooltip = "Apagar / cerrar sesión";
          on-click = "wlogout";
        };

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            active = "󰮯";
            default = "󰧨";
            urgent = "󰃺";
          };
        };

        "hyprland/window" = {
          max-length = 42;
          format = "󰈙 {title}";
          separate-outputs = true;
        };

        clock = {
          format = "󰥔  {:%a %d %b   %H:%M}";
          tooltip-format = "<big>{:%A %d %B %Y}</big>";
        };

        cpu = {
          format = "󰻠 {usage}%";
          tooltip = true;
        };

        memory = {
          format = "󰍛 {percentage}%";
          tooltip = true;
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
          format-ethernet = "󰈀 Conectado";
          format-disconnected = "󰤭 Sin red";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟 Mute";
          format-icons = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };

        tray = {
          spacing = 12;
          icon-size = 18;
        };
      }
    ];

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free", sans-serif;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: alpha(${mocha.base}, 0.82);
        color: ${mocha.text};
        border-bottom: 2px solid ${mocha.mauve};
      }

      #custom-launcher,
      #custom-faith,
      #custom-power,
      #clock,
      #cpu,
      #memory,
      #battery,
      #network,
      #pulseaudio,
      #tray,
      #window {
        ${pill}
      }

      #workspaces button {
        ${pill}
        padding: 2px 10px;
        color: ${mocha.subtext};
        font-size: 16px;
      }

      #workspaces button.active {
        background-color: ${mocha.mauve};
        color: ${mocha.crust};
        border-color: ${mocha.lavender};
      }

      #workspaces button.urgent {
        background-color: ${mocha.red};
        color: ${mocha.crust};
      }

      #clock {
        color: ${mocha.lavender};
        font-weight: bold;
        min-width: 180px;
      }

      #custom-faith {
        color: ${mocha.yellow};
      }

      #custom-power {
        color: ${mocha.red};
      }

      #custom-launcher {
        color: ${mocha.mauve};
        font-size: 16px;
      }

      #battery.warning {
        color: ${mocha.yellow};
      }

      #battery.critical {
        color: ${mocha.red};
      }

      #window {
        color: ${mocha.subtext};
      }

      tooltip {
        background-color: ${mocha.mantle};
        border: 1px solid ${mocha.mauve};
        border-radius: 10px;
        color: ${mocha.text};
      }
    '';
  };
}
