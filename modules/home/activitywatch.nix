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

  # nixpkgs restricts aw-server-rust's meta.platforms to Linux (it's simply
  # never been tested/built for Darwin upstream), but the derivation itself
  # is plain Rust + a prebuilt webui and builds fine on macOS. Widening the
  # platform list here is enough to unblock it; nothing else about the
  # derivation changes. Since Hydra never builds it for Darwin, this compiles
  # from source locally on every nixpkgs bump that touches it.
  aw-server-rust = pkgs.aw-server-rust.overrideAttrs (old: {
    meta = old.meta // {
      platforms = old.meta.platforms ++ lib.platforms.darwin;
    };
  });

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
          # aw-server (started separately, see the activitywatch-server agent
          # below) may not be up yet when a watcher first launches. Without a
          # throttle, a watcher that can't reach it crash-restarts as fast as
          # launchd allows and floods its log (~10s crash loop observed in
          # practice, ~25MB of log per day).
          ThrottleInterval = 30;
          StandardOutPath = "${config.home.homeDirectory}/Library/Logs/activitywatch-watcher-${wcfg.name}.log";
          StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/activitywatch-watcher-${wcfg.name}.log";
        };
      }
    ) cfg.watchers // {
      # aw-server-rust, built above, replaces the Python aw-server that used
      # to come from opening the Homebrew-installed ActivityWatch.app cask
      # (see modules/darwin/brew.nix) — same REST API and default port, but
      # a native arm64 binary instead of an Intel one running under Rosetta.
      # It auto-imports history from the legacy Python db
      # (~/Library/Application Support/activitywatch/aw-server/peewee-sqlite.v2.db)
      # on first run, so switching over doesn't lose existing data.
      activitywatch-server = {
        enable = true;
        config = {
          ProgramArguments = [
            (lib.getExe' aw-server-rust "aw-server")
            "--port"
            "5600"
          ];
          KeepAlive = true;
          RunAtLoad = true;
          ThrottleInterval = 30;
          StandardOutPath = "${config.home.homeDirectory}/Library/Logs/activitywatch-server.log";
          StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/activitywatch-server.log";
        };
      };

      # The cask app itself (see modules/darwin/brew.nix) still supplies
      # aw-watcher-afk and aw-watcher-window: both need pyobjc, which
      # nixpkgs marks unbuildable for Darwin, so they can't move to Nix.
      # aw-qt's autostart_modules below is trimmed to just those two so it
      # doesn't also launch its own aw-server and fight this one for :5600.
      activitywatch-app = {
        enable = true;
        config = {
          ProgramArguments = [
            "/usr/bin/open"
            "-jg" # launch hidden (-j), don't foreground (-g)
            "-a"
            "ActivityWatch"
          ];
          RunAtLoad = true;
          # `open` hands off to launchservices and exits immediately — it's
          # not the app's parent, so launchd can't track the app's lifetime
          # directly. KeepAlive here just means "keep re-running `open`",
          # which is idempotent (no-ops if the app's already up) and revives
          # it if it died. ThrottleInterval keeps that from becoming a tight
          # respawn loop.
          KeepAlive = true;
          ThrottleInterval = 30;
          LimitLoadToSessionType = "Aqua"; # only makes sense in a GUI login session
        };
      };
    };

    home.file =
      {
        # Keep aw-qt managing only the afk/window watchers — aw-server is
        # started by the activitywatch-server launchd agent above instead.
        "${configDir}/aw-qt/aw-qt.toml".source = settingsFormat.generate "aw-qt-settings" {
          aw-qt.autostart_modules = [
            "aw-watcher-afk"
            "aw-watcher-window"
          ];
          aw-qt-testing.autostart_modules = [
            "aw-watcher-afk"
            "aw-watcher-window"
          ];
        };
      }
      # Watchers with inline settings
      // lib.mapAttrs' (
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
