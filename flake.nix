# Usage:
#   nix profile add github:asciimoth/gotestprjtmpl
#   nix profile remove gotestprjtmpl
#   nix shell github:asciimoth/gotestprjtmpl
# Update: nix flake update
{
  description = "Go test project template";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    gomod2nix = {
      url = "github:tweag/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    pre-commit-hooks,
    gomod2nix,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ gomod2nix.overlays.default ];
      };

      app = pkgs.buildGoApplication {
        name = "gotestprjtmpl";
        version = builtins.readFile ./VERSION;
        src = ./.;
        modules = ./gomod2nix.toml;
        # buildInputs = with pkgs; [ ];
      };

      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            govet.enable = true;
            gomod2nix = {
              enable = true;
              description = "TODO";
              entry = let script = pkgs.writeShellScript "gomod2nix-hook" ''
                gomod2nix generate
                git add gomod2nix.toml
              ''; in builtins.toString script;
              stages = [ "pre-commit" ];
            };
          };
        };
      };
    in {
      devShell = pkgs.mkShell {
        inherit (checks.pre-commit-check) shellHook;
        buildInputs = with pkgs; [
          go
          commitizen
          goreleaser
          git-cliff

          gomod2nix.packages.${system}.default
        ];
      };

      defaultPackage = app;
    });
}
