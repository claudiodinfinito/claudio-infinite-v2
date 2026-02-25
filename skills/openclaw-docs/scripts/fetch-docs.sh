#!/bin/bash
# Fetch OpenClaw documentation and create llm-full.txt
# Usage: ./fetch-docs.sh [output-dir]

set -e

BASE_URL="https://docs.openclaw.ai"
OUTPUT_DIR="${1:-$(dirname "$0")/../references}"
LLMS_TXT="$OUTPUT_DIR/llms.txt"
LLM_FULL="$OUTPUT_DIR/llm-full.txt"

echo "=== Fetching OpenClaw Documentation ==="
echo "Output: $OUTPUT_DIR"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Fetch llms.txt index
echo "Fetching llms.txt index..."
curl -s "$BASE_URL/llms.txt" -o "$LLMS_TXT"
echo "✓ Saved: llms.txt ($(wc -l < "$LLMS_TXT") lines)"

# Extract URLs from llms.txt
URLS=$(grep -oE 'https://docs\.openclaw\.ai/[^)]+' "$LLMS_TXT" | sort -u)
TOTAL=$(echo "$URLS" | wc -l)

echo "Found $TOTAL pages to fetch"

# Create llm-full.txt header
cat > "$LLM_FULL" << 'HEADER'
# OpenClaw Documentation - LLM-Optimized Full Text

> This file contains the complete OpenClaw documentation for LLM consumption.
> Generated: $(date -u +"%Y-%m-%d %H:%M:%S UTC")
> Source: https://docs.openclaw.ai/

---

HEADER

# Fetch each page
COUNT=0
for URL in $URLS; do
    COUNT=$((COUNT + 1))
    # Remove base URL to get path
    PATH_NAME=$(echo "$URL" | sed "s|$BASE_URL||" | sed 's|^/||' | sed 's|\.md$||')
    
    echo "[$COUNT/$TOTAL] Fetching: $PATH_NAME"
    
    # Append separator and content
    echo -e "\n\n---\n\n# $PATH_NAME\n\n" >> "$LLM_FULL"
    
    # Fetch page content
    curl -s "$URL" >> "$LLM_FULL" 2>/dev/null || echo "⚠ Failed: $URL"
    
    # Small delay to be respectful
    sleep 0.1
done

echo ""
echo "=== Complete ==="
echo "✓ llm-full.txt: $(wc -l < "$LLM_FULL") lines"
echo "✓ Total size: $(du -h "$LLM_FULL" | cut -f1)"
