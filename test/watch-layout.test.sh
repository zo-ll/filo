#!/usr/bin/env bash
# Check the live renderer with controlled terminal dimensions.
set -euo pipefail
. "$(dirname "$0")/lib.sh"
. "$ROOT/lib/watch.sh"

W_COLOR=0
W_FULL=1
W_PREV=()

tput() {
  case "$1" in
    cols) printf '%s\n' "$TEST_COLS" ;;
    lines) printf '%s\n' "$TEST_LINES" ;;
    *) return 1 ;;
  esac
}

watch_frame() {
  DRAW_WIDTH=$1
  DRAW_HEIGHT=$2
  FRAME=("width=$1 height=$2")
  KEYS="q quit"
}

TEST_COLS=160 TEST_LINES=40
draw > "$TMP/frame"
assert "$DRAW_WIDTH" 160
assert "$DRAW_HEIGHT" 40
assert "$W_SIZE" "160:40"
has "$(<"$TMP/frame")" "width=160 height=40"

# A resize changes both dimensions.
TEST_COLS=220 TEST_LINES=50
draw > "$TMP/frame"
assert "$DRAW_WIDTH" 220
assert "$DRAW_HEIGHT" 50
assert "$W_SIZE" "220:50"

# Keep the existing minimum width for narrow terminals.
TEST_COLS=30 TEST_LINES=24
draw > "$TMP/frame"
assert "$DRAW_WIDTH" 44
assert "$DRAW_HEIGHT" 24
assert "$W_SIZE" "44:24"

echo "  watch layout ok"
