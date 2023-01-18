# sync-format.nvim

Synchronous formatter runner for Neovim that runs after buffer write.

## Installation

Without any package manager:

```sh
git clone https://github.com/mgnsk/sync-format.nvim.git $HOME/.local/share/nvim/site/pack/pkg/start/sync-format.nvim
```

If you're using a package manager, look for its documentation on how to install `"mgnsk/sync-format.nvim"`.

## Configuration

By default there are no tools configured. The configuration expects a table with filetype and an array of command + arguments.
For each tool, the buffer file path is passed as the last argument when the formatter is called.

An example config:

```lua
require("formatter").setup({
    css = { "prettier", "-w" },
    less = { "prettier", "-w" },
    markdown = { "prettier", "-w" },
    html = { "prettier", "-w" },
    json = { "prettier", "-w" },
    javascript = { "prettier", "-w" },
    typescript = { "prettier", "-w" },
    lua = { "stylua", "--indent-type", "Spaces", "--indent-width", "4" },
    c = { "clang-format", "-i" },
    glsl = { "clang-format", "-i" },
    proto = { "buf", "format", "-w" },
    dockerfile = { "dockerfile_format" },
    go = { "goimports", "-w" },
    rust = { "rustfmt" },
    sh = { "shfmt", "-w" },
    sql = { "pg_format", "-i", "--type-case", "0" },
})
```
