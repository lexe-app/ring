set shell := ["bash", "-euo", "pipefail", "-c"]

# select a recipe interactively
default:
    @just --choose

check-sgx *args:
    cargo check --target=x86_64-fortanix-unknown-sgx -p ring {{ args }}

test-sgx *args:
    cargo test --target=x86_64-fortanix-unknown-sgx --release \
      --workspace --exclude ring-cavp --exclude ring-bench \
      -- --test-threads 4 {{ args }}

test *args:
    cargo test -p ring --lib {{ args }}

dump-cpuid:
    cargo test -p ring --lib --features=std -- dump_cpuid --ignored --nocapture

ring-pregenerate-asm:
    #!/usr/bin/env bash
    set -euxo pipefail

    tmpdir="$(mktemp -d)"
    trap 'rm -rf "$tmpdir"' EXIT

    nix build -f nix/default.nix -L --out-link "$tmpdir/result" ring-pregenerate-asm

    cp -R --dereference "$tmpdir/result" "$tmpdir/pregenerated"
    chmod ug+w -R "$tmpdir/pregenerated"

    rm -rf pregenerated
    mv "$tmpdir/pregenerated" pregenerated
