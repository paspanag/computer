# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
	services.monado = {
		enable = true;
		defaultRuntime = true; # Register as default OpenXR runtime
	};

	systemd.user.services.monado.environment = {
		STEAMVR_LH_ENABLE = "1";
		XRT_COMPOSITOR_COMPUTE = "1";
	};

}
