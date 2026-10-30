#!/bin/sh
# meta-dev-skills installer.
# Copies every skills/<slug>/ directory into a skills directory.
# Idempotent: an existing target skill directory is replaced.
# No sudo. No network. POSIX sh.
#
# Usage:
#   ./INSTALL.sh                        # -> ~/.hermes/skills
#   ./INSTALL.sh /path/to/skills_dir    # -> explicit target
#   HERMES_SKILLS_DIR=/x ./INSTALL.sh   # -> $HERMES_SKILLS_DIR

set -eu

TARGET="${1:-${HERMES_SKILLS_DIR:-$HOME/.hermes/skills}}"

# Directory this script lives in, so it works from any cwd.
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SRC="$SCRIPT_DIR/skills"

if [ ! -d "$SRC" ]; then
  echo "error: skills source not found at $SRC" >&2
  exit 1
fi

mkdir -p "$TARGET"
echo "meta-dev-skills -> $TARGET"

count=0
for skill_dir in "$SRC"/*/; do
  [ -d "$skill_dir" ] || continue
  slug=$(basename "$skill_dir")
  dest="$TARGET/$slug"
  if [ -d "$dest" ]; then
    rm -rf "$dest"
    echo "  replaced  $slug"
  else
    echo "  installed $slug"
  fi
  cp -R "$skill_dir" "$dest"
  count=$((count + 1))
done

echo "Done. $count skill(s) in $TARGET."
echo "Reload your agent session so the skills register."
