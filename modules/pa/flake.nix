{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        libs = with pkgs; [
          alsa-lib
        ];
        pa = pkgs.rustPlatform.buildRustPackage {
          name = "pa";
          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;
          cargoHash = "sha256-G18S6jwlUR4IHh+A9ANw60o404zSmpBlJkcHqhdoEMM";
          buildType = "release";

          nativeBuildInputs = with pkgs; [
            pkg-config
          ];

          buildInputs = with pkgs; [
            dbus
            alsa-lib
          ];

          installPhase = let
            rustTarget = pkgs.stdenv.hostPlatform.rust.rustcTarget;
          in ''
            runHook preInstall
            mkdir -p $out/bin $out/lib

            install -Dm755 ./target/${rustTarget}/release/pa_bin $out/bin/pa_bin
            install -Dm755 ./target/${rustTarget}/release/libpa.so $out/lib/libpa.so
            runHook postInstall
          '';
        };
      in {
        packages.default = pa;
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            cargo
            rust-analyzer
            pkg-config
            dbus
          ];

          buildInputs = libs;

          LD_LIBRARY_PATH = builtins.concatStringsSep ":" (map (x: "${x}/lib") libs);
        };
      }
    );
}
