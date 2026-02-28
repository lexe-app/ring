{
  localSystem ? builtins.currentSystem,
  # pinned nixpkgs source path
  sources ? import ./npins,
  nixpkgs ? sources.nixpkgs,
  pkgs ? import nixpkgs { inherit localSystem; },
}:
{
  # Generate the ring asm files
  ring-pregenerate-asm = pkgs.callPackage ./ring-pregenerate-asm.nix { };

  inherit pkgs nixpkgs sources;
}
