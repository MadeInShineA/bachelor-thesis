{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
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
        pkgs = nixpkgs.legacyPackages.${system};

      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            quarto
            git-lfs
            codebook
          ];

          # Automatically handles the Quarto acronyms extension on shell startup
          shellHook = ''
            if [ ! -d "_extensions/rchaput/acronyms" ]; then
              echo "Installing rchaput/acronyms extension..."
              quarto add rchaput/acronyms --no-prompt
            else
              echo "Acronyms extension is already present."
            fi
          '';
        };
      }
    );
}
