self: super:

with super.haskell.packages;

{
    haskell = super.haskell // {
    packages = super.haskell.packages // {
        ghc844 = ghc844.override { all-cabal-hashes = import ./data/hackage.nix; };
        ghc865 = ghc865.override { all-cabal-hashes = import ./data/hackage.nix; };
        ghc881 = ghc881.override { all-cabal-hashes = import ./data/hackage.nix; };
        ghc883 = ghc883.override { all-cabal-hashes = import ./data/hackage.nix; };
        ghc8101= ghc8101.override { all-cabal-hashes = import ./data/hackage.nix; };
        };
    };
}
