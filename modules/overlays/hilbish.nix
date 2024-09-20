{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hilbish";
  version = "master";

  src = fetchFromGitHub {
    owner = "Rosettea";
    repo = "Hilbish";
    rev = "${version}";
    hash = "sha256-bCV9hiTvtkdEMPEn9r5PxB+MqJk030E5YISN8B/4h4A=";
    fetchSubmodules = true;
  };
  subPackages = [ "." ];

  vendorHash = "sha256-v5YkRZA8oOKwXa6yFGQ33jKEc742zIrmJ0+w8ggmu/0=";

  ldflags = [
    "-s"
    "-w"
    "-X main.dataDir=${placeholder "out"}/share/hilbish"
  ];

  postInstall = ''
    mkdir -p "$out/share/hilbish"

    cp .hilbishrc.lua $out/share/hilbish/
    cp -r docs -t $out/share/hilbish/
    cp -r libs -t $out/share/hilbish/
    cp -r nature $out/share/hilbish/
  '';

  meta = with lib; {
    description = "Interactive Unix-like shell written in Go";
    mainProgram = "hilbish";
    #changelog = "https://github.com/Rosettea/Hilbish/releases/tag/${version}";
    homepage = "https://github.com/Rosettea/Hilbish";
    maintainers = with maintainers; [ el1i0r ];
    license = licenses.mit;
  };
}
