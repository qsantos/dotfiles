local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- appearance
  { "nvim-lualine/lualine.nvim", opts = { options = { theme = "auto" } } },
  { "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
  { "nvim-tree/nvim-web-devicons" },
  { "lewis6991/gitsigns.nvim", opts = {} },
  { "folke/tokyonight.nvim", opts = {} },

  -- commands
  { "tpope/vim-unimpaired" },
  { "tpope/vim-fugitive" },
  { "nvim-tree/nvim-tree.lua", opts = {} },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- syntax / LSP-ready
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-treesitter/nvim-treesitter-context" },
  { "preservim/vim-markdown" },
  { "leafgarland/typescript-vim" },

  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }},
  { "jay-babu/mason-nvim-dap.nvim" },

  -- LSP + completion
  { "williamboman/mason.nvim", build = ":MasonUpdate", opts = {} },
  { "williamboman/mason-lspconfig.nvim", opts = {} },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
  { "rafamadriz/friendly-snippets" },
})

require("treesitter-context").setup({
  mode = "topline",
  separator = "-",
})
vim.o.scrolloff = 4

-- tabs
require("bufferline").setup({
  options = {
    mode = "buffers", -- show buffers, not tabs
    numbers = "none",
    diagnostics = "nvim_lsp", -- optional: show LSP errors per buffer
    separator_style = "slant",
    show_buffer_close_icons = false,
    show_close_icon = false,
    always_show_bufferline = true,
    -- show full relative paths, not just file name
    max_name_length = 999,
    max_prefix_length = 999,
    truncate_names = false,
    name_formatter = function(buf)
        return vim.fn.fnamemodify(buf.path, ":.")
    end,
  },
})
vim.keymap.set('n', '<C-H>', '<cmd>bprevious!<CR>')
vim.keymap.set('n', '<C-L>', '<cmd>bnext!<CR>')
vim.keymap.set('n', '<C-G>', '<cmd>tabprevious<CR>')
vim.keymap.set('n', '<C-M>', '<cmd>tabnext<CR>')
vim.keymap.set('n', ',d', '<cmd>bn | bd#<CR>')

require("lualine").setup({
  sections = {
    lualine_c = {
      { "filename", path = 1 }, -- 0 = basename, 1 = relative, 2 = absolute
    },
  },
})

-- Keymaps
vim.keymap.set('n', '<C-H>', '<cmd>BufferLineCyclePrev<CR>', { silent = true })
vim.keymap.set('n', '<C-L>', '<cmd>BufferLineCycleNext<CR>', { silent = true })

require("tokyonight").setup({
  style = "night",
  transparent = true,
  terminal_colors = true,
  styles = {
    sidebars = "transparent",
    floats = "transparent",
  },
})
vim.cmd.colorscheme("tokyonight")

-- Leader
vim.g.mapleader = ' '

-- Exit insert mode with "kj" (and variants)
vim.keymap.set('i', 'kj', '<Esc>')
vim.keymap.set('i', 'Kj', '<Esc>')
vim.keymap.set('i', 'kJ', '<Esc>')
vim.keymap.set('i', 'KJ', '<Esc>')

-- Clear search highlight
vim.keymap.set('n', '<BS>', '<cmd>nohlsearch<CR>')

-- Insert date/time for work log
local function log_date() vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes([[G$"=strftime("\n\n# %F\n\n- %T ")<CR>pGA]], true, false, true), 'n', false) end
local function log_time() vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes([[G$"=strftime("\n- %T ")<CR>pGA]], true, false, true), 'n', false) end
vim.keymap.set({'n','i'}, '<F5>', function() vim.cmd('stopinsert'); log_date() end)
vim.keymap.set({'n','i'}, '<F6>', function() vim.cmd('stopinsert'); log_time() end)

-- Toggle file tree
vim.keymap.set('n', '<C-k>', '<cmd>NvimTreeToggle<CR>', { noremap = true, silent = true })
require("nvim-tree").setup({
  actions = { open_file = { quit_on_open = true } },
  update_focused_file = { enable = true },
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- close qflist when selecting a file
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        vim.keymap.set("n", "<CR>", "<CR>:cclose<CR>", { buffer = true })
    end,
})

-- LSP
vim.keymap.set('n', '<F1>', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>]], { noremap=true })
vim.keymap.set('n', '<F2>', vim.lsp.buf.rename)
vim.keymap.set('n', 'gh', vim.lsp.buf.rename)
vim.keymap.set('n', 'ù',  vim.lsp.buf.definition)
vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition)
vim.keymap.set('n', 'g?', vim.lsp.buf.hover)
vim.keymap.set('n', 'gi', vim.lsp.buf.incoming_calls)
vim.keymap.set('n', 'gj', vim.lsp.buf.code_action)
vim.keymap.set('n', '!', '<C-t>')

-- Spelling
vim.opt.spell = true
vim.opt.spelllang:append("cjk")
vim.opt.spelloptions = "camel"

vim.opt.list = true
vim.opt.listchars = {
  nbsp = "~", tab = ">-",
  eol = "↲", trail = "·",
  extends = "›", precedes = "‹",
}
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.showbreak = "↪"
vim.opt.colorcolumn = "100"
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
-- vim.g.pyindent_open_paren = "&sw"
-- vim.g.pyindent_nested_paren = "&sw"
-- vim.g.pyindent_continue = "&sw"

-- title
vim.opt.title = true
if os.getenv("TMUX") then
  local aug = vim.api.nvim_create_augroup("TmuxRename", { clear = true })
  vim.api.nvim_create_autocmd("BufEnter", {
    group = aug,
    callback = function()
      local name = vim.fn.expand("%:t")
      if name == "" then name = "neovim" end
      vim.fn.system({ "tmux", "rename-window", name })
    end,
  })
  vim.api.nvim_create_autocmd("VimLeave", {
    group = aug,
    command = [[silent! !tmux setw automatic-rename on]],
  })
end

-- JSDoc in .js files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.js",
  callback = function()
    vim.bo.filetype = "typescript"
    vim.cmd("syntax=javascript")
  end,
})

-- Git commit formatting
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.colorcolumn = "51"
    vim.opt_local.textwidth = 72
  end,
})

