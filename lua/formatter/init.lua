local M = {}

M.autoformat_enabled = true

function M.autoformat_toggle()
    M.autoformat_enabled = not M.autoformat_enabled
end

vim.api.nvim_create_user_command("AutoformatToggle", M.autoformat_toggle, {})

function M.setup(config)
    local auFormatter = vim.api.nvim_create_augroup("Formatter", {})

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        group = auFormatter,
        pattern = { "*" },
        callback = function()
            if not M.autoformat_enabled then
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
