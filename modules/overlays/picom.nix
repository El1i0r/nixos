
{
  config,
  pkgs,
  inputs,
  ...
}: 
{
	environment.systemPackages = with pkgs; [
  (picom.overrideAttrs (oldAttrs: rec {
    src = fetchFromGitHub {
      owner = "pijulius";
      repo = "picom";
      rev = "next";
      hash = "sha256-rxGWAot+6FnXKjNZkMl1uHHHEMVSxm36G3VoV1vSXLA=";
    };
  }))
];
}
