#!/bin/bash
# Compile all .typ files in current directory to PDF
# Usage: ./compile_all.sh [directory]

set -euo pipefail

DIR="${1:-.}"

echo "Compiling all .typ files in $DIR..."

for f in "$DIR"/*.typ; do
    if [[ -f "$f" ]]; then
        echo "Compiling: $f"
        typst compile "$f"
    fi
done

echo "Done!"
