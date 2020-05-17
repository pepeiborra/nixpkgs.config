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
    ghc-lib-parser_810 = hsself: dontCheck(hsself.callHackage "ghc-lib-parser" "8.10.1.20200412" {});

    sharedOverrides = hsself: hssuper: {
            floskell = dontCheck(hssuper.floskell);
            ghc-check = hsself.callHackage "ghc-check" "0.3.0.1" {};
            haskell-lsp = (hsself.callHackage "haskell-lsp" "0.22.0.0" {});
            haskell-lsp-types = hsself.callHackage "haskell-lsp-types" "0.22.0.0" {};
            hie-bios = doJailbreak(dontCheck(hsself.callHackage "hie-bios" "0.4.0" {}));
            lsp-test = doHaddock(disableLibraryProfiling(dontCheck (hsself.callHackage "lsp-test" "0.10.3.0" {})));
            monad-dijkstra = dontCheck(hsself.callHackage "monad-dijkstra" "0.1.1.2" {});
            opentelemetry = dontCheck(hsself.callHackage "opentelemetry" "0.3.1" {});
            retrie = dontCheck(hsself.callHackage "retrie" "0.1.1.0" {
              haskell-src-exts = dontCheck(hsself.callHackage "haskell-src-exts" "1.23.0" {});
            });
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
    ghc8101overrides = hsself: hssuper: {
            czipwith = dontCheck(doJailbreak hssuper.czipwith);
            data-tree-print = dontCheck(doJailbreak hssuper.data-tree-print);
            doctest  = dontCheck(doJailbreak(hsself.callHackage "doctest" "0.16.3" {}));
            lens     = dontCheck(doJailbreak(hsself.callHackage "lens" "4.19.1" {}));
            hackage-security = dontCheck(doJailbreak(hsself.callHackage "hackage-security" "0.6.0.0" {}));
            cabal-install = dontCheck(doJailbreak(hsself.callHackage "cabal-install" "3.2.0.0" {}));
            vault = doJailbreak(dontHaddock(hssuper.vault));
            ormolu = dontCheck(hsself.callHackage "ormolu" "0.0.5.0" {
               ghc-lib-parser = ghc-lib-parser_810 hsself;
            });
            ghc-exactprint = hsself.callHackage "ghc-exactprint" "0.6.3" {};
            hslogger = doJailbreak hssuper.hslogger;
            tasty-rerun = doJailbreak hssuper.tasty-rerun;
            safe-exceptions = doJailbreak hssuper.safe-exceptions;
            sop-core = dontCheck(hsself.callHackage "sop-core" "0.5.0.1" {});
            generics-sop = dontCheck(hsself.callHackage "generics-sop" "0.5.1.0" {});
            mkDerivation = args: hssuper.mkDerivation (args // {
                  doCheck = false;
                  doHaddock = true;
                  enableLibraryProfiling = false;
                  enableExecutableProfiling = false;
                });
    };
    ghcHEADoverrides = hsself: hssuper: ghc8101overrides hsself hssuper // {
            mkDerivation = args: hssuper.mkDerivation (args // {
                  doCheck = false;
                  doHaddock = false;
                  enableLibraryProfiling = false;
                  enableExecutableProfiling = false;
                  jailbreak = true;
                });
    };
in
with self.haskell.packages;
{
  myHaskell = self.haskell // {
    packages = self.haskell.packages // {
      ghc844 = properExtend (properExtend ghc844 sharedOverrides) ghc844overrides;
      ghc865 = properExtend (properExtend ghc865 sharedOverrides) ghc865overrides;
      ghc883 = properExtend (properExtend ghc883 sharedOverrides) ghc883overrides;
      ghc8101 = properExtend (properExtend ghc8101 sharedOverrides) ghc8101overrides;
      ghcHEAD = properExtend (properExtend ghcHEAD sharedOverrides) ghcHEADoverrides;
      };
    };
  }
