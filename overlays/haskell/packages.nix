self: super:
with self.haskell.lib;
with self.lib;
let

    haskell-lsp_local = disableLibraryProfiling(hsself.callCabal2nix "haskell-lsp" /home/pepe/scratch/haskell-lsp {});
    haskell-lsp-types_local = disableLibraryProfiling(hsself.callCabal2nix "haskell-lsp-types" /home/pepe/scratch/haskell-lsp/haskell-lsp-types {});
    hie-bios_local = hsself: dontCheck(hsself.callCabal2nix "hie-bios" /home/pepe/scratch/hie-bios {});
    lsp-test_local = disableLibraryProfiling(dontCheck (hsself.callCabal2nix "lsp-test" /home/pepe/scratch/lsp-test {}));
    ghcide_head = hsself: disableLibraryProfiling(disableExecutableProfiling(
      hsself.callCabal2nixWithOptions "ghcide" (
              self.fetchFromGitHub
                {owner="digital-asset";
                repo="ghcide";
                rev="5937a82728bc6a89cc529314c911d912941b950d";
                sha256="1rpbzpaikj11sy7zgs5rqqmsx80wrsminfc38xpmmg5l8mzzamhc";
                }) "--no-check --no-haddock" {}));

    sharedOverrides = hsself: hssuper: {
            ghc-check = hsself.callCabal2nix "ghc-check" /home/pepe/code/ghc-check {};
            # ghcide = ghcide_head hsself;
            haskell-lsp = disableLibraryProfiling(hsself.callHackage "haskell-lsp" "0.21.0.0" {});
            haskell-lsp-types = hsself.callHackage "haskell-lsp-types" "0.21.0.0" {};
            hie-bios = dontCheck(hsself.callHackage "hie-bios" "0.4.0" {});
            lsp-test = doHaddock(disableLibraryProfiling(dontCheck (hsself.callHackage "lsp-test" "0.10.2.0" {})));
            time-compat = dontCheck hssuper.time-compat;
            yaml = hsself.callHackage "yaml" "0.11.3.0" {};
    };
    ghc844overrides = hsself: hssuper: {
            Diff = dontCheck(hsself.callHackage "Diff" "0.3.4" {});
            regex-base = doJailbreak(dontCheck (hsself.callHackage "regex-base" "0.94.0.0" {}));
            regex-posix = doJailbreak(dontCheck (hsself.callHackage "regex-posix" "0.96.0.0" {}));
          };
    ghc865overrides = hsself: hssuper: {};
    ghc883overrides = hsself: hssuper: {};
    ghc8101overrides = hsself: hssuper: {};
in
with self.haskell.packages;
{
  myHaskell = self.haskell // {
    packages = self.haskell.packages // {
      ghc844 = properExtend (properExtend ghc844 sharedOverrides) ghc844overrides;
      ghc865 = properExtend (properExtend ghc865 sharedOverrides) ghc865overrides;
      ghc883 = properExtend (properExtend ghc883 sharedOverrides) ghc883overrides;
      ghc8101 = properExtend (properExtend ghc8101 sharedOverrides) ghc8101overrides;
      };
    };
  }
