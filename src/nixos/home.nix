wrapped_nvidia_settings = pkgs.runCommand "wrapped-nvidia-settings" {
  buildInputs = [ pkgs.makeWrapper ];
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nvidiaSettings}/bin/nvidia-settings $out/bin/nvidia-settings \
    --set LD_LIBRARY_PATH "${lib.makeLibraryPath [ pkgs.mesa.libGL pkgs.mesa.libEGL ]}:${pkgs.stdenv.lib.getLib pkgs.nvidiaSettings}"
''; 