{ sources ? import ../npins
, pkgs ? import ./pkgs.nix { inherit sources; }
}:
pkgs.haskellPackages.override {
  overrides = hnew: hold: {
    haskell-mobile = hnew.callCabal2nix "haskell-mobile" sources.haskell-mobile {};
    prrrrrrrrr = hnew.callCabal2nix "prrrrrrrrr" ../. {};
  };
}
