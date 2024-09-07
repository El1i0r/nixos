{ config, pkgs, ... }: {
  nixpkgs.overlays = [
      (final: prev: {
        awesomeWM = prev.awesome.overrideAttrs (old: rec {
          pname = "awesomeWM";
          src = prev.fetchFromGitHub {
            owner = "awesomeWM";
            repo = "awesome";
            rev = "master";
            hash = "sha256-+6G4G6mjWYvXSdI2fx39K9/Hh9BrTLNO8PuQSR41gHQ=";#"sha256-uaskBbnX8NgxrprI4UbPfb5cRqdRsJZv0YXXshfsxFU=";
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
