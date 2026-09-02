{
  lib,
  pkgs,
  ...
}:
{
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    pkgs.docker-compose
    pkgs.docker-buildx
    lazydocker
    dive
  ];

  # Optional: run n8n locally
  # docker run -d --name n8n -p 5678:5678 -v n8n_data:/home/node/.n8n n8nio/n8n
  systemd.services.n8n = {
    enable = lib.mkDefault false;
    description = "n8n workflow automation (Docker)";
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Restart = "always";
      ExecStartPre = "${pkgs.docker}/bin/docker pull n8nio/n8n";
      ExecStart = ''
        ${pkgs.docker}/bin/docker run --rm --name n8n \
          -p 5678:5678 \
          -v n8n_data:/home/node/.n8n \
          n8nio/n8n
      '';
      ExecStop = "${pkgs.docker}/bin/docker stop n8n";
    };
  };
}
