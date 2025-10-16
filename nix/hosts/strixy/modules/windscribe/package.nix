{ lib
, stdenv
, fetchurl
, dpkg
, autoPatchelfHook
, makeWrapper
, wrapGAppsHook
, qt6Packages
, glib
, gtk3
, mesa
, nspr
, nss
, systemd
, xorg
, libudev0-shim
, curl
, openssl
, qt6
, libnl
, libcap_ng
}:

stdenv.mkDerivation rec {
  pname = "windscribe";
  version = "2.11.11";

  src = fetchurl {
    url = "https://github.com/Windscribe/Desktop-App/releases/download/v${version}/windscribe-cli_${version}_amd64.deb";
    sha256 = "05bdmlrnfc47z1fvphjfqdbsy8215246g6m7fdadbv2pj69krxyd";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    mesa
    nspr
    nss
    systemd
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXtst
    libudev0-shim
    curl
    openssl
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    libnl
    libcap_ng
  ];

  dontWrapGApps = true;

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,etc,opt,usr/lib/systemd,usr/polkit-1}

    cp -r opt/windscribe $out/opt/
    cp -r etc/windscribe $out/etc/
    cp -r usr/lib/systemd $out/usr/lib/
    cp -r usr/polkit-1 $out/usr/

    chmod +x $out/opt/windscribe/{Windscribe,windscribe-cli,windscribe-authhelper,windscribectrld,windscribeopenvpn,windscribewireguard,windscribewstunnel,helper}
    chmod +x $out/etc/windscribe/*

    ln -s $out/opt/windscribe/windscribe-cli $out/bin/windscribe-cli
    ln -s $out/opt/windscribe/Windscribe $out/bin/windscribe
    ln -s $out/opt/windscribe/helper $out/bin/windscribe-helper

    runHook postInstall
  '';

  postFixup = ''
    for binary in windscribe windscribe-cli windscribe-helper; do
      qtWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : "$out/opt/windscribe/lib"
        --prefix PATH : ${lib.makeBinPath [ stdenv.cc.cc ]}
        --set QT_PLUGIN_PATH "$out/opt/windscribe/plugins"
      )
      wrapQtApp "$out/bin/$binary"
    done

    for binary in $out/opt/windscribe/{windscribe-authhelper,windscribectrld,windscribeopenvpn,windscribewireguard,windscribewstunnel}; do
      wrapProgram "$binary" \
        --prefix LD_LIBRARY_PATH : "$out/opt/windscribe/lib" \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs} \
        --prefix PATH : ${lib.makeBinPath [ stdenv.cc.cc ]}
    done
  '';

  meta = with lib; {
    description = "Windscribe VPN Client";
    homepage = "https://windscribe.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ ParkerrDev ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
