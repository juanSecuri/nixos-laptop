{ ... }:
{
  programs.git = {
    enable = true;
    userName = "Juan Esteban Gallego Loaiza";
    userEmail = "juan.gallego.sec@gmail.com";
    lfs.enable = true;
    delta.enable = true;
    aliases = {
      st = "status -sb";
      co = "checkout";
      br = "branch";
      lg = "log --oneline --graph --decorate -15";
    };
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
      credential.helper = "cache --timeout=36000";
    };
  };

  programs.gh = {
    enable = true;
    gitProtocol = "ssh";
    settings = {
      prompt = "enabled";
    };
  };
}
