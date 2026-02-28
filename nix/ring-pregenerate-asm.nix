{
  lib,
  rustPlatform,
  perl,
  nasm,
}:
let
  inherit (lib) fileset;

  cargoToml = builtins.fromTOML (builtins.readFile ../Cargo.toml);
in
rustPlatform.buildRustPackage {
  pname = "ring-pregenerate-asm";
  version = cargoToml.package.version;

  # Explicitly include only required files for reproducibility
  src = fileset.toSource {
    root = ../.;
    fileset = fileset.unions [
      ../Cargo.lock
      ../Cargo.toml
      ../bench
      ../build.rs
      ../cavp/Cargo.toml
      ../cavp/tests/shavs.rs
      ../crypto
      ../include
      ../src
      ../third_party
    ];
  };

  cargoHash = "sha256-x01r9j9zji/Zp+kFqgkzM+nc/gMPmDKKTZ0UyymogUU=";

  RING_PREGENERATE_ASM = true;

  cargoBuildFlags = "-p ring";

  nativeBuildInputs = [
    perl
    nasm
  ];

  # Copy ./pregenerated asm files to $out
  installPhase = ''
    runHook preInstall
    mkdir $out
    cp -R ./pregenerated/* $out
    runHook postInstall
  '';

  doCheck = false;
}
