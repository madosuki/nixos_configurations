{
  description = "NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    # home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, sops-nix }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      # specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        sops-nix.nixosModules.sops
        ({ ... }: {
           nixpkgs.overlays = [
             (import ./overlays/my_overlay/overlay.nix)
           ];
        })
      ];
    };
  };
}
