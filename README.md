# sync-format.nvim

Synchronous formatter runner for Neovim using in-place formatters. No stdin support.

## Features

- In-place formatting only, no stdin support.
- Simple configuration.
- Preserves scroll positions when editing the same buffer in multiple windows at different positions.

## Installation

Example using lazy.nvim:

```lua
{
    "mgnsk/sync-format.nvim",
    event = "BufEnter",
    config = function()
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
    end,
}
```

## Commands

The plugin provides a few commands:

- `AutoformatToggle` - Toggle autoformat globally
- `AutoformatEnable` - Enable autoformat globally
- `AutoformatDisable` - Disable autoformat globally
- `AutoformatToggleBuffer` - Toggle autoformat for buffer
- `AutoformatEnableBuffer` - Enable autoformat for buffer
- `AutoformatDisableBuffer` - Disable autoformat for buffer
