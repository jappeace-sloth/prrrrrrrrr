{ sources ? import ./npins
, pkgs ? import sources.nixpkgs {}
}:
let
  haskellMobileSrc = sources.haskell-mobile;
  hp = pkgs.haskellPackages;
in
pkgs.mkShell {
  buildInputs = [
    (hp.ghcWithPackages (ps: [
      ps.text
      ps.containers
      ps.tasty
      ps.tasty-hunit
    ]))
    pkgs.cabal-install
  ];

  # Inject haskell-mobile source via cabal.project.local so cabal can
  # do Backpack instantiation from source (required for cross-package
  # signature filling).
  shellHook = ''
    cat > cabal.project.local <<EOF
    packages: ${haskellMobileSrc}/
    package haskell-mobile
      tests: False
    EOF
  '';
}
