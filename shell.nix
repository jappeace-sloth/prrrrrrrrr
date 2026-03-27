{ hpkgs ? import ./nix/hpkgs.nix {}
, pkgs ? import ./nix/pkgs.nix {}
}:
hpkgs.shellFor {
  packages = ps: [ ps.prrrrrrrrr ps.haskell-mobile ];
  withHoogle = false;

  buildInputs = [
    pkgs.cabal-install
  ];
}
