#!/bin/bash
# Optimize images in static/images/ — convert to WebP, resize max 1200px, remove originals
# Usage: ./scripts/optimize-images.sh [directory]
# Dependencies: magick (ImageMagick)

set -euo pipefail

IMG_DIR="${1:-static/images}"
MAX_WIDTH=1200
QUALITY=85
TOTAL_SAVED=0
COUNT=0

if [ ! -d "$IMG_DIR" ]; then
  echo "Directory not found: $IMG_DIR"
  exit 1
fi

if ! command -v magick &>/dev/null; then
  echo "Missing dependency: magick (ImageMagick)"
  exit 1
fi

echo "Optimizing images in $IMG_DIR (max ${MAX_WIDTH}px, WebP quality ${QUALITY})"
echo "---"

while IFS= read -r -d '' file; do
  filename=$(basename "$file")
  name="${filename%.*}"
  outfile="$IMG_DIR/${name}.webp"

  # Skip if webp version already exists
  if [ -f "$outfile" ]; then
    echo "SKIP $filename (webp exists)"
    continue
  fi

  original_size=$(stat -f%z "$file")

  # Resize if wider than MAX_WIDTH, convert to WebP
  magick "$file" -resize "${MAX_WIDTH}x>" -quality "$QUALITY" -strip "$outfile"

  new_size=$(stat -f%z "$outfile")
  saved=$((original_size - new_size))
  TOTAL_SAVED=$((TOTAL_SAVED + saved))
  COUNT=$((COUNT + 1))

  echo "$filename → ${name}.webp  $(( original_size / 1024 ))K → $(( new_size / 1024 ))K  (saved $(( saved / 1024 ))K)"

  # Update markdown references in content/
  ext="${filename##*.}"
  grep -rl --include="*.md" "$filename" content/ 2>/dev/null | while read -r mdfile; do
    sed -i '' "s/${name}\.${ext}/${name}.webp/g" "$mdfile"
    echo "  Updated reference in $(basename "$mdfile")"
  done

  # Remove original
  rm "$file"
done < <(find "$IMG_DIR" -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -print0)

echo "---"
echo "Done: $COUNT files optimized, total saved $(( TOTAL_SAVED / 1024 ))K"
