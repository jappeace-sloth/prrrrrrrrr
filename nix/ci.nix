{ sources ? import ../npins }:
let
  pkgs = import ./pkgs.nix { inherit sources; };
  haskellMobileSrc = sources.haskell-mobile;
  hp = pkgs.haskellPackages;
in {
  # Backpack cross-package instantiation requires both packages built
  # from source in the same cabal invocation. callCabal2nix cannot
  # handle this because it builds each package separately via Setup.hs.
  native = pkgs.stdenv.mkDerivation {
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

      # Prevent Hackage index fetch in the sandbox
      mkdir -p $HOME/.config/cabal
      cat > $HOME/.config/cabal/config <<'CABALEOF'
      CABALEOF

      # Add haskell-mobile source for Backpack instantiation
      cat > cabal.project.local <<EOF
      packages: ${haskellMobileSrc}/
      package haskell-mobile
        tests: False
      EOF

      cabal build all --enable-tests --offline
      cabal test unit --offline
    '';

    installPhase = ''
      mkdir -p $out
      touch $out/ci-passed
    '';
  };
}
