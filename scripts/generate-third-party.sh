#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
OUTPUT="$ROOT_DIR/THIRD-PARTY"

cd "$ROOT_DIR"

echo "Generating Rust third-party notices..."
cargo about generate about.hbs > "$OUTPUT"

echo "Written to $OUTPUT"
