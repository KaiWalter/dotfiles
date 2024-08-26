require("tokyonight").setup({ style = "night" })

-- Set up globals {{{
do
    local nixvim_globals = {
        loaded_perl_provider = 0,
        loaded_python3_provider = 0,
        loaded_python_provider = 0,
        loaded_ruby_provider = 0,
        mapleader = " ",
        maplocalleader = " ",
    }

    for k, v in pairs(nixvim_globals) do
        vim.g[k] = v
    end
end
-- }}}

-- Set up options {{{
do
    local nixvim_options = {
        autoindent = true,
        clipboard = "unnamedplus",
        colorcolumn = "100",
        completeopt = { "menu", "menuone", "noselect" },
        cursorcolumn = false,
        cursorline = false,
        expandtab = true,
        fileencoding = "utf-8",
        foldlevel = 99,
        hidden = true,
        ignorecase = true,
        inccommand = "split",
        incsearch = true,
        laststatus = 3,
        modeline = true,
        modelines = 100,
        mouse = "a",
        mousemodel = "extend",
        number = true,
        relativenumber = true,
        scrolloff = 8,
        shiftwidth = 4,
        signcolumn = "yes",
        smartcase = true,
        spell = false,
        splitbelow = true,
        splitright = true,
        swapfile = false,
        tabstop = 4,
        termguicolors = true,
        textwidth = 0,
        undofile = true,
        updatetime = 100,
        wrap = false,
    }

    for k, v in pairs(nixvim_options) do
        vim.opt[k] = v
    end
end
-- }}}

vim.diagnostic.config({ virtual_text = false })

local slow_format_filetypes = {}

vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = "Disable autoformat-on-save",
    bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, {
    desc = "Re-enable autoformat-on-save",
})
vim.api.nvim_create_user_command("FormatToggle", function(args)
    if args.bang then
        -- Toggle formatting for current buffer
        vim.b.disable_autoformat = not vim.b.disable_autoformat
    else
        -- Toggle formatting globally
        vim.g.disable_autoformat = not vim.g.disable_autoformat
    end
end, {
    desc = "Toggle autoformat-on-save",
    bang = true,
})

vim.cmd([[
let $BAT_THEME = 'tokyonight'

colorscheme tokyonight

]])

require("which-key").setup({})

require("trim").setup({
    ft_blocklist = { "checkhealth", "floaterm", "lspinfo", "neo-tree", "TelescopePrompt" },
    highlight = true,
})

require("colorizer").setup({
    filetypes = nil,
    user_default_options = { names = false },
    buftypes = nil,
})

require("nvim-autopairs").setup({})

require("telescope").setup({})

local __telescopeExtensions = { "fzf", "file_browser" }
for i, extension in ipairs(__telescopeExtensions) do
    require("telescope").load_extension(extension)
end

require("lualine").setup({ options = { icons_enabled = true } })
require("luasnip").config.setup({})

require("null-ls").setup({
    cmd = { "bash -c nvim" },
    debug = true,
    on_attach = require("lsp-format").on_attach,
    sources = {
        require("null-ls").builtins.code_actions.gitsigns,
        require("null-ls").builtins.code_actions.statix,
        require("null-ls").builtins.completion.luasnip,
        require("null-ls").builtins.completion.spell,
        require("null-ls").builtins.diagnostics.checkstyle,
        require("null-ls").builtins.diagnostics.deadnix,
        require("null-ls").builtins.diagnostics.pylint,
        require("null-ls").builtins.diagnostics.statix,
        require("null-ls").builtins.formatting.alejandra,
        require("null-ls").builtins.formatting.black.with({
            extra_args = { "--fast" },
        }),
        require("null-ls").builtins.formatting.nixpkgs_fmt,
        require("null-ls").builtins.formatting.prettier,
        require("null-ls").builtins.formatting.shfmt,
        require("null-ls").builtins.formatting.stylua,
    },
})

require("trouble").setup({})

require("lsp_lines").setup()

require("lsp-format").setup({})

