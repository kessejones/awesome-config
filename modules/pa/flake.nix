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
      in {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            cargo
            rust-analyzer
            pkg-config

            lua5_1
            dbus

            # pkgs.raylib
            # pkgs.xorg.libXcursor
            # pkgs.xorg.libXext
            # pkgs.xorg.libXfixes
            # pkgs.xorg.libXi
            # pkgs.xorg.libXinerama
            # pkgs.xorg.libXrandr
          ];

          buildInputs = libs;

          LD_LIBRARY_PATH = builtins.concatStringsSep ":" (map (x: "${x}/lib") libs);
        };
      }
    );
}
