{
  description = "Developer env for ruby";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = { self, nixpkgs }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      forAllSupportedSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forAllSupportedSystems ({ pkgs }: {
        default = pkgs.mkShell {
          buildInputs = [
            pkgs.libyaml
            pkgs.libffi
            pkgs.autoconf
            pkgs.automake
            pkgs.gcc
            pkgs.pkg-config
            pkgs.libiconv
            (pkgs.ruby.withPackages (ps: with ps; [ ps.nokogiri ps.rails ps.ruby-lsp ]))
            pkgs.neovim
          ];

          shellHook = ''
            export GEMRC=$PWD/.gemrc
            export BUNDLE_USER_CONFIG=$PWD/.bundle/config
            export BUNDLE_PATH=$PWD/.bundle

            bundle config set force_ruby_platform true
            bundle config set --local without 'development test'
            bundle config set --local with 'production'
            bundle update error_highlight
            bundle install
          '';
        };
      });
    };
}
