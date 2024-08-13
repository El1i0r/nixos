{ config, lib, pkgs, ... }: let
  xonshWithXontribs = pkgs.xonsh.overrideAttrs (oldAttrs: {
    propagatedBuildInputs =
      oldAttrs.propagatedBuildInputs
      ++ (with config.nur.repos.xonsh-xontribs; [
        xontrib-term-integrations
        xontrib-zoxide
      ]);
  });
in {
  programs.xonsh = {
    enable = true;
    package = xonshWithXontribs;
  };
}
