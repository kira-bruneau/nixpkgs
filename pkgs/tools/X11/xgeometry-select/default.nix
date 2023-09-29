{ lib, stdenv, fetchFromGitHub, libX11 }:

stdenv.mkDerivation rec {
  pname = "xgeometry-select";
  version  = "0.1";

  src = fetchFromGitHub {
    owner = "obadz";
    gist = "7e008b1f803c4cdcfaf7321c78bcbe92";
    rev = "7e7361e71ff0f74655ee92bd6d2c042f8586f2ae";
    hash = "sha256-Adt3jrpSmDuxy1n4+6YuSKzdlsQpRZB40OWwcs1ASf8=";
  };

  buildInputs = [ libX11 ];

  buildPhase = ''
    gcc -Wall -lX11 ${src}/xgeometry-select.c -o xgeometry-select
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv -v xgeometry-select $out/bin
  '';

  meta = with lib; {
    description = "Select a region with mouse and prints geometry information (x/y/w/h)";
    homepage    = "https://bbs.archlinux.org/viewtopic.php?pid=660837";
    maintainers = with maintainers; [ obadz ];
    platforms   = platforms.linux;
  };
}
