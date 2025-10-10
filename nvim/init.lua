vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])

vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.winborder = "rounded"
vim.opt.smartindent = true
-- things to read up 
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.termguicolors = true
vim.opt.undofile = true
-- things to do: 
-- tabstop, signcolumn, showtabline, 

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here
		{ "alljokecake/naysayer-theme.nvim" },
		{ "nvim-telescope/telescope.nvim" },
		{ "LinArcX/telescope-env.nvim" },
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "chentoast/marks.nvim" },
		{ "stevearc/oil.nvim" },
		{ "nvim-tree/nvim-web-devicons" },
		{ "aznhe21/actions-preview.nvim" },
		{ "nvim-treesitter/nvim-treesitter" },
		{ "nvim-lua/plenary.nvim" },
		{ "chomosuke/typst-preview.nvim" },
		{ "neovim/nvim-lspconfig" },
		{ "mason-org/mason.nvim" },
		{ "L3MON4D3/LuaSnip" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "naysayer" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

require "marks".setup {
	builtin_marks = { "<", ">", "^" },
	refresh_interval = 250,
	sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
	excluded_filetypes = {},
	excluded_buftypes = {},
	mappings = {}
}

-- colorscheme
require "naysayer".setup({transparent = false })
local default_color = "naysayer"
vim.cmd('colorscheme ' .. default_color) 

require "mason".setup()
require "telescope".setup({                                                               
     defaults = {                                                                      
                 color_devicons = true,                                                    
                  sorting_strategy = "ascending",                                           
                  borderchars = { "", "", "", "", "", "", "", "" },                         
                   path_displays = "smart",                                                  
                   layout_strategy = "horizontal",                                           
                   layout_config = {                                                         
                           height = 100,                                                     
                           width = 400,                                                      
                           prompt_position = "top",                                          
                           preview_cutoff = 40,                                              
                   }                                                                         
           }                                                                                 
})      
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})
vim.cmd [[set completeopt+=menuone,noselect,popup]]

require("actions-preview").setup {
	backend = { "telescope" },
	extensions = { "env" },
	telescope = vim.tbl_extend(
		"force",
		require("telescope.themes").get_dropdown(), {}
	)
}

vim.lsp.enable({
	"lua_ls", "cssls", "svelte", "tinymist",
	"rust_analyzer", "clangd", "ruff",
	"glsl_analyzer", "haskell-language-server", "hlint",
	"intelephense", "biome", "tailwindcss",
	"ts_ls", "emmet_language_server"
})

require("oil").setup({
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
		autosave_changes = true,
	},
	columns = {
		"permissions",
		"icon",
	},
	float = {
		max_width = 0.7,
		max_height = 0.6,
		border = "rounded",
	},
})

require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })

local ls = require("luasnip")
local builtin = require("telescope.builtin")
local map = vim.keymap.set
local current = 1

-- mappings
map('n', '<leader>dl', vim.diagnostic.open_float, { desc = "Show diagnostic" })
map('n', '<leader>dq', vim.diagnostic.setloclist, { desc = "Diagnostics list" })
map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "System clipboard yank." })
map({ "n" }, "<leader>f", builtin.find_files, { desc = "Telescope live grep" })
map({ "n" }, "<leader>g", builtin.live_grep, { desc = "Telescope live grep" })
map({ "n" }, "<leader>si", builtin.grep_string, { desc = "Telescope live string" })
map({ "n" }, "<leader>sr", builtin.oldfiles, { desc = "Telescope buffers" })
map({ "n" }, "<leader>b", builtin.buffers, { desc = "Telescope buffers" })
map({ "n" }, "<leader>sh", builtin.help_tags, { desc = "Telescope help tags" })
map({ "n" }, "<leader>sm", builtin.man_pages, { desc = "Telescope man pages" })
map({ "n" }, "<leader>sr", builtin.lsp_references, { desc = "Telescope tags" })
map({ "n" }, "<leader>st", builtin.builtin, { desc = "Telescope tags" })
map({ "n" }, "<leader>sd", builtin.registers, { desc = "Telescope tags" })
map({ "n" }, "<leader>sc", builtin.colorscheme, { desc = "Telescope tags" })
map({ "n" }, "<leader>se", "<cmd>Telescope env<cr>", { desc = "Telescope tags" })
map({ "n" }, "<leader>sa", require("actions-preview").code_actions)
map({ "n" }, "<leader>e", "<cmd>Oil<CR>")
