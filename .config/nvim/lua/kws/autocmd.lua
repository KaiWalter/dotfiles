local _autocommands = {
	{ command = "norm zz", event = "InsertEnter" },
	{ command = "wincmd L", event = "FileType", pattern = "help" },
	{ command = "setlocal spell spelllang=en", event = "FileType", pattern = { "tex", "latex", "markdown" } },
}

for _, autocmd in ipairs(_autocommands) do
	vim.api.nvim_create_autocmd(autocmd.event, {
		group = autocmd.group,
		pattern = autocmd.pattern,
		buffer = autocmd.buffer,
		desc = autocmd.desc,
		callback = autocmd.callback,
		command = autocmd.command,
		once = autocmd.once,
		nested = autocmd.nested,
	})
end
