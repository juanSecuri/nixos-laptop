{ pkgs, ... }:
let
  mocha = {
    base = "#1e1e2e";
    mantle = "#181825";
    surface0 = "#313244";
    text = "#cdd6f4";
    mauve = "#cba6f7";
    red = "#f38ba8";
    blue = "#89b4fa";
    green = "#a6e3a1";
  };
in
{
  home.file.".config/wlogout/layout".text = ''
    {
        "label" : "lock",
        "action" : "loginctl lock-session",
        "text" : "Lock",
        "keybind" : "l"
    },
    {
        "label" : "logout",
        "action" : "loginctl terminate-user $USER",
        "text" : "Logout",
        "keybind" : "e"
    },
    {
        "label" : "suspend",
        "action" : "systemctl suspend",
        "text" : "Sleep",
        "keybind" : "u"
    },
    {
        "label" : "reboot",
        "action" : "systemctl reboot",
        "text" : "Restart",
        "keybind" : "r"
    },
    {
        "label" : "shutdown",
        "action" : "systemctl poweroff",
        "text" : "Power",
        "keybind" : "s"
    }
  '';

  home.file.".config/wlogout/style.css".text = ''
    * {
        font-family: "JetBrainsMono Nerd Font", sans-serif;
        background-image: none;
        box-shadow: none;
    }

    window {
        background-color: alpha(${mocha.base}, 0.92);
    }

    button {
        color: ${mocha.text};
        background-color: ${mocha.mantle};
        border: 2px solid ${mocha.surface0};
        border-radius: 20px;
        margin: 12px;
        padding: 24px;
        font-size: 16px;
    }

    button:focus,
    button:hover {
        background-color: ${mocha.surface0};
        border-color: ${mocha.mauve};
        color: ${mocha.mauve};
    }

    #lock { color: ${mocha.blue}; }
    #logout { color: ${mocha.mauve}; }
    #suspend { color: ${mocha.green}; }
    #reboot { color: ${mocha.text}; }
    #shutdown { color: ${mocha.red}; }
  '';
}
