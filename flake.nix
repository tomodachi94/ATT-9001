{
  # Based on https://github.com/bobvanderlinden/templates/blob/master/ruby/flake.nix
  # Useage: see README.md

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
        gems = pkgs.bundlerEnv {
          name = "att-9001-bundlerEnv";
          gemdir = ./.;
        };
      in
      {
        packages.default = pkgs.buildRubyGem {
          name = "att9001";
          gemName = "att9001";
          src = ./.;
		  propagatedBuildInputs = [ gems ];
		  ruby = gems.ruby;
        };
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            gems
            gems.wrappedRuby
            bundix
            nixfmt-rfc-style
          ];
        };
      }
    );
}
