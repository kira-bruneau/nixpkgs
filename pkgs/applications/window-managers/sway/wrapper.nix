{ lib
, makeWrapper
, symlinkJoin
, writeShellScriptBin

# withBaseWrapper & dbusSupport
, dbus

# withGtkWrapper
, wrapGAppsHook
, gdk-pixbuf
, glib
, gtk3
}:

sway-unwrapped:

with lib;

let
  wrapper =
    { withBaseWrapper ? true
      , extraSessionCommands ? ""
      , dbusSupport ? false
    , withGtkWrapper ? false
    , extraOptions ? [] # E.g.: [ "--verbose" ]

    # sway-unwrapped overrides
    , isNixOS ? false
    , enableXWayland ? true
    }@args:

    assert args ? extraSessionCommands || args ? dbusSupport -> withBaseWrapper;

    let
      sway = sway-unwrapped.overrideAttrs (oa: { inherit isNixOS enableXWayland; });
      baseWrapper = writeShellScriptBin sway.meta.mainProgram ''
         set -o errexit
         if [ ! "$_SWAY_WRAPPER_ALREADY_EXECUTED" ]; then
           export XDG_CURRENT_DESKTOP=${sway.meta.mainProgram}
           ${extraSessionCommands}
           export _SWAY_WRAPPER_ALREADY_EXECUTED=1
         fi
         if [ "$DBUS_SESSION_BUS_ADDRESS" ]; then
           export DBUS_SESSION_BUS_ADDRESS
           exec ${lib.getExe sway} "$@"
         else
           exec ${lib.optionalString dbusSupport "${dbus}/bin/dbus-run-session"} ${lib.getExe sway} "$@"
         fi
     '';
    in
    symlinkJoin {
      name = "${sway.meta.mainProgram}-${sway.version}";

      paths = (optional withBaseWrapper baseWrapper)
        ++ [ sway ];

      strictDeps = false;
      nativeBuildInputs = [ makeWrapper ]
        ++ (optional withGtkWrapper wrapGAppsHook);

      buildInputs = optionals withGtkWrapper [ gdk-pixbuf glib gtk3 ];

      # We want to run wrapProgram manually
      dontWrapGApps = true;

      postBuild = ''
        ${optionalString withGtkWrapper "gappsWrapperArgsHook"}

        wrapProgram $out/bin/${sway.meta.mainProgram} \
          ${optionalString withGtkWrapper ''"''${gappsWrapperArgs[@]}"''} \
          ${optionalString (extraOptions != []) "${concatMapStrings (x: " --add-flags " + x) extraOptions}"}
      '';

      passthru = {
        inherit (sway.passthru) tests;
        providedSessions = [ sway.meta.mainProgram ];
      };

      inherit (sway) meta;
    };
in lib.makeOverridable wrapper