require("fidget").setup({
    logger = { float_precision = 0.01, level = vim.log.levels.WARN },
    notification = {
        configs = { default = require("fidget.notification").default_config },
        filter = vim.log.levels.INFO,
        history_size = 128,
        override_vim_notify = true,
        poll_rate = 10,
        redirect = function(msg, level, opts)
            if opts and opts.on_open then
                return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
            end
        end,
        view = { group_separator = "---", group_separator_hl = "Comment", icon_separator = " ", stack_upwards = true },
        window = {
            align = "bottom",
            border = "none",
            max_height = 0,
            max_width = 0,
            normal_hl = "Comment",
            relative = "editor",
            winblend = 0,
            x_padding = 1,
            y_padding = 0,
            zindex = 45,
        },
    },
    progress = {
        clear_on_detach = function(client_id)
            local client = vim.lsp.get_client_by_id(client_id)
            return client and client.name or nil
        end,
        display = {
            done_icon = "✔",
            done_style = "Constant",
            done_ttl = 3,
            format_annote = function(msg)
                return msg.title
            end,
            format_group_name = function(group)
                return tostring(group)
            end,
            format_message = require("fidget.progress.display").default_format_message,
            group_style = "Title",
            icon_style = "Question",
            overrides = { rust_analyzer = { name = "rust-analyzer" } },
            priority = 30,
            progress_icon = { pattern = "dots", period = 1 },
            progress_style = "WarningMsg",
            progress_ttl = math.huge,
            render_limit = 16,
            skip_history = true,
        },
        ignore_done_already = false,
        ignore_empty_message = false,
        lsp = { progress_ringbuf_size = 0 },
        notification_group = function(msg)
            return msg.lsp_client.name
        end,
        poll_rate = 0,
        suppress_on_insert = true,
    },
})

require("conform").setup({
    format_after_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end

        if not slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
        end

        return { lsp_fallback = true }
    end,
    format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end

        if slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
        end

        local function on_format(err)
            if err and err:match("timeout$") then
                slow_format_filetypes[vim.bo[bufnr].filetype] = true
            end
        end

        return { timeout_ms = 200, lsp_fallback = true }, on_format
    end,
    formatters = {
        alejandra = { command = "/nix/store/s11ffsm0ycjcs91k08hd2z32nfvj23g8-alejandra-3.0.0/bin/alejandra" },
        bicep = { command = "/nix/store/kh82xly5ar46s9m7lgi08h3s0kvy5cs8-bicep-0.29.47/bin/bicep" },
        black = { command = "/nix/store/a4bsgpvmih5zcsjbcx5360c4v0cjd6ip-python3.12-black-24.4.2/bin/black" },
        isort = { command = "/nix/store/sx8lrlipwcbwvx2sbaj2145ggg2m42j1-python3.12-isort-5.13.2/bin/isort" },
        jq = { command = "/nix/store/wq2z3xx9z1d1d1c46mcrpd292qmnxdaa-jq-1.7.1-bin/bin/jq" },
        prettierd = { command = "/nix/store/rxxb0yzg4z969kbcs4lid6dhgz5z8g35-fsouza-prettierd-0.25.3/bin/prettierd" },
        shellcheck = { command = "/nix/store/nz090h40d9p4nc2lx55dpnkygr2g0j9a-shellcheck-0.10.0-bin/bin/shellcheck" },
        shellharden = { command = "/nix/store/arsrzffm1yvmp1safbmvm3snxsa5q079-shellharden-4.3.1/bin/shellharden" },
        shfmt = { command = "/nix/store/2ahn9czlg2cn81hmw2drg0wl2j99kp0w-shfmt-3.9.0/bin/shfmt" },
        stylua = { command = "/nix/store/ncvwg9dlmgzv8z65r85k29nrh563w5li-stylua-0.20.0/bin/stylua" },
    },
    formatters_by_ft = {
        _ = { "trim_whitespace" },
        bash = { "shellcheck", "shellharden", "shfmt" },
        bicep = { "bicep" },
        css = { { "prettierd", "prettier" } },
        html = { { "prettierd", "prettier" } },
        javascript = { { "prettierd", "prettier" } },
        json = { "jq" },
        lua = { "stylua" },
        markdown = { { "prettierd", "prettier" } },
        nix = { "alejandra" },
        python = { "black", "isort" },
        terraform = { "terraform_fmt" },
        typescript = { { "prettierd", "prettier" } },
        yaml = { { "prettierd", "prettier" } },
    },
    notify_on_error = true,
})

