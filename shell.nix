{ sources ? import ./npins
, pkgs ? import sources.nixpkgs {}
}:
let
  haskellMobileSrc = sources.haskell-mobile;
  hp = pkgs.haskellPackages.override {
    overrides = hnew: hold: {
      haskell-mobile = hnew.callCabal2nix "haskell-mobile" haskellMobileSrc {};
    };
  };
in
pkgs.mkShell {
  buildInputs = [
    (hp.ghcWithPackages (ps: [
      ps.text
      ps.containers
      ps.tasty
      ps.tasty-hunit
      ps.haskell-mobile
    ]))
    pkgs.cabal-install
  ];
}
