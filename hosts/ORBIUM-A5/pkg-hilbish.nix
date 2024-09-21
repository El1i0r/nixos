{ config, pkgs, lib, ... }:
let
  hilbish = import ../../modules/overlays/hilbish.nix { inherit pkgs; };
in
{
  environment.systemPackages = with pkgs; [
    hilbish
  ];
}

