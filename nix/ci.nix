{ sources ? import ../npins }:
let
  pkgs = import sources.nixpkgs {};
  haskellMobileSrc = sources.haskell-mobile;
  hp = pkgs.haskellPackages;

  # Backpack instantiation requires both packages in the same cabal project.
  # We cannot use callCabal2nix for each separately because the indefinite
  # haskell-mobile library must be instantiated in the same build as prrrrrrrrr.
  combined = pkgs.stdenv.mkDerivation {
    name = "prrrrrrrrr-project";
    src = ../.;
    nativeBuildInputs = [
      (hp.ghcWithPackages (ps: [
        ps.text
        ps.containers
        ps.tasty
        ps.tasty-hunit
      ]))
      pkgs.cabal-install
    ];

    buildPhase = ''
      export HOME=$TMPDIR

      # Pre-create cabal config to prevent Hackage index fetch attempt.
      # In the nix sandbox there is no network.
      mkdir -p $HOME/.config/cabal
      cat > $HOME/.config/cabal/config <<'CABALEOF'
      CABALEOF

      # Symlink haskell-mobile source for cabal.project
      rm -rf haskell-mobile-src
      ln -s ${haskellMobileSrc} haskell-mobile-src

      # GHC already has all deps via ghcWithPackages.
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
