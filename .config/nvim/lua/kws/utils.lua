function map(mode, lhs, rhs, desc, bufnr)
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "
	local options = { noremap = true, silent = true, desc = desc }
	if bufnr then
		options.bufnr = bufnr
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

function mapn(lhs, rhs, desc, bufnr)
	map("n", lhs, rhs, desc, bufnr)
end

function mapv(lhs, rhs, desc, bufnr)
	map("v", lhs, rhs, desc, bufnr)
end

function mapi(lhs, rhs, desc, bufnr)
	map("i", lhs, rhs, desc, bufnr)
end

function computer_name()
	return os.getenv("COMPUTERNAME") or os.getenv("HOSTNAME")
end

function is_windows()
	return vim.loop.os_uname().sysname == "Windows_NT"
end