-- LSP {{{
do
    do
        local lsp_status = require("lsp-status")
        lsp_status.config({})
        lsp_status.register_progress()
    end

    local __lspServers = {
        {
            extraOptions = {
                on_attach = function(client, bufnr)
                    require("lsp-status").on_attach(client)
                    require("lsp-format").on_attach(client)

                    client.server_capabilities.documentFormattingProvider = false
                end,
            },
            name = "tsserver",
        },
        { name = "rust_analyzer" },
        { name = "nil_ls" },
    }
    local __lspOnAttach = function(client, bufnr)
        require("lsp-status").on_attach(client)
        require("lsp-format").on_attach(client)
    end
    local __lspCapabilities = function()
        capabilities = vim.lsp.protocol.make_client_capabilities()

        capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

        capabilities = vim.tbl_extend("keep", capabilities or {}, require("lsp-status").capabilities)

        return capabilities
    end

    local __setup = {
        on_attach = __lspOnAttach,
        capabilities = __lspCapabilities(),
    }

    for i, server in ipairs(__lspServers) do
        if type(server) == "string" then
            require("lspconfig")[server].setup(__setup)
        else
            local options = server.extraOptions

            if options == nil then
                options = __setup
            else
                options = vim.tbl_extend("keep", options, __setup)
            end

            require("lspconfig")[server.name].setup(options)
        end
    end

    require("rust-tools").setup({ server = { on_attach = __lspOnAttach } })
end
-- }}}

require("nvim-ts-autotag").setup({})

vim.opt.runtimepath:prepend(vim.fs.joinpath(vim.fn.stdpath("data"), "site"))
require("nvim-treesitter.configs").setup({
    highlight = { enable = true },
    indent = { enable = true },
    parser_install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site"),
})

require("gitsigns").setup({ signs = { add = { text = "+" }, change = { text = "~" } } })

local function open_nvim_tree(data)
    ------------------------------------------------------------------------------------------

    -- buffer is a directory
    local directory = vim.fn.isdirectory(data.file) == 1

    -- buffer is a [No Name]
    local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

    -- Will automatically open the tree when running setup if startup buffer is a directory,
    -- is empty or is unnamed. nvim-tree window will be focused.
    local open_on_setup = true

    if (directory or no_name) and open_on_setup then
        -- change to the directory
        if directory then
            vim.cmd.cd(data.file)
        end

        -- open the tree
        require("nvim-tree.api").tree.open()
        return
    end

    ------------------------------------------------------------------------------------------

    -- Will automatically open the tree when running setup if startup buffer is a file.
    -- File window will be focused.
    -- File will be found if updateFocusedFile is enabled.
    local open_on_setup_file = false

    -- buffer is a real file on the disk
    local real_file = vim.fn.filereadable(data.file) == 1

    if (real_file or no_name) and open_on_setup_file then
        -- skip ignored filetypes
        local filetype = vim.bo[data.buf].ft
        local ignored_filetypes = {}

        if not vim.tbl_contains(ignored_filetypes, filetype) then
            -- open the tree but don't focus it
            require("nvim-tree.api").tree.toggle({ focus = false })
            return
        end
    end

    ------------------------------------------------------------------------------------------

    -- Will ignore the buffer, when deciding to open the tree on setup.
    local ignore_buffer_on_setup = false
    if ignore_buffer_on_setup then
        require("nvim-tree.api").tree.open()
    end
end