-- Markdown / TeX
vim.g.markdown_fenced_languages = {
  "c", "css", "javascript", "js=javascript", "json=javascript",
  "html", "python",
}
vim.g["pandoc#syntax#codeblocks#embeds#langs"] = { "json=javascript", "ruby", "python", "bash=sh" }
vim.g.tex_flavor = "latex"

-- Syntax sync for large files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*",
  command = "syntax sync fromstart",
})

-- robust undodir (try state, fallback to data)
local candidates = {
  vim.fn.stdpath("state") .. "/undo",
  vim.fn.stdpath("data")  .. "/undo",
}
local undodir
for _, p in ipairs(candidates) do
  if vim.fn.isdirectory(p) == 0 then vim.fn.mkdir(p, "p") end
  if vim.fn.isdirectory(p) == 1 and vim.fn.filewritable(p) == 2 then
    undodir = p; break
  end
end
if undodir then
  vim.opt.undodir = undodir
  vim.opt.undofile = true
else
  vim.notify("Persistent undo disabled: no writable undodir", vim.log.levels.WARN)
end

local autocmd = vim.api.nvim_create_autocmd

-- @returns a "clear = true" augroup
local function augroup(name) return vim.api.nvim_create_augroup('sergio-lazyvim_' .. name, { clear = true }) end

autocmd('BufReadPost', {
  group = augroup('restore_position'),
  callback = function()
    local exclude = { 'gitcommit' }
    local buf = vim.api.nvim_get_current_buf()
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then return end

    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local line_count = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
      vim.api.nvim_feedkeys('zvzz', 'n', true)
    end
  end,
  desc = 'Restore cursor position after reopening file',
})

-- nvim-cmp
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"]      = cmp.mapping.confirm(),
    ["<Tab>"]     = cmp.mapping(function(fb)
      if cmp.visible() then cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      else fb() end
    end, { "i", "s" }),
    ["<S-Tab>"]   = cmp.mapping(function(fb)
      if cmp.visible() then cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then luasnip.jump(-1)
      else fb() end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({ { name = "nvim_lsp" } }, { { name = "path" }, { name = "buffer" } }),
})
vim.opt.completeopt = { "menuone", "noselect" }

-- LSP
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "rust_analyzer", "pyright", "ts_ls", "clangd", "lua_ls" },
})
vim.lsp.config["lua_ls"] = {
  settings = {
    Lua = { diagnostics = { globals = { "vim" } } }
  },
}
require("mason-nvim-dap").setup({
  ensure_installed = { "codelldb" },
})

local dap = require("dap")

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = "codelldb",
    args = { "--port", "${port}" },
  },
}

dap.configurations.c = {
  {
    name = "Launch",
    type = "codelldb",
    request = "launch",
    program = function() return vim.fn.input("Binary: ", vim.fn.getcwd().."/", "file") end,
    cwd = "${workspaceFolder}",
  },
}
dap.configurations.rust = dap.configurations.c

require("dapui").setup()
vim.keymap.set("n", "<F5>", dap.continue)
vim.keymap.set("n", "<F8>", require("dapui").open)
vim.keymap.set("n", "<F9>", dap.toggle_breakpoint)
vim.keymap.set("n", "<F10>", dap.continue)
vim.fn.sign_define("DapBreakpoint", {
  text = "●",
  texthl = "DiagnosticError",
})
vim.fn.sign_define("DapStopped", {
  text = "▶",
  texthl = "DiagnosticError",
})

-- comment / uncomment
vim.keymap.set("n", "<leader>c", "gcc", { remap = true })
vim.keymap.set("v", "<leader>c", "gc", { remap = true })

-- git
local gs = require("gitsigns")
gs.setup()
vim.keymap.set('n', 'gb', '<cmd>Git blame<CR>')
vim.keymap.set("n", "]h", gs.next_hunk)
vim.keymap.set("n", "[h", gs.prev_hunk)
vim.keymap.set("n", ")h", gs.next_hunk)
vim.keymap.set("n", "(h", gs.prev_hunk)
vim.keymap.set("n", "<leader>hp", gs.preview_hunk)
vim.keymap.set("n", "<leader>hs", gs.stage_hunk)
vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk)

-- diagnostics
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  severity_sort = true,
})
vim.keymap.set("n", ")d", vim.diagnostic.goto_next)
vim.keymap.set("n", "(d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { silent = true })

-- unimpaired equivalent
for _, m in ipairs({ 'n','o','x' }) do
  vim.keymap.set(m, '(', '[')
  vim.keymap.set(m, ')', ']')
end
