vim.api.nvim_create_user_command("AutoformatToggle", function()
    vim.g.sync_format_autoformat_disabled = not vim.g.sync_format_autoformat_disabled
end, {})

vim.api.nvim_create_user_command("AutoformatToggleBuffer", function()
    vim.b.sync_format_autoformat_disabled = not vim.b.sync_format_autoformat_disabled
end, {})

local M = {}

function M.setup(config)
    local auFormatter = vim.api.nvim_create_augroup("Formatter", {})

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        group = auFormatter,
        pattern = { "*" },
        callback = function()
            if vim.b.sync_format_autoformat_disabled or vim.g.sync_format_autoformat_disabled then
                return
            end

            local cmd = config[vim.bo.filetype]
            if cmd ~= nil then
                local bufname = vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
                local command = string.format("%s %s 2>&1", table.concat(cmd, " "), bufname)

                local output = vim.fn.system(command)

                if vim.v.shell_error ~= 0 then
                    vim.notify(output, vim.log.levels.ERROR, { title = "Formatter" })
                end

                vim.cmd([[silent! edit]])
            end
        end,
    })
end

return M
