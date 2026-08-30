{
  description = "NixOS dev laptop — Lenovo V14 G4 ABP (jloaiza10)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
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
        default = nixpkgs.legacyPackages.${system}.mkShell {
          packages = with nixpkgs.legacyPackages.${system}; [
            nixfmt
          ];
        };

        python = nixpkgs.legacyPackages.${system}.mkShell {
          packages = with nixpkgs.legacyPackages.${system}; [
            python311
            uv
            ruff
            tesseract
            poppler-utils
          ];
          shellHook = ''
            echo "Python dev shell — FastAPI / OCR projects"
          '';
        };

        node = nixpkgs.legacyPackages.${system}.mkShell {
          packages = with nixpkgs.legacyPackages.${system}; [
            nodejs_22
            pnpm
          ];
          shellHook = ''
            echo "Node dev shell — pnpm monorepos"
          '';
        };

        # The Profit Catalyst — FastAPI + Postgres + QBO + Supabase + Docker
        profit-catalyst = nixpkgs.legacyPackages.${system}.mkShell {
          packages = with nixpkgs.legacyPackages.${system}; [
            python311
            uv
            ruff
            tesseract
            poppler-utils
            chromedriver
            geckodriver
            docker-compose
            postgresql_16
            supabase-cli
            gnumake
            nodejs_22
            pnpm
          ];
          shellHook = ''
            echo "TPC dev shell — agente-ia-angela, bookkeeping, contable DIAN, cash-flow, allapattah, iot"
          '';
        };
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
    };
}