require("nvim-tree").setup({
    diagnostics = { enable = true, show_on_dirs = true, show_on_open_dirs = true },
    disable_netrw = true,
    hijack_directories = { auto_open = true },
    reload_on_bufenter = true,
    sync_root_with_cwd = true,
})

require("dap").adapters = {}
require("dap").configurations = {
    javascript = {
        {
            cwd = "${workspaceFolder}",
            name = "Debug (Launch)",
            program = "${file}",
            request = "launch",
            type = "pwa-node",
        },
    },
    typescript = {
        {
            cwd = "${workspaceFolder}",
            name = "Debug (Launch)",
            program = "${file}",
            request = "launch",
            sourceMaps = true,
            type = "pwa-node",
        },
    },
}
local __dap_signs = {
    DapBreakpoint = { text = "●", texthl = "DapBreakpoint" },
    DapBreakpointCondition = { text = "●", texthl = "DapBreakpointCondition" },
    DapLogPoint = { text = "◆", texthl = "DapLogPoint" },
}
for sign_name, sign in pairs(__dap_signs) do
    vim.fn.sign_define(sign_name, sign)
end
require("nvim-dap-virtual-text").setup({})

require("dapui").setup({
    controls = {
        icons = {
            disconnect = "⏏",
            pause = "⏸",
            play = "▶",
            run_last = "▶▶",
            step_back = "b",
            step_into = "⏎",
            step_out = "⏮",
            step_over = "⏭",
            terminate = "⏹",
        },
    },
    floating = { mappings = { close = { "<ESC>", "q" } } },
    icons = { collapsed = "▸", current_frame = "*", expanded = "▾" },
})

require("dap-python").setup("/nix/store/9spwzfs2i0w26pqlfiixkrngmis903sa-python3-3.12.4-env/bin/python3", {})

