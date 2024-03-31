local function map(mode, lhs, rhs, desc, bufnr)
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "
	local options = { noremap = true, silent = true, desc = desc }
	if bufnr then
		options.bufnr = bufnr
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

function MapN(lhs, rhs, desc, bufnr)
	map("n", lhs, rhs, desc, bufnr)
end

function MapV(lhs, rhs, desc, bufnr)
	map("v", lhs, rhs, desc, bufnr)
end

function MapI(lhs, rhs, desc, bufnr)
	map("i", lhs, rhs, desc, bufnr)
end

function ComputerName()
	return os.getenv("COMPUTERNAME") or os.getenv("HOSTNAME")
end

function IsCorporate()
	local computername = ComputerName()
	if computername then
		local prefix = string.upper(string.sub(computername, 1, 2))
		return prefix == "ZO" or prefix == "CZ"
	else
		return false
	end
end

function IsWindows()
	return vim.loop.os_uname().sysname == "Windows_NT"
end

function FileExists(name)
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

function FolderExists(name)
	return vim.fn.isdirectory(name) == 1
end

local function get_git_root()
	local dot_git_path = vim.fn.finddir(".git", ".;")
	return vim.fn.fnamemodify(dot_git_path, ":h")
end

vim.api.nvim_create_user_command("CdGitRoot", function()
	vim.api.nvim_set_current_dir(get_git_root())
end, {})

MapN("<leader>xr", ":CdGitRoot<CR>", "cd to GIT [r]oot")
