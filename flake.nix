{
  description = "Zen-C compiler";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        zen-c = pkgs.stdenv.mkDerivation {
          pname = "zen-c";
          version = "unstable";

          src = self;

          env.PREFIX = placeholder "out";

          meta = with pkgs; {
            description = "Zen-C programming language compiler";
            homepage = "https://github.com/z-libs/Zen-C";
            license = lib.licenses.mit;
            platforms = lib.platforms.unix;
            mainProgram = "zc";
          };
        };
      in
      {
        packages.default = zen-c;

        devShells.default = pkgs.mkShell {
          packages = [ zen-c ];
        };
      }
    );
}