local cmp = require("cmp")
cmp.setup({
    formatting = {
        format = require("lspkind").cmp_format({
            menu = {
                buffer = "[buffer]",
                luasnip = "[snip]",
                neorg = "[neorg]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[api]",
                path = "[path]",
            },
        }),
    },
    mapping = {
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-e>"] = cmp.mapping.close(),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
        ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
    },
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    sources = {
        { name = "path" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer", option = { get_bufnrs = vim.api.nvim_list_bufs } },
        { name = "neorg" },
    },
})

require("bufferline").setup({})

-- Set up keybinds {{{
do
    local __nixvim_binds = {
        { action = '"_dP', key = "p", mode = "v" },
        { action = '"+y', key = "<leader>y", mode = "v", options = { desc = "copy to system clipboard" } },
        { action = '"+p', key = "<leader>p", mode = "n", options = { desc = "paste from system clipboard" } },
        { action = "<cmd>bnext<cr>", key = "<leader>bn", mode = "n", options = { desc = "Next Buffer" } },
        { action = "<cmd>bprev<cr>", key = "<leader>bp", mode = "n", options = { desc = "Previous Buffer" } },
        { action = "<cmd>tablast<cr>", key = "<leader><tab>l", mode = "n", options = { desc = "Last Tab" } },
        { action = "<cmd>tabfirst<cr>", key = "<leader><tab>f", mode = "n", options = { desc = "First Tab" } },
        { action = "<cmd>tabnew<cr>", key = "<leader><tab><tab>", mode = "n", options = { desc = "New Tab" } },
        { action = "<cmd>tabnext<cr>", key = "<leader><tab>n", mode = "n", options = { desc = "Next Tab" } },
        { action = "<cmd>tabclose<cr>", key = "<leader><tab>c", mode = "n", options = { desc = "Close Tab" } },
        { action = "<cmd>tabprevious<cr>", key = "<leader><tab>p", mode = "n", options = { desc = "Previous Tab" } },
        { action = "<NOP>", key = "<Space>", mode = "n", options = { silent = true } },
        { action = ":noh<CR>", key = "<esc>", mode = "n", options = { silent = true } },
        { action = "<gv", key = "<", mode = "v", options = { silent = true } },
        { action = "<gv", key = "<S-TAB>", mode = "v", options = { silent = true } },
        { action = ">gv", key = "<TAB>", mode = "v", options = { silent = true } },
        { action = ">gv", key = ">", mode = "v", options = { silent = true } },
        { action = ":m '>+1<CR>gv=gv", key = "J", mode = "v", options = { silent = true } },
        { action = ":m '<-2<CR>gv=gv", key = "K", mode = "v", options = { silent = true } },
        {
            action = "\n        <cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>\n      ",
            key = "<leader>dB",
            mode = "n",
            options = { desc = "Breakpoint Condition", silent = true },
        },
        {
            action = ":DapToggleBreakpoint<cr>",
            key = "<F9>",
            mode = "n",
            options = { desc = "Toggle Breakpoint", silent = true },
        },
        {
            action = ":DapToggleBreakpoint<cr>",
            key = "<leader>db",
            mode = "n",
            options = { desc = "Toggle Breakpoint", silent = true },
        },
        { action = ":DapContinue<cr>", key = "<F5>", mode = "n", options = { desc = "Continue", silent = true } },
        { action = ":DapContinue<cr>", key = "<leader>dc", mode = "n", options = { desc = "Continue", silent = true } },
        {
            action = "<cmd>lua require('dap').continue({ before = get_args })<cr>",
            key = "<leader>da",
            mode = "n",
            options = { desc = "Run with Args", silent = true },
        },
        {
            action = "<cmd>lua require('dap').run_to_cursor()<cr>",
            key = "<leader>dC",
            mode = "n",
            options = { desc = "Run to cursor", silent = true },
        },
        {
            action = "<cmd>lua require('dap').goto_()<cr>",
            key = "<leader>dg",
            mode = "n",
            options = { desc = "Go to line (no execute)", silent = true },
        },
        { action = ":DapStepInto<cr>", key = "<leader>di", mode = "n", options = { desc = "Step into", silent = true } },
        {
            action = "\n        <cmd>lua require('dap').down()<cr>\n      ",
            key = "<leader>dj",
            mode = "n",
            options = { desc = "Down", silent = true },
        },
        {
            action = "<cmd>lua require('dap').up()<cr>",
            key = "<leader>dk",
            mode = "n",
            options = { desc = "Up", silent = true },
        },
        {
            action = "<cmd>lua require('dap').run_last()<cr>",
            key = "<leader>dl",
            mode = "n",
            options = { desc = "Run Last", silent = true },
        },
        { action = ":DapStepOut<cr>", key = "<leader>do", mode = "n", options = { desc = "Step Out", silent = true } },
        { action = ":DapStepOver<cr>", key = "<leader>dO", mode = "n", options = { desc = "Step Over", silent = true } },
        {
            action = "<cmd>lua require('dap').pause()<cr>",
            key = "<leader>dp",
            mode = "n",
            options = { desc = "Pause", silent = true },
        },
        {
            action = ":DapToggleRepl<cr>",
            key = "<leader>dr",
            mode = "n",
            options = { desc = "Toggle REPL", silent = true },
        },
        {
            action = "<cmd>lua require('dap').session()<cr>",
            key = "<leader>ds",
            mode = "n",
            options = { desc = "Session", silent = true },
        },
        {
            action = ":DapTerminate<cr>",
            key = "<leader>dt",
            mode = "n",
            options = { desc = "Terminate", silent = true },
        },
        {
            action = "<cmd>lua require('dapui').toggle()<cr>",
            key = "<leader>du",
            mode = "n",
            options = { desc = "Dap UI", silent = true },
        },
        {
            action = "<cmd>lua require('dap.ui.widgets').hover()<cr>",
            key = "<leader>dw",
            mode = "n",
            options = { desc = "Widgets", silent = true },
        },
        {
            action = "<cmd>lua require('dapui').eval()<cr>",
            key = "<leader>de",
            mode = { "n", "v" },
            options = { desc = "Eval", silent = true },
        },
        { action = "<cmd>NvimTreeToggle<CR>", key = "<leader>ee", mode = "n", options = { silent = true } },
        { action = "<cmd>NvimTreeFindFileToggle<CR>", key = "<leader>ef", mode = "n", options = { silent = true } },
        {
            action = "<cmd>Telescope find_files<CR>",
            key = "<leader>ff",
            mode = "n",
            options = { desc = "find files", silent = true },
        },
        {
            action = "<cmd>Telescope live_grep<CR>",
            key = "<leader>fs",
            mode = "n",
            options = { desc = "find string in files", silent = true },
        },
        {
            action = "<cmd>Telescope file_browser<CR>",
            key = "<leader>fe",
            mode = "n",
            options = { desc = "file browser", silent = true },
        },
        {
            action = "<cmd>Telescope buffers<CR>",
            key = "<leader>fb",
            mode = "n",
            options = { desc = "show buffers", silent = true },
        },
    }
    for i, map in ipairs(__nixvim_binds) do
        vim.keymap.set(map.mode, map.key, map.action, map.options)
    end
end
-- }}}

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local mason_tool_installer = require("mason-tool-installer")

mason.setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})

