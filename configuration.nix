# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/lenovo/thinkpad/x1-extreme>
      ./hardware-configuration.nix
      ./includes/fonts.nix
     ./includes/zsh.nix
      ./includes/variables.nix
      ./includes/programs.nix
      ./includes/virtualisation.nix
      ./includes/nvidia.nix
    ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  console.keyMap = "us";
  console.font = "latarcyrheb-sun32";

  i18n = {
    # consoleFont = "latarcyrheb-sun32";
    # consoleKeyMap = "us";
    # defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "fcitx";
      fcitx.engines = with pkgs.fcitx-engines; [ chewing m17n unikey ];
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Saigon";
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget 
    vim
    neovim
    unar
    unzip
    file
    killall
    lambda-mod-zsh-theme
    docker
    docker_compose
    git
    nodejs 
    pulseeffects 
    flatpak
    python
    cmake
    gnumake
    python3Full
    gcc
    tmux
    binutils-unwrapped
    home-manager
    arandr
    autorandr
    # xorg.xf86videointel
    gnupg
    cabal-install
    cabal2nix
    stack
    hlint
    ghc
    go
    python37Packages.pip
    python37Packages.pylint                                                                                                                                                           
    pkg-config
    libffi
    gnutar
    zlib
    jq
    kubernetes-helm
    zoom-us
  ];
  
  # packages config 
  nixpkgs.config = {

    allowUnfree = true;
    packageOverrides = pkgs: rec {
      neovim = (import ./includes/vim.nix);

      linux = pkgs.linuxPackages.override {
        extraConfig = ''
          THUNDERBOLT m
        '';
      };
    };
    
    permittedInsecurePackages = [
      "p7zip-16.02"
    ];
  };
  
  # Enable dconf
  programs.dconf.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.extraHosts =
  ''
    127.0.0.1 data.lux-dev.hasura.me
    127.0.0.1 auth.lux-dev.hasura.me
    127.0.0.1 logs.lux-dev.hasura.me
    127.0.0.1 logs-grpc.lux-dev.hasura.me
    127.0.0.1 account.lux-dev.hasura.me
    127.0.0.1 metrics.lux-dev.hasura.me
    127.0.0.1 lux-dev.hasura.me
    127.0.0.1 tenant1.nginx.hasura.me
    127.0.0.1 tenant2.nginx.hasura.me
    127.0.0.1 tenant3.nginx.hasura.me
  '';
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    daemon = {
      config = {
        avoid-resampling = "yes";
      };
    };

    extraModules = [ pkgs.pulseaudio-modules-bt ];

    # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
    # Only the full build has Bluetooth support, so it must be selected here.
    package = pkgs.pulseaudioFull;
   
    extraConfig = "
      load-module module-switch-on-connect
    ";
  };
  
  # Enable bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.bluetooth.package = pkgs.bluezFull;
  # hardware.bluetooth.config = {
  #  General = {
  #    Enable = "Source,Sink,Media,Socket";
  #  };
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    dpi = 240;


    # Enable touchpad support.
    libinput.enable = true;
  
    # Enable the KDE Desktop Environment.
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
    
    # Configuration for high res (4k/5k) monitors that use dual channel.
    # Facts:
    #  - TwinView is automatically enabled in recent nvidia drivers (no need to enable it explicitly)
    #  - nvidiaXineramaInfo must be disabled, otherwise xmonad will treat the display as two monitors.
    # screenSection = ''
    #   Option "nvidiaXineramaInfo"  "false"
    # '';
  };
   # services.xserver.xkbOptions = "eurosign:e";
  # hardware.bumblebee = {
  #   enable = true; 
  #   driver = "nvidia";
  #   pmMethod = "none";
  #   connectDisplay = true;
  # };
  
  
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Set limits for esync.
  systemd.extraConfig = "DefaultLimitNOFILE=1048576";
  security.pam.loginLimits = [{
    domain = "*";
    type = "hard";
    item = "nofile";
    value = "1048576";
  }];

  # android device 
  programs.adb.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’. 
  users = {
    defaultUserShell = pkgs.zsh;
 
    users.hgiasac = {
      isNormalUser = true;
      extraGroups = [ "wheel" "sudo" "networkmanager" "audio" "video" "lxd" "docker" "adbusers" "lp"]; # Enable ‘sudo’ for the user.
      shell = pkgs.zsh;

    };
    
    users.www-data = {
      isNormalUser = false;
      extraGroups = [ "www-data" ];
    };
  };
  
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?
   
  # fix freeze when reboot
  boot = {

    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;


    # extraModprobeConfig = ''
    #   options bbswitch load_state=-1 unload_state=1 nvidia-drm
    # '';
    
    # extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
    
    # blacklistedKernelModules = [
    #   "nouveau" 
    #   "rivafb"
    #   "nvidiafb"
    #   "rivatv"
    #  "nv"
    # ];

    # kernelParams = [
    #   "acpi_osi=Linux"
    #   "i915.enable_psr=1"
    #   "i915.fastboot=1"
    #   "i915.enable_guc=2"
    # ];
 
  };
}
