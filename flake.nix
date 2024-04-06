{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";

    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flutter-nix = {
      url = "github:maximoffua/flutter.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-trusted-public-keys =
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, systems, ... }@inputs:
    let forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in {
      packages = forEachSystem (system: {
        devenv-up = self.devShells.${system}.default.config.procfileScript;
      });

      devShells = forEachSystem (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = let
            inherit (inputs) flutter-nix android-nixpkgs;
            flutter-sdk = flutter-nix.packages.${system};
            sdk = (import android-nixpkgs { }).sdk (sdkPkgs:
              with sdkPkgs; [
                build-tools-30-0-3
                build-tools-34-0-0
                cmdline-tools-latest
                emulator
                platform-tools
                platforms-android-34
                platforms-android-33
                platforms-android-31
                platforms-android-28
                system-images-android-34-google-apis-playstore-x86-64
              ]);
          in devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [
              ({ pkgs, config, ... }: {
                # https://devenv.sh/basics/
                # dotenv.enable = true;
                env.ANDROID_AVD_HOME = "${config.env.DEVENV_ROOT}/.android/avd";
                env.ANDROID_SDK_ROOT = "${sdk}/share/android-sdk";
                env.ANDROID_HOME = config.env.ANDROID_SDK_ROOT;
                env.CHROME_EXECUTABLE = "chromium";
                env.FLUTTER_SDK = "${pkgs.flutter}";
                env.GRADLE_OPTS =
                  "-Dorg.gradle.project.android.aapt2FromMavenOverride=${sdk}/share/android-sdk/build-tools/34.0.0/aapt2";

                # https://devenv.sh/packages/
                packages = [ flutter-sdk.flutter ];

                # https://devenv.sh/scripts/
                # Create the initial AVD that's needed by the emulator
                scripts.create-avd.exec =
                  "avdmanager create avd --force --name phone --package 'system-images;android-34;google_apis_playstore;x86_64'";

                # https://devenv.sh/processes/
                # These processes will all run whenever we run `devenv run`
                processes.emulator.exec = "nixGLMesa emulator -avd phone -skin 720x1280";
                processes.generate.exec = "dart run build_runner watch || true";
                # processes.grovero-app.exec = "flutter run lib/main.dart";

                enterShell = ''
                  mkdir -p $ANDROID_AVD_HOME
                  export PATH="${sdk}/bin:$PATH"
                  export FLUTTER_GRADLE_PLUGIN_BUILDDIR="''${XDG_CACHE_HOME:-$HOME/.cache}/flutter/gradle-plugin";
                '';

                # https://devenv.sh/languages/
                languages.dart = {
                  enable = true;
                  package = flutter-sdk.dart;
                };
                languages.java = {
                  enable = true;
                  gradle.enable = false;
                  jdk.package = pkgs.jdk17;
                };

                # See full reference at https://devenv.sh/reference/options/
              })
            ];
          };
        });
    };
}
