{
  description = "NixOS laptop — Lenovo V14 G4 ABP (jloaiza10)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      disko,
      nixos-hardware,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      username = "jloaiza10";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.lenovo-v14 = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs username;
        };
        modules = [
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          ./hosts/lenovo-v14
        ];
      };

      devShells.${system} = {
        default = pkgs.mkShell {
          packages = [ pkgs.nixfmt-classic ];
        };

        python = pkgs.mkShell {
          packages = with pkgs; [
            python311
            uv
            ruff
            tesseract
            poppler_utils
          ];
          shellHook = "echo 'Python shell — FastAPI / OCR / Supabase'";
        };

        node = pkgs.mkShell {
          packages = with pkgs; [
            nodejs_22
            pnpm
          ];
          shellHook = "echo 'Node shell — pnpm / Vite / Next.js'";
        };

        profit-catalyst = pkgs.mkShell {
          packages = with pkgs; [
            python311
            uv
            ruff
            tesseract
            poppler_utils
            chromedriver
            geckodriver
            pkgs.docker-compose
            postgresql_16
            pkgs."supabase-cli"
            gnumake
            nodejs_22
            pnpm
          ];
          shellHook = "echo 'TPC shell — agente-ia-angela, bookkeeping, DIAN, cash-flow'";
        };
      };

      formatter.${system} = pkgs.nixfmt-classic;
    };
}
