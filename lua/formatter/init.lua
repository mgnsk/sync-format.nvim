local function print_status(disabled)
	if disabled then
		vim.notify("autoformat disabled", vim.log.levels.INFO, { title = "Formatter" })
	else
		vim.notify("autoformat enabled", vim.log.levels.INFO, { title = "Formatter" })
	end
end

vim.api.nvim_create_user_command("AutoformatToggle", function()
	vim.g.sync_format_autoformat_disabled = not vim.g.sync_format_autoformat_disabled
	print_status(vim.g.sync_format_autoformat_disabled)
end, { desc = "toggle autoformat globally" })

vim.api.nvim_create_user_command("AutoformatEnable", function()
	vim.g.sync_format_autoformat_disabled = false
	print_status(vim.g.sync_format_autoformat_disabled)
end, { desc = "enable autoformat globally" })

vim.api.nvim_create_user_command("AutoformatDisable", function()
	vim.g.sync_format_autoformat_disabled = true
	print_status(vim.g.sync_format_autoformat_disabled)
end, { desc = "disable autoformat globally" })

vim.api.nvim_create_user_command("AutoformatToggleBuffer", function()
	vim.b.sync_format_autoformat_disabled = not vim.b.sync_format_autoformat_disabled
	print_status(vim.b.sync_format_autoformat_disabled)
end, { desc = "toggle autoformat for buffer" })

vim.api.nvim_create_user_command("AutoformatEnableBuffer", function()
	vim.b.sync_format_autoformat_disabled = false
	print_status(vim.b.sync_format_autoformat_disabled)
end, { desc = "enable autoformat for buffer" })

vim.api.nvim_create_user_command("AutoformatDisableBuffer", function()
	vim.b.sync_format_autoformat_disabled = true
	print_status(vim.b.sync_format_autoformat_disabled)
end, { desc = "disable autoformat for buffer" })

local M = {}

vim.api.nvim_create_user_command("WriteFormatAll", function()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) ~= "" then
			vim.api.nvim_buf_call(buf, function()
				if vim.bo.modifiable and not vim.bo.readonly then
					vim.cmd.w()
				end
			end)
		end
	end
end, { desc = "write and format all loaded file buffers" })

function M.do_format()
	if vim.b.sync_format_autoformat_disabled or vim.g.sync_format_autoformat_disabled then
		return
	end

	local cmd = M.config[vim.bo.filetype]
	if cmd ~= nil then
		local bufname = vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
		local command = string.format("%s %s 2>&1", table.concat(cmd, " "), bufname)

		local output = vim.fn.system(command)

		if vim.v.shell_error ~= 0 then
			vim.notify(output, vim.log.levels.ERROR, { title = "Formatter" })
		end

		vim.cmd([[silent! edit]])
	end
end

function M.setup(config)
	local auFormatter = vim.api.nvim_create_augroup("Formatter", {})
	M.config = config

	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		group = auFormatter,
		pattern = { "*" },
		callback = M.do_format,
	})
end

return M
