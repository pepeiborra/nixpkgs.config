self: super:
with super.haskell.lib;
with super.lib;
let

    packageOverrides = hsself: hssuper: {
            # ghc = hssuper.ghc // { withPackages = hssuper.ghc.withHoogle; };
            # ghcWithPackages = hsself.ghc.withPackages;
    };
in
with super.haskell.packages;
{
  haskell = super.haskell // {
    packages = super.haskell.packages // {
        ghc881h = self.haskell.packages.ghc881 // { ghc = self.haskell.packages.ghc881.ghc // { withPackages = self.haskell.packages.ghc881.ghc.withHoogle; }; };
        ghc882h = self.haskell.packages.ghc882 // { ghc = self.haskell.packages.ghc882.ghc // { withPackages = self.haskell.packages.ghc882.ghc.withHoogle; }; };
        ghc883h = self.haskell.packages.ghc883 // { ghc = self.haskell.packages.ghc883.ghc // { withPackages = self.haskell.packages.ghc883.ghc.withHoogle; }; };
    };
    packageOverrides = composeExtensions super.haskell.packageOverrides packageOverrides;
  };
}
