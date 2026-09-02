{ pkgs, lib, ... }:
{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Catppuccin-Mocha-Standard-Blue-Dark";
    };
  };

  gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };
    font = {
      name = "Cantarell 11";
      package = pkgs.cantarell-fonts;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita-dark";
  };

  home.sessionVariables = {
    GTK_THEME = "Catppuccin-Mocha-Standard-Blue-Dark";
    QT_QPA_PLATFORMTHEME = "gtk3";
    ADW_DISABLE_PORTAL = "1";
  };

  home.packages = with pkgs; [
    catppuccin-gtk
    qt6Packages.qt6ct
    papirus-icon-theme
    bibata-cursors
  ];

  # Old fish config was symlinked from the store (read-only) — remove before HM writes it
  home.activation.fixFishConfig = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    if [ -e "$HOME/.config/fish" ]; then
      if [ -L "$HOME/.config/fish" ] || [ -L "$HOME/.config/fish/fish_variables" ]; then
        rm -rf "$HOME/.config/fish"
      fi
    fi
  '';
}
