# Log into figma MCP

## What is it for?

Figma MCP rejects non-whitelisted agents, including OpenCode.
This almost no-dependncy code allows to authenticate and create the mcp-auth.json file.

For context and alternatives, see https://github.com/anomalyco/opencode/issues/988

## Authenticating

```bash
npm i
npm run build
npm start https://mcp.figma.com/mcp
```

## Add to MCP

Then move or merge mcp-auth.json into ~/.local/share/opencode/mcp-auth.json

Or let the script do it. It replaces any existing `figma`/`Figma` entries, keeps every other key, and backs up the old file to `mcp-auth.json.bak`:

```bash
npm run merge-auth
```

Set `OPENCODE_AUTH_FILE` to use a different target file, either for a single run or in your shell environment:

```bash
OPENCODE_AUTH_FILE=/custom/path/mcp-auth.json npm run merge-auth   # one run
export OPENCODE_AUTH_FILE=/custom/path/mcp-auth.json               # current session (add to ~/.zshrc to persist)
```

## Other MCPs?

This was only tested with Figma.
