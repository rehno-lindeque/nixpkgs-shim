{
  description = "The nixpkgs flake, but with more internal modules exposed.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgs-shim-images.url = "path:./nixpkgs-shim-images";
    nixpkgs-shim-images.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-shim-profiles.url = "path:./nixpkgs-shim-profiles";
    nixpkgs-shim-profiles.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-shim-modules.url = "path:./nixpkgs-shim-modules";
    nixpkgs-shim-modules.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-shim-images,
    nixpkgs-shim-profiles,
    nixpkgs-shim-modules,
    ...
  }:
    nixpkgs
    // {
      nixosModules = let
        shimModules =
          # Regular NixOS modules defined inside nixpkgs (but not exported by nixpkgs)
          nixpkgs-shim-modules.nixosModules
          # Image building modules defined inside nixpkgs
          // nixpkgs-shim-images.nixosModules
          # Profile modules defined inside nixpkgs
          // nixpkgs-shim-profiles.nixosModules;
      in
        # The modules that ship with nixpkgs directly (re-exported)
        nixpkgs.nixosModules
        // shimModules
        // {
          default = {imports = builtins.attrValues shimModules;};
        };
    };
}
