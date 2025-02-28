{
  nixConfig.allow-import-from-derivation = false;

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = { self, nixpkgs, treefmt-nix }:
    let

      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ ];
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

      posix-browser = import ./src {
        pkgs = pkgs;
      };

      submitTests = import ./submit_test {
        pkgs = pkgs;
        posix-browser = posix-browser;
      };

      submitTest = pkgs.linkFarm "submitTest" submitTests;

      gotoTests = import ./goto_test {
        pkgs = pkgs;
        posix-browser = posix-browser;
      };

      gotoTest = pkgs.linkFarm "gotoTest" gotoTests;

      packages = submitTests // gotoTests // {
        formatting = treefmtEval.config.build.check self;
        posix-browser = posix-browser;
        submitTest = submitTest;
        gotoTest = gotoTest;
      };

      gcroot = packages // {
        gcroot-all = pkgs.linkFarm "gcroot-all" packages;
      };

    in

    {

      packages.x86_64-linux = gcroot;

      checks.x86_64-linux = gcroot;

      formatter.x86_64-linux = treefmtEval.config.build.wrapper;

    };
}
