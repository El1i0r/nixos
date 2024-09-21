{ config, pkgs, ... }:

let
  hilbish = pkgs.stdenv.mkDerivation {
    pname = "hilbish";
    version = "master"; # Replace with the actual version

    src = pkgs.fetchFromGitHub {
      owner = "Rosettea";
      repo = "hilbish";
      rev = "master"; # Replace with the specific commit or tag if needed
      sha256 = "sha256-bCV9hiTvtkdEMPEn9r5PxB+MqJk030E5YISN8B/4h4A="; # Replace with the actual hash
    };

    nativeBuildInputs = with pkgs; [
      cmake
      gcc
    ];

    buildInputs = with pkgs; [
      lua
      readline
    ];

    buildPhase = ''
      mkdir build
      cd build
      cmake ..
      make
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp build/hilbish $out/bin/
    '';

    meta = with pkgs.lib; {
      description = "A shell for Lua fans";
      homepage = "https://github.com/Rosettea/hilbish";
      license = licenses.mit;
      maintainers = with maintainers; [ el1i0r ];
    };
  };
in
{
  environment.systemPackages = with pkgs; [
    hilbish
  ];
}

