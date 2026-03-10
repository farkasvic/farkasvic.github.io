#!/usr/bin/env bash
# Converts Meddata_Presentation.pptx to PNG images for the projects carousel.
# Run from repo root: ./scripts/convert_meddata_to_images.sh

set -e
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PPTX="$REPO_ROOT/assets/Meddata_Presentation.pptx"
OUT_DIR="$REPO_ROOT/assets/meddata_slides"

mkdir -p "$OUT_DIR"

# Step 1: PPTX -> PDF (requires LibreOffice)
SOFFICE=""
for cmd in soffice libreoffice "/Applications/LibreOffice.app/Contents/MacOS/soffice"; do
  if command -v "$cmd" &>/dev/null || [ -x "$cmd" ]; then
    SOFFICE="$cmd"
    break
  fi
done

if [ -z "$SOFFICE" ]; then
  echo "LibreOffice not found. To convert automatically, install it:"
  echo "  brew install --cask libreoffice"
  echo ""
  echo "Or export manually from PowerPoint:"
  echo "  File > Save As > PNG Portable Network Graphics > All Slides"
  echo "  Save into: $OUT_DIR"
  echo "  Rename files to slide_1.png, slide_2.png, ... slide_19.png"
  exit 1
fi

echo "Converting PPTX to PDF..."
cd "$(dirname "$PPTX")"
"$SOFFICE" --headless --convert-to pdf --outdir "$OUT_DIR" "$(basename "$PPTX")"
PDF="$OUT_DIR/Meddata_Presentation.pdf"

# Step 2: PDF -> PNG (requires pdftoppm from poppler)
if ! command -v pdftoppm &>/dev/null; then
  echo "pdftoppm not found. Install poppler: brew install poppler"
  echo "Then manually convert $PDF to PNGs, or use an online PDF-to-image tool."
  exit 1
fi

echo "Converting PDF to PNGs..."
cd "$OUT_DIR"
pdftoppm -png -r 150 Meddata_Presentation.pdf slide

# Rename slide-1.png -> slide_1.png for consistency
for f in slide-*.png; do
  [ -f "$f" ] && mv "$f" "${f/-/_}"
done

# Remove PDF to keep repo lean (optional)
rm -f Meddata_Presentation.pdf

echo "Done! Slides saved to $OUT_DIR"
