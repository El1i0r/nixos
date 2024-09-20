{ config, pkgs, ... }:
let
  hilbish = import ../../mdoules/overlays/hilbish.nix { inherit pkgs lib; };
in
{
  environment.systemPackages = with pkgs; [
    hilbish
  ];
}

