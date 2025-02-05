# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

	users.users.peter.packages = with pkgs; [
		firefox
		thunderbird
		discord
		git
		mpv
		btop
		plan9port
		feh
		zathura    
		vscode
		gnome-frog
		gnome-tweaks
		koreader
		calibre
		mupdf
		obs-studio
		chromium
		vlc
		krita
		freecad
		bambu-studio
		orca-slicer
		qutebrowser
		plover.dev
		mcomix
		aseprite
		blender
		freetube
		openscad
		heroic
	];

	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
		dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
	};

	programs.nix-ld.enable = true;
	programs.direnv.enable = true;

	fonts.packages = with pkgs; [
		noto-fonts
		noto-fonts-cjk-sans
		noto-fonts-emoji
		liberation_ttf
		fira-code
		fira-code-symbols
		dina-font
		proggyfonts
		go-font
		atkinson-monolegible
		atkinson-hyperlegible
	];

	programs.git = {
		enable = true;
		lfs.enable = true;
	};

	programs.ssh.forwardX11 = true;
	programs.ssh.setXAuthLocation = true;
}
