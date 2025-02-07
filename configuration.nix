# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let
	sources = import ./nix/sources.nix;
	lanzaboote = import sources.lanzaboote;
in
{
	imports =
	[ 
		lanzaboote.nixosModules.lanzaboote

		# Include the results of the hardware scan.
		./hardware-configuration.nix
		./applications.nix
		./8bitdo-controller.nix
		./containers.nix
		./services.nix
		./lact.nix
		#      ./samba.nix
	];

	# Bootloader - use grub not systemdboot for dual boot
	#boot.loader.grub.enable = true;
	#boot.loader.grub.device = "nodev";
	#boot.loader.grub.efiSupport = true;
	#boot.loader.grub.useOSProber = true;

	boot.loader.efi.canTouchEfiVariables = true;
	boot.loader.systemd-boot.enable = lib.mkForce false;
	boot.loader.systemd-boot.consoleMode = "max";

	boot.lanzaboote = {
		enable = true;
		pkiBundle = "/etc/secureboot";
	};

	networking.hostName = "Ai"; # Define your hostname.
	# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

	# Configure network proxy if necessary
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

	# Enable networking
	networking.networkmanager.enable = true;

	# Set your time zone.
	time.timeZone = "America/Edmonton";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_GB.UTF-8";

	# Enable the X11 windowing system.
	services.xserver.enable = true;

	# AMD: driver support
	services.xserver.videoDrivers = [ "amdgpu" ];

	services.xserver.deviceSection = ''
	Option "VariableRefresh" "false"
	'';

	# Enable the GNOME Desktop Environment.
	services.xserver.displayManager.gdm.enable = true;
	services.xserver.desktopManager.gnome.enable = true;

	# Configure keymap in X11
	services.xserver.xkb = {
		layout = "us";
		variant = "";
	};

	# Enable CUPS to print documents.
	services.printing.enable = true;

	services.udev.packages = [];

	# Enable sound with pipewire.
	hardware.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		# If you want to use JACK applications, uncomment this
		#jack.enable = true;

		# use the example session manager (no others are packaged yet so this is enabled by default,
		# no need to redefine it in your config for now)
		#media-session.enable = true;
	};

	# Enable touchpad support (enabled default in most desktopManager).
	services.libinput.enable = true;

	# mouse settings
	services.libinput.mouse.accelProfile = "flat";

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.peter = {
		isNormalUser = true;
		description = "Pete Pan";
		extraGroups = [ "networkmanager" "wheel" "dialout" ];
	};

	# Enable automatic login for the user.
	services.displayManager.autoLogin.enable = true;
	services.displayManager.autoLogin.user = "peter";

	# Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
	systemd.services."getty@tty1".enable = false;
	systemd.services."autovt@tty1".enable = false;

	# AMD: HIP
	systemd.tmpfiles.rules = [
		"L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
	];

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
		wget
		git
		nixos-option
		sbctl
		slirp4netns
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
	# services.openssh.enable = true;

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	networking.firewall.enable = true;

	networking.firewall.allowedTCPPorts = [ 
		9099 8000 9000 8080 3000
	];


	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "23.11"; # Did you read the comment?

	# AMD: OpenCL and Vulkan
	# hardware.opengl.extraPackages = with pkgs; [
	#   rocmPackages.clr.icd
	#   amdvlk
	# ];

	# hardware.opengl.extraPackages32 = with pkgs; [
	#    driversi686Linux.amdvlk
	#  ];

	# hardware.opengl.driSupport = true; # This is already enabled by default
	# hardware.opengl.driSupport32Bit = true; # For 32 bit applications

	# passwordless sudo
	security.sudo.wheelNeedsPassword = false;

	nix.settings.experimental-features = [ "nix-command" "flakes" ];
	nix.settings.trusted-users = [ "root" "peter" ];

}
