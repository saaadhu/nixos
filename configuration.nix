# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # Switch kernel to 4.14 for Parallels compatibility
  boot.kernelPackages = pkgs.linuxPackages_4_14;

  nixpkgs.config.allowUnfree = true;
  hardware.parallels.enable = true;
  hardware.parallels.package = 
    let src = pkgs.fetchgit { 
	    url = "https://github.com/saaadhu/prl-tools.git";
	    rev = "e42c51e38a74ec161da80da5c56f99204f2a67b4";
	    sha256 = "0d5aq8sz5wk2dnhwqv3bhkmzkkfyv138d6qpznrgsasvas6gm0d1";
    };
    in pkgs.linuxPackages_4_14.callPackage "${src}/default.nix" {};

  networking.hostName = "nightfury";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s5.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  fonts.fonts = with pkgs; [
    inconsolata
    iosevka
    jetbrains-mono
    tamsyn
    terminus_font
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     emacs
     firefox
     git
     htop
     jq
     openssh
     p7zip
     patchelf
     python
     ripgrep
     tmux
     unzip
     vim
     wget
     zip
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
   services.xserver.config = ''
# DefaultFlags section
Section "ServerFlags"
	Option	"AllowEmptyInput"	"yes"
	Option	"AutoAddDevices"	"yes"
EndSection

# Parallels Video section
Section "Device"
	Identifier	"Parallels Video"
	Driver	"prlvideo"
EndSection

# Parallels Monitor section
Section "Monitor"
	Identifier	"Parallels Monitor"
	VendorName	"Parallels Inc."
	ModelName	"Parallels Monitor"
EndSection

# Parallels Screen section
Section "Screen"
	Identifier	"Parallels Screen"
	Device	"Parallels Video"
	Monitor	"Parallels Monitor"
	Option	"NoMTRR"
	SubSection	"Display"
		Depth	24
		Modes	"1024x768" "800x600" "640x480"
	EndSubSection
EndSection

# DefaultFlags section
Section "ServerFlags"
	Option	"AllowEmptyInput"	"yes"
	Option	"AutoAddDevices"	"yes"
EndSection

# DefaultLayout section
Section "ServerLayout"
	Identifier	"DefaultLayout"
	Screen	"Parallels Screen"
EndSection
   '';


  # Enable the X11 windowing system.
   services.xserver.enable = true;
   services.xserver.layout = "us";
   #services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
   services.xserver.libinput.enable = true;
   services.xserver.autoRepeatDelay = 180;
   services.xserver.autoRepeatInterval = 250;
  # Enable the KDE Desktop Environment.
   services.xserver.displayManager.sddm.enable = true;
   services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.saaadhu = {
     isNormalUser = true;
     extraGroups = [ "wheel"]; # Enable ‘sudo’ for the user.
  };

  services.ntp.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

  system.activationScripts.ldso = lib.stringAfter [ "usrbinenv" ] ''                       
       mkdir -m 0755 -p /lib64                                                                
       ln -sfn ${pkgs.glibc.out}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2.tmp   
       mv -f /lib64/ld-linux-x86-64.so.2.tmp /lib64/ld-linux-x86-64.so.2 # atomically replace 
     '';  

}

