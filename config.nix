  { allowBroken = true;
    max-jobs = 4;

    packageOverrides = pkgs: with pkgs;
    {
      myPackages = pkgs.buildEnv {
        name = "my-packages";
        paths = [
          coreutils
          jq
          emacs
          vim
          git
          silver-searcher
        ];
        # this will also install the documentation
        # but teaching man to manage it is a nightmare
        # https://nixos.org/nixpkgs/manual/#sec-getting-documentation
        pathsToLink = ["/share/man" "/share/doc" "/bin"];
      };
      # define a standard development environment
      myHaskellEnv = pkgs.haskellPackages.ghcWithHoogle
                      (haskellPackages: with haskellPackages; [
                        # libraries
                        aeson
                        arrows
                        async
                        cgi
                        criterion
                        fused-effects
                        lens
                        generic-lens
                        generics-sop
                        monad-control
                        mtl
                        polysemy
                        sop-core
                        text
                        time
                        transformers
                        unordered-containers

                        # tools
                        cabal-install
                        ghcid
                        ghcide
                        hie-bios
                        stylish-haskell
                        brittany
                        hlint
                        cabal2nix
                        ormolu
                      ]);

    };
  }
