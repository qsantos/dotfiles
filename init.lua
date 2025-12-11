-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- appearance
  { "nvim-lualine/lualine.nvim", opts = { options = { theme = "auto" } } }, -- airline → lualine
  { "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
  { "nvim-tree/nvim-web-devicons" },                                        -- devicons
  { "lewis6991/gitsigns.nvim", opts = {} },                                 -- gitgutter → gitsigns
  { "folke/tokyonight.nvim", opts = {} },

  -- commands
  { "tpope/vim-unimpaired" },
  { "tpope/vim-fugitive" },
  { "nvim-tree/nvim-tree.lua", opts = {} },                                 -- NERDTree → nvim-tree
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } }, -- ctrlp → telescope

  -- syntax / LSP-ready
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-treesitter/nvim-treesitter-context" },                            -- context.vim → treesitter-context
  { "preservim/vim-markdown" },                                             -- keep
  { "leafgarland/typescript-vim" },                                         -- keep for ft; TS will do most work

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

-- ===== Bufferline (Airline tabline replacement) =====
require("bufferline").setup({
  options = {
    mode = "buffers",           -- show buffers, not tabs
    numbers = "none",
    diagnostics = "nvim_lsp",   -- optional: show LSP errors per buffer
    separator_style = "slant",
    show_buffer_close_icons = false,
    show_close_icon = false,
    always_show_bufferline = true,
    -- show full relative paths, not just file name
    max_name_length = 999,
    max_prefix_length = 999,
    truncate_names = false,
    name_formatter = function(buf)  -- buf contains:
        return vim.fn.fnamemodify(buf.path, ":.")
    end,
  },
})

require("lualine").setup({
  sections = {
    lualine_c = {
      { "filename", path = 1 },  -- 0 = basename, 1 = relative, 2 = absolute
    },
  },
})

-- Keymaps
vim.keymap.set('n', '<C-H>', '<cmd>BufferLineCyclePrev<CR>', { silent = true })
vim.keymap.set('n', '<C-L>', '<cmd>BufferLineCycleNext<CR>', { silent = true })
vim.keymap.set('n', ',d', '<cmd>bd<CR>', { silent = true }) -- close buffer

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

-- ===== Editing / convenience =====
-- Exit insert mode with "kj" (and variants)
vim.keymap.set('i', 'kj', '<Esc>')
vim.keymap.set('i', 'Kj', '<Esc>')
vim.keymap.set('i', 'kJ', '<Esc>')
vim.keymap.set('i', 'KJ', '<Esc>')

-- Keep clipboard when pasting over selection
vim.keymap.set('x', 'p', 'pgvy')

-- Clear search highlight
vim.keymap.set('n', '<BS>', '<cmd>nohlsearch<CR>')

-- Insert date/time for work log
local function log_date() vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes([[G$"=strftime("\n\n# %F\n\n- %T ")<CR>pGA]], true, false, true), 'n', false) end
local function log_time() vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes([[G$"=strftime("\n- %T ")<CR>pGA]], true, false, true), 'n', false) end
vim.keymap.set({'n','i'}, '<F5>', function() vim.cmd('stopinsert'); log_date() end)
vim.keymap.set({'n','i'}, '<F6>', function() vim.cmd('stopinsert'); log_time() end)

-- ===== Navigation =====
-- Buffers (note: <C-H> may be eaten by terminals/backspace; change if needed)
vim.keymap.set('n', '<C-H>', '<cmd>bprevious!<CR>')
vim.keymap.set('n', '<C-L>', '<cmd>bnext!<CR>')

-- Tabs
vim.keymap.set('n', '<C-G>', '<cmd>tabprevious<CR>')
vim.keymap.set('n', '<C-M>', '<cmd>tabnext<CR>')  -- <C-M> == Enter in some terms; adjust if it conflicts

-- Close buffer but keep window
vim.keymap.set('n', ',d', '<cmd>bn | bd#<CR>')

-- Toggle file tree (will point to NERDTree/nvim-tree later)
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

-- ===== LSP-ready replacements for old YCM maps =====
-- (These will work once we enable LSP; safe to keep now.)
-- Dumb s/R under cursor (kept as-is)
vim.keymap.set('n', '<F1>', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>]], { noremap=true })

vim.keymap.set('n', '<F2>', vim.lsp.buf.rename)
vim.keymap.set('n', 'gh', vim.lsp.buf.rename)
vim.keymap.set('n', 'ù',  vim.lsp.buf.definition)
vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition)
vim.keymap.set('n', 'g?', vim.lsp.buf.hover)
vim.keymap.set('n', 'gi', vim.lsp.buf.incoming_calls)
vim.keymap.set('n', 'gj', vim.lsp.buf.code_action)
-- Jump back
vim.keymap.set('n', '!', '<C-t>')

-- ===== Spelling =====
vim.opt.spell = true
vim.opt.spelllang:append("cjk")
vim.opt.spelloptions = "camel"

-- ===== Listchars / wrapping / ruler =====
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

-- ===== Title & optional tmux rename =====
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

-- ===== Filetype tweaks =====
-- Treat *.js as TypeScript syntax with JS highl.
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

-- ===== Markdown / TeX =====
vim.g.markdown_fenced_languages = {
  "c", "css", "javascript", "js=javascript", "json=javascript",
  "html", "python",
}
vim.g["pandoc#syntax#codeblocks#embeds#langs"] = { "json=javascript", "ruby", "python", "bash=sh" }
vim.g.tex_flavor = "latex"

-- ===== Syntax sync for large files =====
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*",
  command = "syntax sync fromstart",
})

vim.opt.number = true

-- ===== Indent settings =====
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
-- Match your old python.vim indent knobs
vim.g.pyindent_open_paren = "&sw"
vim.g.pyindent_nested_paren = "&sw"
vim.g.pyindent_continue = "&sw"

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

-- nvim-cmp
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
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

vim.keymap.set("n", "<leader>c", "gcc", { remap = true })
vim.keymap.set("v", "<leader>c", "gc", { remap = true })

local gs = require("gitsigns")
gs.setup()
vim.keymap.set("n", "]h", gs.next_hunk)
vim.keymap.set("n", "[h", gs.prev_hunk)
vim.keymap.set("n", ")h", gs.next_hunk)
vim.keymap.set("n", "(h", gs.prev_hunk)
vim.keymap.set("n", "<leader>hp", gs.preview_hunk)
vim.keymap.set("n", "<leader>hs", gs.stage_hunk)
vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk)


-- Diagnostics
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  severity_sort = true,
})
vim.keymap.set("n", ")d", vim.diagnostic.goto_next)
vim.keymap.set("n", "(d", vim.diagnostic.goto_prev)

-- quick peek diagnostics under cursor (same feel as YCM popups)
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { silent = true })

-- unimpaired equivalent
for _, m in ipairs({ 'n','o','x' }) do
  vim.keymap.set(m, '(', '[')
  vim.keymap.set(m, ')', ']')
end

-- Fugitive
vim.keymap.set('n', 'gb', '<cmd>Git blame<CR>')
