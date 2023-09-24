# sync-format.nvim

Synchronous formatter runner for Neovim using in-place formatters. No stdin support.

## Installation

Without any package manager:

```sh
git clone https://github.com/mgnsk/sync-format.nvim.git $HOME/.local/share/nvim/site/pack/pkg/start/sync-format.nvim
```

If you're using a package manager, look for its documentation on how to install `"mgnsk/sync-format.nvim"`.

## Configuration

By default there are no tools configured.

An example config:

```lua
require("formatter").setup({
    typescript = { "prettier", "-w" },
    lua = { "stylua", "--indent-type", "Spaces", "--indent-width", "4" },
    fish = { "fish", "-c", [['fish_indent -w $argv[1]']] },
    c = { "clang-format", "-i" },
    proto = { "buf", "format", "-w" },
    lua = { "stylua" },
    go = { "goimports", "-w" },
    rust = { "rustfmt" },
    sh = { "shfmt", "-w" },
    php = { "pint" },
    sql = { "pg_format", "-i", "--type-case", "0" },
})
```

## Commands

The plugin provides a few commands:

- `AutoformatToggle` - Toggle autoformat globally
- `AutoformatEnable` - Enable autoformat globally
- `AutoformatDisable` - Disable autoformat globally
- `AutoformatToggleBuffer` - Toggle autoformat for buffer
- `AutoformatEnableBuffer` - Enable autoformat for buffer
- `AutoformatDisableBuffer` - Disable autoformat for buffer
- `WriteFormatAll` - Write and format all loaded file buffers
