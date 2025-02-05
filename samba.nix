{ config, pkgs, ... }:

{
	services.samba = {
		package = pkgs.samba4Full;
		enable = true;
		securityType = "user";
		openFirewall = true;
		extraConfig = ''
			hosts allow = 192.168.0. 192.168.1. 127.0.0.1 localhost
		'';
		shares = {
			public = {
				path = "/home/peter/dh";
				browseable = "yes";
			};
		};
	};

	services.avahi = {
		publish.enable = true;
		publish.userServices = true;
		# ^^ Needed to allow samba to automatically register mDNS records (without the need for an `extraServiceFile`
		nssmdns4 = true;
		# ^^ Not one hundred percent sure if this is needed- if it aint broke, don't fix it
		enable = true;
		openFirewall = true;
	};

	networking.firewall.enable = true;
	networking.firewall.allowPing = true;
}
