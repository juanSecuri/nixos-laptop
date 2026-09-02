{ ... }:
{
  # Rofi requires quoted hex colors in .rasi — unquoted # breaks the parser.
  home.file.".config/rofi/config.rasi".text = ''
    configuration {
      modi: "drun,run,window";
      show-icons: true;
      icon-theme: "Papirus-Dark";
      font: "JetBrainsMono Nerd Font 12";
      display-drun: "  Apps";
      drun-display-format: "{name}";
      location: 0;
      yoffset: 24;
      xoffset: 0;
      fixed-num-lines: true;
      lines: 10;
      columns: 1;
      width: 40%;
      terminal: "kitty";
    }

    * {
      background-color: transparent;
      text-color: #cdd6f4;
      border: 0;
    }

    window {
      background-color: #1e1e2e;
      border: 2px;
      border-color: #cba6f7;
      border-radius: 20px;
      padding: 20px;
    }

    inputbar {
      background-color: #181825;
      border-radius: 14px;
      padding: 14px 18px;
      margin-bottom: 14px;
      children: [prompt, entry];
      border: 1px solid #313244;
    }

    prompt {
      text-color: #cba6f7;
      margin-right: 10px;
    }

    entry {
      text-color: #cdd6f4;
    }

    listview {
      lines: 10;
      columns: 1;
      spacing: 6px;
      fixed-height: true;
    }

    element {
      padding: 12px 16px;
      border-radius: 12px;
    }

    element selected {
      background-color: #313244;
      text-color: #b4befe;
    }

    element-text {
      background-color: transparent;
    }

    element-icon {
      size: 28px;
      margin: 0 10px 0 0;
    }

    mode-switcher {
      spacing: 8px;
    }

    button {
      padding: 8px 14px;
      border-radius: 10px;
      background-color: #181825;
      text-color: #a6adc8;
    }

    button selected {
      background-color: #cba6f7;
      text-color: #11111b;
    }
  '';
}
