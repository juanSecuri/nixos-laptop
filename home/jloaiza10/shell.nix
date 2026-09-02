{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    history = {
      size = 50000;
      save = 50000;
    };
    shellAliases = {
      ls = "eza --icons";
      ll = "eza -la --icons";
      la = "eza -a --icons";
      lt = "eza --tree --level=2 --icons";
      cat = "bat";
      g = "git";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-laptop#lenovo-v14";
      update = "cd ~/nixos-laptop && nix flake update && sudo nixos-rebuild switch --flake .#lenovo-v14";
      rollback = "sudo nixos-rebuild switch --rollback";
      projects = "cd ~/Projects";
    };
    initExtra = ''
      if command -v starship &>/dev/null; then
        eval "$(starship init zsh)"
      fi
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
      directory = {
        truncate_to_repo = true;
        style = "bold lavender";
      };
      git_branch = {
        symbol = " ";
        style = "bold mauve";
      };
      python.disabled = false;
      nodejs.disabled = false;
      package.disabled = true;
    };
  };

  home.sessionVariables = {
    EDITOR = "cursor";
    VISUAL = "cursor";
    TERMINAL = "kitty";
    BROWSER = "firefox";
    XDG_CURRENT_DESKTOP = "Hyprland";
  };

  home.packages = with pkgs; [
    starship
    zoxide
  ];

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
