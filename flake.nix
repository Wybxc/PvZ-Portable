{
  description = "Development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        packages = with pkgs; [
          cmake
          ninja
          glew
          libogg
          libjpeg
          libopenmpt
          libpng
          libvorbis
          SDL2
          mpg123
        ] ++ lib.optionals stdenv.isDarwin [
          darwin.apple_sdk.frameworks.OpenGL
        ];

      in {
        devShells.default = pkgs.mkShell {
          buildInputs = packages;
        };
        packages.default = pkgs.buildEnv {
          name = "dev-deps";
          paths = packages;
        };
      }
    );
}