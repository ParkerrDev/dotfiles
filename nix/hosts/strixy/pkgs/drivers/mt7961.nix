{ stdenv, lib }:
stdenv.mkDerivation {
  pname = "mt7961-firmware";
  version = "1.0";
  src = ./binaries;
  
  installPhase = ''
    mkdir -p $out/lib/firmware/mediatek
    cp $src/BT_RAM_CODE_MT7961_1_2_hdr.bin $out/lib/firmware/mediatek
    cp $src/WIFI_MT7961_patch_mcu_1_2_hdr.bin $out/lib/firmware/mediatek
    cp $src/WIFI_RAM_CODE_MT7961_1.bin $out/lib/firmware/mediatek
  '';
}
