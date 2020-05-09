self: super:

with super.haskell.packages;

{
    haskell = super.haskell // {
    compiler = super.haskell.compiler // {
      ghcHEAD = super.callPackage ./compiler/head.nix {
        bootPkgs = ghc883;
        inherit (super.buildPackages.python3Packages) sphinx;
        buildLlvmPackages = super.buildPackages.llvmPackages_6;
        llvmPackages = super.pkgs.llvmPackages_6;
        };
      };
    packages = super.haskell.packages // {
        ghc844 = ghc844.override { all-cabal-hashes = import ./data/hackage.nix; };
        ghc865 = ghc865.override { all-cabal-hashes = import ./data/hackage.nix; };
        ghc881 = ghc881.override { all-cabal-hashes = import ./data/hackage.nix; };
        ghc883 = ghc883.override { all-cabal-hashes = import ./data/hackage.nix; };
        ghc8101= ghc8101.override { all-cabal-hashes = import ./data/hackage.nix; };
        ghcHEAD= ghcHEAD.override { all-cabal-hashes = import ./data/hackage.nix; };
        };
    };
}
