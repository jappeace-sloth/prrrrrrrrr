{ sources ? import ../npins }:
let
  pkgs = import sources.nixpkgs {};
  haskellMobileSrc = sources.haskell-mobile;
  hp = pkgs.haskellPackages.override {
    overrides = hnew: hold: {
      haskell-mobile = hnew.callCabal2nix "haskell-mobile" haskellMobileSrc {};
    };
  };

  # Attempt: provide haskell-mobile as a pre-built nix package via
  # callCabal2nix, instead of injecting sources into the cabal project.
  combined = pkgs.stdenv.mkDerivation {
    name = "prrrrrrrrr-project";
    src = pkgs.lib.cleanSource ../.;
    nativeBuildInputs = [
      (hp.ghcWithPackages (ps: [
        ps.text
        ps.containers
        ps.tasty
        ps.tasty-hunit
        ps.haskell-mobile
      ]))
      pkgs.cabal-install
    ];

    buildPhase = ''
      export HOME=$TMPDIR

      mkdir -p $HOME/.config/cabal
      cat > $HOME/.config/cabal/config <<'CABALEOF'
      CABALEOF

      cabal build all --enable-tests --offline
      cabal test unit --offline
    '';

    installPhase = ''
      mkdir -p $out
      touch $out/ci-passed
    '';
  };
in {
  native = combined;
}
