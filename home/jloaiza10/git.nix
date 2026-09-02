{ ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    delta.enable = true;
    settings = {
      user.name = "Juan Esteban Gallego Loaiza";
      user.email = "juan.gallego.sec@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
      credential.helper = "cache --timeout=36000";
      alias = {
        st = "status -sb";
        co = "checkout";
        br = "branch";
        lg = "log --oneline --graph --decorate -15";
      };
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
