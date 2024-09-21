{ config, pkgs, ... }:

let
  hilbish = pkgs.stdenv.mkDerivation {
    pname = "hilbish";
    version = "master"; # Replace with the actual version

    src = pkgs.fetchFromGitHub {
      owner = "Rosetta";
      repo = "hilbish";
      rev = "master"; # Replace with the specific commit or tag if needed
      sha256 = "0v1h8z6k3m4l5n7p8q9r2s3t4u5v6w7x8y9z0a1b2c3d4e5f6g7h8i9j0k1l2m3n"; # Replace with the actual hash
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
      homepage = "https://github.com/Rosetta/hilbish";
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

