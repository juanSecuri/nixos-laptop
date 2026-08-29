{ ... }:
{
  programs.git = {
    enable = true;
    userName = "Juan Esteban Gallego Loaiza";
    userEmail = "juan.gallego.sec@gmail.com";
    delta.enable = true;
    lfs.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
      credential.helper = "cache --timeout=36000";
    };
    aliases = {
      st = "status -sb";
      co = "checkout";
      br = "branch";
      lg = "log --oneline --graph --decorate -15";
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      editors = {
        cursor = {
          command = [ "cursor" "--wait" "--reuse-window" ];
        };
      };
    };
  };
}
