{ 
 config,
 inputs,
 pkgs,
 ...
}:
{

 programs.xonsh.package = pkgs.xonsh.wrapper.override { extraPackages = ps: [
  (ps.buildPythonPackage rec {
    name = "xontrib-sh";
    version = "0.3.1";

    src = pkgs.fetchFromGitHub {
    owner = "anki-code";
      repo = "${name}";
      rev = "${version}";
      sha256 = "sha256-KL/AxcsvjxqxvjDlf1axitgME3T+iyuW6OFb1foRzN8=";
    };

    meta = {
      homepage = "https://github.com/anki-code/xontrib-sh";
      description = "Paste and run commands from bash, fish, zsh, tcsh in xonsh shell.";
      license = pkgs.lib.licenses.mit;
      maintainers = [ ];
    };

    prePatch = ''

    '';

  #  doCheck = false;
  })
  (ps.buildPythonPackage rec {
    name = "xontrib-fish-completer";
    version = "0.0.1";

    src = pkgs.fetchFromGitHub {
    owner = "xonsh";
      repo = "${name}";
      rev = "${version}";
      sha256 = "sha256-PhhdZ3iLPDEIG9uDeR5ctJ9zz2+YORHBhbsiLrJckyA=";
    };

    meta = {
      homepage = "https://github.com/xonsh/xontrib-fish-completer";
      description = "Populate rich completions using fish and remove the default bash based completer";
      license = pkgs.lib.licenses.mit;
      maintainers = [ ];
    };

    prePatch = ''
      pkgs.lib.substituteInPlace pyproject.toml --replace '"xonsh>=0.12.5"' ""
    '';
    patchPhase = "sed -i -e 's/^dependencies.*$/dependencies = []/' pyproject.toml";
    doCheck = false;
  })
  ]; }

}
