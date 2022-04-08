flake: {
  config,
  lib,
  ...
}: let
  cfg = config.images.netboot;
in {
  options = {
    images.netboot.enable = lib.mkEnableOption ''
      Whether to generate a netboot image.
    '';
  };

  imports = [
    # Conditionally import the image module
    (args @ {pkgs, ...}: let
      module = import "${flake.inputs.nixpkgs}/nixos/modules/installer/netboot/netboot.nix" args;
    in
    module // {
      options.images.netboot = module.options.netboot;
      config = lib.mkIf cfg.enable module.config;
  })
  ];
}
