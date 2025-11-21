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