-- look for packages : https://github.com/mason-org/mason-registry/tree/main/packages
mason_tool_installer.setup({
    ensure_installed = {
        -- "js-debug-adapter",
    },
    automatic_installation = true,
})

local dap = require("dap")
--
-- dap.listeners.after.event_initialized["dapui_config"] = require("dapui").open
-- dap.listeners.before.event_terminated["dapui_config"] = require("dapui").close
-- dap.listeners.before.event_exited["dapui_config"] = require("dapui").close
dap.set_log_level("TRACE")

require("dap-vscode-js").setup({
    -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
    -- debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter", -- Path to vscode-js-debug installation.
    -- debugger_cmd = {"/home/kai/src/vscode-js-debug", "js-debug-adapter", }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
    debugger_path = "/home/kai/src/vscode-js-debug", -- Path to vscode-js-debug installation.
    -- debugger_path = "pkgs.vscode-js-debug}", -- Path to vscode-js-debug installation.
    adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
    -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
    log_file_level = vim.log.levels.TRACE, -- Logging level for output to file. Set to false to disable file logging.
    log_console_level = vim.log.levels.TRACE, -- Logging level for output to console. Set to false to disable console output.
})

-- Set up autogroups {{
do
    local __nixvim_autogroups = { nixvim_binds_LspAttach = { clear = true } }

    for group_name, options in pairs(__nixvim_autogroups) do
        vim.api.nvim_create_augroup(group_name, options)
    end
end
-- }}
-- Set up autocommands {{
do
    local __nixvim_autocommands = {
        { callback = open_nvim_tree, event = "VimEnter" },
        {
            callback = function()
                do
                    local __nixvim_binds = {
                        { action = vim.lsp.buf.hover, key = "K", mode = "n", options = { silent = false } },
                        { action = vim.lsp.buf.references, key = "gD", mode = "n", options = { silent = false } },
                        { action = vim.lsp.buf.definition, key = "gd", mode = "n", options = { silent = false } },
                        { action = vim.lsp.buf.implementation, key = "gi", mode = "n", options = { silent = false } },
                        { action = vim.lsp.buf.type_definition, key = "gt", mode = "n", options = { silent = false } },
                    }
                    for i, map in ipairs(__nixvim_binds) do
                        vim.keymap.set(map.mode, map.key, map.action, map.options)
                    end
                end
            end,
            desc = "Load keymaps for LspAttach",
            event = "LspAttach",
            group = "nixvim_binds_LspAttach",
        },
        { command = "norm zz", event = "InsertEnter" },
        { command = "wincmd L", event = "FileType", pattern = "help" },
        { command = "setlocal spell spelllang=en", event = "FileType", pattern = { "tex", "latex", "markdown" } },
    }

    for _, autocmd in ipairs(__nixvim_autocommands) do
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
end
-- }}
