# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, inputs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./overlays.nix
      ./xonsh.nix
      inputs.home-manager.nixosModules.default
    ];
  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = {inherit inputs;};
    users = {
      "el1i0r" = import ./home.nix;
    };
  };
  # TESTING PART, DO NOT UNCOMMENT UNLESS YOU KNOW WHAT THE HECK YOU ARE DOING
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };
  # TESTING PART END


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "ORBIUM-A5"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  services.flatpak.enable = true;
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  programs.appimage.binfmt = true;
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Karachi";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system, configure keymap in X11, and enable awesomeWM
  # services.xserver.enable = true;
  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  #eh no
  programs.zsh.enable = true;
  users.defaultUserShell = config.programs.xonsh.package;
  programs.xonsh.enable = true;
  programs.xonsh.package = pkgs.xonsh.wrapper.override { extraPackages = ps: [
  (ps.buildPythonPackage rec {
    name = "xontrib-sh";
    version = "0.3.1";

    src = pkgs.fetchFromGitHub {
    owner = "anki-code";
      repo = "${name}";
      rev = "${version}";
      sha256 = "KL/AxcsvjxqxvjDlf1axitgME3T+iyuW6OFb1foRzN8=";
    };

    meta = {
      homepage = "https://github.com/anki-code/xontrib-sh";
      description = "Paste and run commands from bash, fish, zsh, tcsh in xonsh shell.";
      license = pkgs.lib.licenses.mit;
      maintainers = [ ];
    };

    prePatch = ''
   #     pkgs.lib.substituteInPlace pyproject.toml --replace '"xonsh>=0.12.5"' ""
    '';
   #  patchPhase = "sed -i -e 's/^dependencies.*$/dependencies = []/' pyproject.toml";
   # doCheck = false;
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
  ]; };

  # Enable the GNOME Desktop Environment.
  services.xserver.desktopManager.gnome.enable = true;
  #DM
  services.greetd.package = pkgs.greetd.regreet;
  services.greetd.enable = true;
  programs.regreet.enable = true;
  programs.regreet.theme.name = "Colloid-Orange-Dark-Gruvbox";
  programs.regreet.font.name = "CozetteHiDpi";
  programs.regreet.iconTheme.name = "Reversal-Orange";
  #yeah the monstrosity is finished
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
 # services.pipewire = {
 #   enable = true;
 #   alsa.enable = true;
 #   alsa.support32Bit = true;
 #   pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-xsession.enable = true;
 # };
  services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  wireplumber = {
    enable = true;
    extraConfig = {
      "10-disable-camera" = {
        "wireplumber.profiles" = {
          main."monitor.libcamera" = "disabled";
          };
        };
      };
    };
  };
  # Enable touchpad support (enabled default in most desktopManager).
   services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.el1i0r = {
    isNormalUser = true;
    description = "El1i0r";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    pkgs.neovim
    pkgs.wget
    pkgs.python312Packages.pip
    pkgs.jetbrains.gateway
    pkgs.git
    pkgs.virt-manager
    pkgs.python312Packages.django
    pkgs.sassc
    pkgs.greetd.regreet
    pkgs.gtk-engine-murrine
    pkgs.gnome-themes-extra
    pkgs.rPackages.curl
    pkgs.starship
    pkgs.zsh-autosuggestions
    pkgs.zsh
    xonsh
    pkgs.python312Packages.pipx
    pkgs.nerdfonts
    pkgs.zsh-f-sy-h
    pkgs.jetbrains.pycharm-community-src
    pkgs.jetbrains-toolbox
    pkgs.python3
    #gnomies
    pkgs.gnome-tweaks
    pkgs.gnomeExtensions.tweaks-in-system-menu
    pkgs.gnomeExtensions.blur-my-shell
    pkgs.gnomeExtensions.arcmenu
    pkgs.gnomeExtensions.desktop-icons-ng-ding
    #other idiocy
    pkgs.zed-editor
    btop
    acpi
    killall
    pkgs.alacritty
    pkgs.luajit
    pkgs.scrot
    pkgs.xorg.libxcb
    pkgs.xorg.libXcursor
    pkgs.xorg.xkbutils
    pkgs.xorg.xcbutilkeysyms
    pkgs.xorg.xcbutilrenderutil
    pkgs.xorg.xcbutilwm
    pkgs.xorg.xcbutilimage
    pkgs.xorg.xcbutilerrors
    pkgs.xorg.xcbutil
    pkgs.xorg.fontutil
    pkgs.obs-studio
    pkgs.xcb-util-cursor
    pkgs.wmutils-opt
    pkgs.wmutils-libwm
    pkgs.wmutils-core
    pkgs.libxkbcommon
    pkgs.xcbutilxrm
    pkgs.libstartup_notification
    pkgs.cairo
    pkgs.python312Packages.django
    pkgs.dbus
    pkgs.asciidoctor
    pkgs.librsvg
    pkgs.wmctrl
    pkgs.gtk3
    pkgs.nemo-with-extensions
    pkgs.wezterm
    pkgs.folder-color-switcher
    pkgs.nemo-fileroller
    pkgs.nemo-emblems
    pkgs.nemo-python
    pkgs.lf
    pkgs.cowsay
    pkgs.nitch
    pkgs.fastfetch
    pkgs.gtk4
    pkgs.gtk2
    pkgs.gnumake
    pkgs.pango
    pkgs.glib
    pkgs.gio-sharp
    pkgs.xwinwrap
    pkgs.brightnessctl
    pkgs.picom-pijulius
    pkgs.nautilus
    luajitPackages.luarocks
    xorg.xprop
    xorg.xinit
    python312Packages.cmake
    luajitPackages.lgi
    luajit
    xorg.xorgproto
    xorg.libxcb
    xcb-util-cursor
    xorg.xcbutil
    xorg.xcbutilkeysyms
    cairo
    pango
    pkgs.betterdiscordctl
    glib
    haskellPackages.gio
    pkgs.xorg.libX11
    pkgs.imagemagick
    pkgs.libxdg_basedir
    pkgs.gdk-pixbuf-xlib
    pkgs.discord

  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
