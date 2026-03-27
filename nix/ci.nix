{ sources ? import ../npins
, hpkgs ? import ./hpkgs.nix { inherit sources; }
}:
{
  native = hpkgs.prrrrrrrrr;
}
