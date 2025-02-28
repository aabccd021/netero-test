{
  nixConfig.allow-import-from-derivation = false;

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = { self, nixpkgs, treefmt-nix }:
    let

      overlay = (final: prev: {
        netero-test = import ./src {
          pkgs = final;
        };
      });

      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ overlay ];
      };

      treefmtEval = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";
        programs.nixpkgs-fmt.enable = true;
        programs.prettier.enable = true;
        programs.shfmt.enable = true;
        programs.shellcheck.enable = true;
        programs.gofumpt.enable = true;
        settings.formatter.shellcheck.options = [ "-s" "sh" ];
        settings.global.excludes = [ "LICENSE" ];
      };

      netero-test = import ./src { pkgs = pkgs; };

      submitTests = import ./test/submit { pkgs = pkgs; };

      gotoTests = import ./test/goto { pkgs = pkgs; };

      submitTest = pkgs.linkFarm "submitTest" submitTests;

      gotoTest = pkgs.linkFarm "gotoTest" gotoTests;

      packages = submitTests // gotoTests // {
        formatting = treefmtEval.config.build.check self;
        submitTest = submitTest;
        gotoTest = gotoTest;
        netero-test = netero-test;
        default = netero-test;
      };

      gcroot = packages // {
        gcroot-all = pkgs.linkFarm "gcroot-all" packages;
      };

    in

    {

      packages.x86_64-linux = gcroot;

      checks.x86_64-linux = gcroot;

      formatter.x86_64-linux = treefmtEval.config.build.wrapper;

      overlays.default = overlay;

    };
}
