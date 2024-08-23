######################################################################################################################################
#          _____                    _____                                           _______                   _____                  #
#         /\    \                  /\    \                 ______                  /::\    \                 /\    \                 #
#        /::\____\                /::\    \               |::|   |                /::::\    \               /::\    \                #
#       /::::|   |                \:::\    \              |::|   |               /::::::\    \             /::::\    \               #
#      /:::::|   |                 \:::\    \             |::|   |              /::::::::\    \           /::::::\    \              #
#     /::::::|   |                  \:::\    \            |::|   |             /:::/~~\:::\    \         /:::/\:::\    \             #
#    /:::/|::|   |                   \:::\    \           |::|   |            /:::/    \:::\    \       /:::/__\:::\    \            #
#   /:::/ |::|   |                   /::::\    \          |::|   |           /:::/    / \:::\    \      \:::\   \:::\    \           #
#  /:::/  |::|   | _____    ____    /::::::\    \         |::|   |          /:::/____/   \:::\____\   ___\:::\   \:::\    \          #
# /:::/   |::|   |/\    \  /\   \  /:::/\:::\    \  ______|::|___|___ ____ |:::|    |     |:::|    | /\   \:::\   \:::\    \         #
#/:: /    |::|   /::\____\/::\   \/:::/  \:::\____\|:::::::::::::::::|    ||:::|____|     |:::|    |/::\   \:::\   \:::\____\        #
#\::/    /|::|  /:::/    /\:::\  /:::/    \::/    /|:::::::::::::::::|____| \:::\    \   /:::/    / \:::\   \:::\   \::/    /        #
# \/____/ |::| /:::/    /  \:::\/:::/    / \/____/  ~~~~~~|::|~~~|~~~        \:::\    \ /:::/    /   \:::\   \:::\   \/____/         #
#         |::|/:::/    /    \::::::/    /                 |::|   |            \:::\    /:::/    /     \:::\   \:::\    \             #
#         |::::::/    /      \::::/____/                  |::|   |             \:::\__/:::/    /       \:::\   \:::\____\            #
#         |:::::/    /        \:::\    \                  |::|   |              \::::::::/    /         \:::\  /:::/    /            #
#         |::::/    /          \:::\    \                 |::|   |               \::::::/    /           \:::\/:::/    /             #
#         /:::/    /            \:::\    \                |::|   |                \::::/    /             \::::::/    /              #
#        /:::/    /              \:::\____\               |::|   |                 \::/____/               \::::/    /               #
#        \::/    /                \::/    /               |::|___|                  ~~                      \::/    /                #
#         \/____/                  \/____/                 ~~                                                \/____/                 #
#                                                                                                                                    #
#                                                                                                                                    #
#																     #
#                                                           CONFIGURATION.NIX                                                        #
# Last commit: 16/Aug/2024      												     #
# Commit message: Modularizing and cleaning up                                                                                       #
# Directory: /etc/nixos/hosts/ORBIUM-A5												     #
#                                                        									     #	
# ----------------------------------------------------------- CONFIG START ----------------------------------------------------------#



                                                                                                                        
{ 
  config, 
  pkgs, 
  inputs, 
  ... 
}:

{


  # ENABLE FLAKES AND NIX-COMMANDS
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  imports =


    [ 
      ./hardware-configuration.nix
      ../../modules/overlays/awesomeWM.nix
      ../../modules/wrappers/xonsh-wrapped.nix
      ../../modules/overlays/picom.nix
  #    inputs.home-manager.nixosModules.default
    ];


 # home-manager = {
    # also pass inputs to home-manager modules
 #   extraSpecialArgs = {inherit inputs;};
 #   users = {
 #     "el1i0r" = import ./home.nix;
 #   };
 # };
  


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Hostname
  networking.hostName = "ORBIUM-A5";
 
  # Enable wireless networking
  # networking.wireless.enable = true;

  # Enable flatpak 
  services.flatpak.enable = true;
  
  # AutoUpgrade
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
 
  # App Image, TODO move to ./programs/appimage.nix, and make it actually work
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


  # Enable the X11 windowing system, configure keymap in X11, and enable GNOME, further idiocy in home.nix
  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
    # Enable the GNOME Desktop Environment.
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    desktopManager.session = [
     {
       name = "AwesomeWM";
       start = ''
        ${pkgs.runtimeShell} $HOME/.hm-xsession &
        waitPID=$!
       '';
     }
   ];
      xkb = {
      layout = "us";
      variant = "";
    };
  };
 


  # SHELL CONFIGS
  programs.zsh.enable = true;
  users.defaultUserShell = config.programs.xonsh.package;
  programs.xonsh.enable = true;
 
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
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


  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
    lxappearance
    pkgs.neovim
    pkgs.wget
    pkgs.python312Packages.pip
    pkgs.jetbrains.gateway
    pkgs.git
    pkgs.virt-manager
    pkgs.python312Packages.django
    pkgs.sassc
    pkgs.greetd.greetd
    pkgs.gtk-engine-murrine
    pkgs.gnome-themes-extra
    pkgs.rPackages.curl
    pkgs.starship
    pkgs.zsh-autosuggestions
    pkgs.zsh
    pkgs.python312Packages.pipx
    pkgs.nerdfonts
    pkgs.zsh-f-sy-h
    pkgs.jetbrains.pycharm-community-src
    pkgs.jetbrains-toolbox
    pkgs.python312Full
    #gnomies
    pkgs.gnome-tweaks
    pkgs.gnomeExtensions.tweaks-in-system-menu
    pkgs.gnomeExtensions.blur-my-shell
    pkgs.gnomeExtensions.arcmenu
    pkgs.gnomeExtensions.desktop-icons-ng-ding
    #other idiocy
    bunnyfetch
    pkgs.zed-editor
    pkgs.btop
    pkgs.acpi
    pkgs.killall
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal
    pkgs.xdg-desktop-portal-gnome
    pkgs.python312Packages.distro
    pkgs.python312Packages.pyxdg
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
    #pkgs.picom-next# picom ===>>> ../../modules/overlays/picom.nix 
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
    pkgs.kitty
    tmux
    tmuxPlugins.gruvbox
    # prepare for death
    (picom.overrideAttrs (oldAttrs: rec {
      src = fetchFromGitHub {
        owner = "pijulius";
        repo = "picom";
        rev = "next";
        hash = "sha256-59I6uozu4g9hll5U/r0nf4q92+zwRlbOD/z4R8TpSdo=";
      };
     nativeBuildInputs = [
         asciidoctor
     ] ++ oldAttrs.nativeBuildInputs;
    }))
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
   programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };


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
