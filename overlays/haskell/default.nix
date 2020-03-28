self: super:

with super.lib;

let composeOverlays = foldl' composeExtensions (self: super: {});
in
   composeOverlays
       [(import ./lib.nix)
        (import ./hackage.nix)
        (import ./hoogle.nix)
        (import ./packages.nix)
       ] self super
