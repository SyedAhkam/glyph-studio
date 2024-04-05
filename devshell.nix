{ pkgs }:

with pkgs;

# Configure your development environment.
#
# Documentation: https://github.com/numtide/devshell
devshell.mkShell {
  name = "glyph-studio";
  motd = ''
    Ready to hack ‍🔥
  '';
  env = [
    {
      name = "ANDROID_HOME";
      value = "${android-sdk}/share/android-sdk";
    }
    {
      name = "ANDROID_SDK_ROOT";
      value = "${android-sdk}/share/android-sdk";
    }
    {
      name = "JAVA_HOME";
      value = jdk19.home;
    }
    {
      name = "GRADLE_OPTS";
      value =
        "-Dorg.gradle.project.android.aapt2FromMavenOverride=${android-sdk}/share/android-sdk/build-tools/30.0.3/aapt2";
    }
  ];
  commands = [
    {
      name = "create-avd";
      command =
        "avdmanager create avd --force --name phone --abi google_apis/x86_64 --package 'system-images;android-33;google_apis;x86_64'";
    }
    {
      name = "launch-emulator";
      command = "nixGLMesa emulator -avd phone";
    }
  ];
  packages = [ android-sdk gradle jdk19 flutter ];
}
