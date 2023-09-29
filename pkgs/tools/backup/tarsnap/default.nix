{ lib, stdenv, fetchFromGitHub, fetchurl, openssl, zlib, e2fsprogs, bzip2 }:

let
  zshCompletion = fetchFromGitHub {
    owner = "thoughtpolice";
    gist = "daa9431044883d3896f6";
    rev = "282360677007db9739e5bf229873d3b231eb303a";
    hash = "sha256-NRZPJf85ykr1CAxwSxV5PmCePwWZbZJSx2EUfjLapjQ=";
  };
in
stdenv.mkDerivation rec {
  pname = "tarsnap";
  version = "1.0.40";

  src = fetchurl {
    url = "https://www.tarsnap.com/download/tarsnap-autoconf-${version}.tgz";
    hash = "sha256-vMrlOAwcHWviXcz7fC6qg2S6NAGq+u5h48VXQgPCf9U=";
  };

  preConfigure = ''
    configureFlags="--with-bash-completion-dir=$out/share/bash-completion/completions"
  '';

  patchPhase = ''
    substituteInPlace Makefile.in \
      --replace "command -p mv" "mv"
    substituteInPlace configure \
      --replace "command -p getconf PATH" "echo $PATH"
  '';

  postInstall = ''
    # Install some handy-dandy shell completions
    install -m 444 -D ${zshCompletion}/tarsnap.zsh $out/share/zsh/site-functions/_tarsnap
  '';

  buildInputs = [ openssl zlib ] ++ lib.optional stdenv.isLinux e2fsprogs
                ++ lib.optional stdenv.isDarwin bzip2;

  meta = {
    description = "Online backups for the truly paranoid";
    homepage    = "http://www.tarsnap.com/";
    license     = lib.licenses.unfree;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ thoughtpolice roconnor ];
    mainProgram = "tarsnap";
  };
}
