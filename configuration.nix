{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
	kernelPackages = pkgs.linuxPackages_latest;
	loader = {
  		systemd-boot.enable = true;
  		efi.canTouchEfiVariables = true;
	};
  };

  #Network
  networking = {
  	hostName = "nixos";
  	networkmanager.enable = true;
  };

  #Timezone
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
	LC_TIME = "sv_SE.UTF-8";
	LC_MONETARY = "sv_SE.UTF-8";
  };
  console = {
	font = "JetBrains-Mono";
	keyMap = "se";
	useXkbConfig = true; # use xkbOptions in tty.
  };

  #Unfree
  nixpkgs.config.allowUnfree = true;
 
  #nvidia
  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  #Xserver
  services = {
	xserver = {
		layout = "se";
		xkboptions = "eurosign:e";
		xkboptions = "caps:control";
		videoDrivers = ["Nvidia"];
		enable = true;
		layout = "se";
		displayManager.sddm.enable = true;
		displayManager.defaultSession = "none+i3";
		windowManager.i3 = {
			package = pkgs.i3-gaps;
			enable = true;
			extraPackages = with pkgs; [
				rofi
				dmenu
				i3status
			];
		};		
	};
  };

  # Sound.
  security.rtkit.enable = true;
  services.pipewire = {
	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
  };

  

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     thunderbird
  #   ];
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

