{ config, pkgs, ... }: {
  nixpkgs.overlays = [
      (final: prev: {
        awesomeWM = prev.awesome.overrideAttrs (old: rec {
          pname = "awesomeWM";
          src = prev.fetchFromGitHub {
            owner = "awesomeWM";
            repo = "awesome";
            rev = "master";
            hash = "sha256-uaskBbnX8NgxrprI4UbPfb5cRqdRsJZv0YXXshfsxFU=";
          };
          patches = [];


          postPatch = ''
            patchShebangs tests/examples/_postprocess.lua
          '';
        });
      }
      )
   ];
} 
