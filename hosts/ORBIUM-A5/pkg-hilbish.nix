{ config, pkgs, lib, ... }:
let
  hilbish = import ../../modules/overlays/hilbish.nix { inherit pkgs lib; };
in
{
  environment.systemPackages = with pkgs; [
    hilbish
  ];
}

