{
  description = "Development environment for probitas-test/claude-plugins";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    probitas-flake.url = "github:probitas-test/probitas";
    probitas-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      probitas-flake,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          overlays = [ probitas-flake.overlays.default ];
        };
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.mkShell {
            packages = [
              # Formats the Markdown and JSON of the plugins.
              pkgs.deno
              # Lets the plugin's commands be tried against real scenarios.
              pkgs.probitas
              # Checks that the plugin manifests parse.
              pkgs.jq
              pkgs.just
              pkgs.nixfmt
            ];

            shellHook = ''
              export DENO_NO_UPDATE_CHECK=1
            '';
          };
        }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);
    };
}
