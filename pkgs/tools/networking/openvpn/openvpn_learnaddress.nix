{ lib, stdenv, fetchFromGitHub, makeWrapper, coreutils, gawk, util-linux }:

stdenv.mkDerivation {
  pname = "openvpn-learnaddress";
  version = "unstable-2013-10-21";

  src = fetchFromGitHub {
    owner = "offlinehacker";
    gist = "4058733";
    rev = "19b03c3beb0190df46ea07bf4b68244acb8eae80";
    hash = "sha256-gnzkEEUKkqYob3jbv19qjedKDUh9TslAJKNrDv327Jo=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ coreutils gawk util-linux ];

  installPhase = ''
    install -Dm555 ovpn-learnaddress $out/libexec/openvpn/openvpn-learnaddress

    wrapProgram $out/libexec/openvpn/openvpn-learnaddress \
        --prefix PATH : ${lib.makeBinPath [ coreutils gawk util-linux ]}
  '';

  meta = {
    description = "Openvpn learn-address script to manage a hosts-like file";
    homepage = "https://gist.github.com/offlinehacker/4058733/";
    maintainers = [ lib.maintainers.offline ];
    platforms = lib.platforms.unix;
  };
}
