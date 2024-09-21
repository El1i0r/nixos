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
      ./pkgs.nix
      ../../modules/overlays/awesomeWM.nix
      ../../modules/wrappers/xonsh-wrapped.nix
      ../../modules/overlays/hilbish.nix

    ];


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
  
  # Enable distro-hopping support
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  #Set your time zone.
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
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };


  # Install firefox.
  programs.firefox.enable = true;

  # Test COSMIC flake
  # hardware.system76.enableAll = true;
  services.desktopManager.cosmic.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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
