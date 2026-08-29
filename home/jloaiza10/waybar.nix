{
  config,
  pkgs,
  lib,
  ...
}:
let
  mocha = {
    base = "#1e1e2e";
    mantle = "#181825";
    surface0 = "#313244";
    surface1 = "#45475a";
    text = "#cdd6f4";
    subtext = "#a6adc8";
    mauve = "#cba6f7";
    blue = "#89b4fa";
    green = "#a6e3a1";
    red = "#f38ba8";
    yellow = "#f9e2af";
  };
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        height = 34;
        spacing = 6;
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "battery"
          "tray"
        ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            active = "";
            default = "";
            urgent = "";
          };
        };

        "hyprland/window" = {
          max-length = 48;
          format = "{title}";
        };

        clock = {
          format = "{:%a %d %b  %H:%M}";
          tooltip-format = "<big>{:%Y %B %d}</big>\n<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          format = " {usage}%";
          tooltip = false;
        };

        memory = {
          format = " {}%";
          tooltip = false;
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        network = {
          format-wifi = " {signalStrength}%";
          format-ethernet = " Eth";
          format-disconnected = " Off";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " Muted";
          format-icons = [
            ""
            ""
            ""
          ];
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };

        tray = {
          spacing = 10;
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
        background-color: ${mocha.mantle};
        color: ${mocha.text};
        border-bottom: 2px solid ${mocha.surface0};
      }

      #workspaces button {
        padding: 0 8px;
        color: ${mocha.subtext};
        border-radius: 8px;
        margin: 4px 2px;
      }

      #workspaces button.active {
        background-color: ${mocha.surface0};
        color: ${mocha.mauve};
      }

      #workspaces button.urgent {
        color: ${mocha.red};
      }

      #clock {
        color: ${mocha.mauve};
        font-weight: bold;
      }

      #cpu,
      #memory,
      #battery,
      #network,
      #pulseaudio,
      #tray {
        padding: 0 10px;
        color: ${mocha.text};
      }

      #battery.warning {
        color: ${mocha.yellow};
      }

      #battery.critical {
        color: ${mocha.red};
      }

      tooltip {
        background-color: ${mocha.base};
        border: 1px solid ${mocha.surface1};
        border-radius: 8px;
      }
    '';
  };
}
