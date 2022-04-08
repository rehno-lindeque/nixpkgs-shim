flake: {
  config,
  lib,
  ...
}: let
  cfg = config.images.isoImage;
in {
  options = {
    images.isoImage.enable = lib.mkEnableOption ''
      Whether to generate an ISO image file.
    '';
  };

  imports = [
    # Conditionally import the image module
    (args @ {pkgs, ...}: let
      module = import "${flake.inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix" args;
    in
    module // {
      options.images.isoImage = module.options.isoImage;
      config = lib.mkIf cfg.enable module.config;
    })
  ];
}
