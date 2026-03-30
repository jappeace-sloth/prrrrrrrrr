{ sources ? import ../npins }:
let
  pkgs = import sources.nixpkgs {
    config.allowUnfree = true;
    config.android_sdk.accept_license = true;
  };
  haskellMobileSrc = sources.haskell-mobile;
  hp = pkgs.haskellPackages;

  # Both packages built together so cabal can resolve the dependency
  # from prrrrrrrrr to haskell-mobile (IORef-based app registration).
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
  android = import ./android.nix { inherit sources; };
  apk = import ./apk.nix { inherit sources; };

  # Emulator test needs KVM and __noChroot, which is incompatible with
  # sandbox = true (GitHub Actions default).  Build separately:
  #   nix-build nix/emulator.nix
}
