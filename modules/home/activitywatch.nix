{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.activitywatchDarwin;

  settingsFormat = pkgs.formats.toml { };

  configDir = "Library/Application Support/activitywatch";

  watcherType =
    {
      name,
      config,
      ...
    }:
    {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          default = name;
          example = "aw-watcher-web";
          description = ''
            The name of the watcher. Used as the directory name for
            the config file under `~/Library/Application Support/activitywatch/`.
          '';
        };

        package = lib.mkOption {
          type = lib.types.package;
          description = ''
            The derivation containing the watcher executable.
          '';
        };

        executable = lib.mkOption {
          type = lib.types.str;
          default = config.name;
          description = ''
            The name of the executable. Defaults to the watcher name.
          '';
        };

        settings = lib.mkOption {
          type = settingsFormat.type;
          default = { };
          example = {
            timeout = 300;
            poll_time = 2;
          };
          description = ''
            Settings for the watcher in TOML format. Generates a config file at
            `~/Library/Application Support/activitywatch/$NAME/$FILENAME`.
          '';
        };

        settingsFilename = lib.mkOption {
          type = lib.types.str;
          default = "${config.name}.toml";
          description = ''
            Basename of the generated settings file.
          '';
        };

        configFile = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Path string to a config file (e.g. an agenix-decrypted secret).
            Takes precedence over settings. Symlinked into the watcher's config dir
            via home.activation.
          '';
        };

        extraOptions = lib.mkOption {
          type = with lib.types; listOf str;
          default = [ ];
          example = [
            "--port"
            "5666"
          ];
          description = ''
            Extra arguments passed to the watcher executable.
          '';
        };
      };
    };

in
{
  options.services.activitywatchDarwin = {
    enable = lib.mkEnableOption "ActivityWatch extra watchers (macOS)";

    watchers = lib.mkOption {
      type = with lib.types; attrsOf (submodule watcherType);
      default = { };
      description = ''
        Extra watchers to run as launchd agents alongside the
        Homebrew-installed ActivityWatch server.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    launchd.agents = lib.mapAttrs' (
      _: wcfg:
      lib.nameValuePair "activitywatch-watcher-${wcfg.name}" {
        enable = true;
        config = {
          ProgramArguments =
            [ (lib.getExe' wcfg.package wcfg.executable) ]
            ++ wcfg.extraOptions;
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "${config.home.homeDirectory}/Library/Logs/activitywatch-watcher-${wcfg.name}.log";
          StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/activitywatch-watcher-${wcfg.name}.log";
        };
      }
    ) cfg.watchers;

    home.file =
      # Watchers with inline settings
      lib.mapAttrs' (
        _: wcfg:
        lib.nameValuePair "${configDir}/${wcfg.name}/${wcfg.settingsFilename}" {
          source = settingsFormat.generate "activitywatch-watcher-${wcfg.name}-settings" wcfg.settings;
        }
      ) (lib.filterAttrs (_: wcfg: wcfg.configFile == null && wcfg.settings != { }) cfg.watchers);

    # Watchers with configFile (e.g. agenix secrets) — symlinked at activation
    # time since the path is only available after decryption.
    home.activation.activitywatchSetup = let
      commands = lib.mapAttrsToList (_: wcfg:
        let
          dir = "${config.home.homeDirectory}/${configDir}/${wcfg.name}";
          dest = "${dir}/${wcfg.settingsFilename}";
        in
        ''
          mkdir -p "${dir}"
          ln -sf "${wcfg.configFile}" "${dest}"
        ''
      ) (lib.filterAttrs (_: wcfg: wcfg.configFile != null) cfg.watchers);
    in
      lib.hm.dag.entryAfter [ "writeBoundary" "agenix" ]
        (lib.concatStrings commands);
  };
}
