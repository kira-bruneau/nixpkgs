{ lib, fetchFromGitHub, rustPlatform, runCommand } :

rustPlatform.buildRustPackage rec {
  pname = "pax-rs";
  version = "0.4.0";

  meta = with lib; {
    description = "The fastest JavaScript bundler in the galaxy";
    longDescription = ''
      The fastest JavaScript bundler in the galaxy. Fully supports ECMAScript module syntax (import/export) in addition to CommonJS require(<string>).
    '';
    homepage = "https://github.com/nathan/pax";
    license = licenses.mit;
    maintainers = [ maintainers.klntsky ];
    platforms = platforms.linux;
    mainProgram = "px";
  };

  src =
    let
      source = fetchFromGitHub {
        owner = "nathan";
        repo = "pax";
        rev = "pax-v${version}";
        hash = "sha256-YsNmid37iEvAub7vpHrDpJm7GuEeAjoiYG4BXfW7XdA=";
      };

      cargo-lock = fetchFromGitHub {
        owner = "klntsky";
        gist = "c7863424d7df0c379782015f6bb3b399";
        rev = "1cf7481e33984fd1510dc77ed677606d08fa8eb6";
        hash = "sha256-oSDTAstGBKfeMSqiSA0fcm07BifpQj1ugKbxK86N+uY=";
      };
    in
    runCommand "pax-rs-src" {} ''
      cp -R ${source} $out
      chmod +w $out
      cp ${cargo-lock}/Cargo.lock $out
    '';

  cargoHash = "sha256-2gXd1rwj82Ywin4QW3g9cB9R0PkXhE73F9xSJ6EozzQ=";
}
