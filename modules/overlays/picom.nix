
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
      hash = "sha256-LOX+xbCqMehmI3Ji77OmQaWxeSJDdb9Jduo6cErVeys";
    };
  }))
];
}
