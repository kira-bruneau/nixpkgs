{ stdenvNoCC, fetchFromGitHub, lib
, yad, mkvtoolnix-cli, libnotify }:

stdenvNoCC.mkDerivation {
  pname = "mpv-convert-script";
  version = "2016-03-18";
  src = fetchFromGitHub {
    owner = "Zehkul";
    gist = "25ea7ae77b30af959be0";
    rev = "f95cee43e390e843a47e8ec9d1711a12a8cd343d";
    hash = "sha256-k9XxURI7gUdzKxiJbWlMitRoN957rOy02BJl4TWhp44=";
  };

  patches = [ ./convert.patch ];

  postPatch = ''
    substituteInPlace convert_script.lua \
      --replace 'mkvpropedit_exe = "mkvpropedit"' \
                'mkvpropedit_exe = "${mkvtoolnix-cli}/bin/mkvpropedit"' \
      --replace 'mkvmerge_exe = "mkvmerge"' \
                'mkvmerge_exe = "${mkvtoolnix-cli}/bin/mkvmerge"' \
      --replace 'yad_exe = "yad"' \
                'yad_exe = "${yad}/bin/yad"' \
      --replace 'notify_send_exe = "notify-send"' \
                'notify_send_exe = "${libnotify}/bin/notify-send"' \

  '';

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/mpv/scripts
    cp convert_script.lua $out/share/mpv/scripts
  '';
  passthru.scriptName = "convert_script.lua";

  meta = with lib; {
    description = "Convert parts of a video while you are watching it in mpv";
    homepage = "https://gist.github.com/Zehkul/25ea7ae77b30af959be0";
    maintainers = [ maintainers.Profpatsch ];
    longDescription = ''
      When this script is loaded into mpv, you can hit Alt+W to mark the beginning
      and Alt+W again to mark the end of the clip. Then a settings window opens.
    '';
    # author was asked to add a license https://gist.github.com/Zehkul/25ea7ae77b30af959be0#gistcomment-3715700
    license = licenses.unfree;
  };
}
