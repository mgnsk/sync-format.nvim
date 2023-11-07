local function print_status_global(disabled)
	if disabled then
		vim.notify("autoformat disabled globally", vim.log.levels.INFO, { title = "Formatter" })
	else
		vim.notify("autoformat enabled globally", vim.log.levels.INFO, { title = "Formatter" })
	end
end

local function print_status_buffer(disabled)
	if disabled then
		vim.notify("autoformat disabled for buffer", vim.log.levels.INFO, { title = "Formatter" })
	else
		vim.notify("autoformat enabled for buffer", vim.log.levels.INFO, { title = "Formatter" })
	end
end

vim.api.nvim_create_user_command("AutoformatToggle", function()
	vim.g.sync_format_autoformat_disabled = not vim.g.sync_format_autoformat_disabled
	print_status_global(vim.g.sync_format_autoformat_disabled)
end, { desc = "Toggle autoformat globally" })

vim.api.nvim_create_user_command("AutoformatEnable", function()
	vim.g.sync_format_autoformat_disabled = false
	print_status_global(vim.g.sync_format_autoformat_disabled)
end, { desc = "Enable autoformat globally" })

vim.api.nvim_create_user_command("AutoformatDisable", function()
	vim.g.sync_format_autoformat_disabled = true
	print_status_global(vim.g.sync_format_autoformat_disabled)
end, { desc = "Disable autoformat globally" })

vim.api.nvim_create_user_command("AutoformatToggleBuffer", function()
	vim.b.sync_format_autoformat_disabled = not vim.b.sync_format_autoformat_disabled
	print_status_buffer(vim.b.sync_format_autoformat_disabled)
end, { desc = "Toggle autoformat for buffer" })

vim.api.nvim_create_user_command("AutoformatEnableBuffer", function()
	vim.b.sync_format_autoformat_disabled = false
	print_status_buffer(vim.b.sync_format_autoformat_disabled)
end, { desc = "Enable autoformat for buffer" })

vim.api.nvim_create_user_command("AutoformatDisableBuffer", function()
	vim.b.sync_format_autoformat_disabled = true
	print_status_buffer(vim.b.sync_format_autoformat_disabled)
end, { desc = "Disable autoformat for buffer" })

local M = {}

local function splitpath(p)
	return string.match(p, "^(.-)[\\/]?([^\\/]*)$")
end

function M.do_format()
	if vim.b.sync_format_autoformat_disabled or vim.g.sync_format_autoformat_disabled then
		return
	end

	local cmd = M.config[vim.bo.filetype]
	if cmd ~= nil then
		local filename = vim.fn.fnameescape(vim.fn.resolve(vim.api.nvim_buf_get_name(0)))
		local dir, _ = splitpath(filename)
		local command = string.format("cd %s; %s %s 2>&1", dir, table.concat(cmd, " "), filename)

		local output = vim.fn.system(command)
		if vim.v.shell_error ~= 0 then
			vim.notify(output, vim.log.levels.ERROR, { title = "sync-format.nvim" })
		end

		vim.cmd([[silent! edit]])
	end
end

function M.setup(config)
	local auFormatter = vim.api.nvim_create_augroup("sync-format.nvim", {})
	M.config = config

	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		group = auFormatter,
		pattern = { "*" },
		callback = M.do_format,
	})
end

return M
