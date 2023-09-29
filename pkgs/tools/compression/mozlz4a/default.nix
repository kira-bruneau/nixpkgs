{ lib, stdenv, fetchFromGitHub, python3, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "mozlz4a";
  version = "2018-08-23";

  src = fetchFromGitHub {
    owner = "kaefer3000";
    gist = "73febe1eec898cd50ce4de1af79a332a";
    rev = "a266410033455d6b4af515d7a9d34f5afd35beec";
    hash = "sha256-fAgDDX8waDRzx/THOb+iINAwmkvAq7rfLb17rN/7+5o=";
  };

  installPhase = ''
    mkdir -p "$out/bin" "$out/${python3.sitePackages}/"
    cp "${src}/mozlz4a.py" "$out/${python3.sitePackages}"

    echo "#!${runtimeShell}" >> "$out/bin/mozlz4a"
    echo "export PYTHONPATH='$PYTHONPATH'" >> "$out/bin/mozlz4a"
    echo "'${python3}/bin/python' '$out/${python3.sitePackages}/mozlz4a.py' \"\$@\"" >> "$out/bin/mozlz4a"
    chmod a+x "$out/bin/mozlz4a"
  '';

  buildInputs = [ python3 python3.pkgs.lz4 ];

  meta = {
    description = "A script to handle Mozilla's mozlz4 files";
    license = lib.licenses.bsd2;
    maintainers = [lib.maintainers.raskin lib.maintainers.pshirshov lib.maintainers.kira-bruneau];
    platforms = lib.platforms.unix;
    homepage = "https://gist.github.com/Tblue/62ff47bef7f894e92ed5";
  };
}
