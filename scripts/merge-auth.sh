#!/usr/bin/env sh
# Merge ./mcp-auth.json into OpenCode's mcp-auth.json.
# Any existing top-level key starting with "figma" or "Figma" is replaced;
# otherwise the new entries are appended. Other keys are left untouched.
set -eu

SOURCE="${1:-mcp-auth.json}"
TARGET="${OPENCODE_AUTH_FILE:-$HOME/.local/share/opencode/mcp-auth.json}"

if [ ! -f "$SOURCE" ]; then
  echo "[merge-auth] Source file not found: $SOURCE (run 'npm start <mcp-server-url>' first)" >&2
  exit 1
fi

mkdir -p "$(dirname "$TARGET")"

if [ -f "$TARGET" ]; then
  cp "$TARGET" "$TARGET.bak"
  echo "[merge-auth] Backed up existing file to $TARGET.bak"
fi

node - "$SOURCE" "$TARGET" <<'JS'
const fs = require("node:fs");
const [source, target] = process.argv.slice(2);

const incoming = JSON.parse(fs.readFileSync(source, "utf-8"));
const existing = fs.existsSync(target) ? JSON.parse(fs.readFileSync(target, "utf-8") || "{}") : {};

const replaced = Object.keys(existing).filter((key) => /^[Ff]igma/.test(key));
for (const key of replaced) delete existing[key];

const merged = { ...existing, ...incoming };
fs.writeFileSync(target, `${JSON.stringify(merged, null, 2)}\n`, "utf-8");

if (replaced.length > 0) {
  console.log(`[merge-auth] Replaced keys: ${replaced.join(", ")}`);
} else {
  console.log("[merge-auth] No existing Figma keys found; appended new entries.");
}
console.log(`[merge-auth] Wrote ${Object.keys(incoming).join(", ")} to ${target}`);
JS
