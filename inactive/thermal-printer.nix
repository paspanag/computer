{ stdenv }:

stdenv.mkDerivation rec {
  pname = "thermal_printer";
  version = "1";

  nativeBuildInputs = kernel.moduleBuildDependencies;

  installPhase = ''
    mkdir -p $out/lib/udev/rules.d
    echo "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"1cbe\", ATTRS{idProduct}==\"0002\", MODE=\"0664\", GROUP=\"devices\"" > $out/lib/udev/rules.d/99-escpos.rules
  '';

  meta = with stdenv.lib; {
    description = "udev rules for thermal printer";
    platforms = platforms.linux;
  };
}
