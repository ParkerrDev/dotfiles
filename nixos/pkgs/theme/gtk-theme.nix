{ stdenvNoCC, fetchurl, gtk-engine-murrine }:

stdenvNoCC.mkDerivation {
  pname = "zorin-mint-light";
  version = "1.0";

  src = ./zorin-mint-light.tar.gz;

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    mkdir -p $out/share/themes/Zorin-Mint-Light
    tar -xzvf $src -C $out/share/themes/Zorin-Mint-Light --strip-components=1
  '';
}
