vim.g.mapleader = ' '



vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.opt.number = true
--vim.opt.relativenumber = true

vim.opt.mouse = "a"

--vim.opt.showmode = false

vim.schedule(function() 
	vim.opt.clipboard = "unnamedplus"
end
)

vim.opt.breakindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"

vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = false

vim.opt.list = true
vim.opt.listchars = { tab = '>> ', trail = '.' , nbsp = '␣'}

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.inccommand = 'split'

vim.opt.cursorline = true
vim.opt.scrolloff = 6


vim.keymap.set('n' , '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n' , '<leader>q' , vim.diagnostic.setloclist , {desc = 'Open diagnostic [Q]uickfix list'}) 

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
--vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })


--move windows
vim.keymap.set('n' , '<C-h>' , '<C-w><C-h>' , {desc = 'Move focus to the left window'})

vim.keymap.set('n' , '<C-j>' , '<C-w><C-j>' , {desc = 'Move focus to the up window'})

vim.keymap.set('n' , '<C-k>' , '<C-w><C-k>' , {desc = 'Move focus to the down window'})

vim.keymap.set('n' , '<C-l>' , '<C-w><C-l>' , {desc = 'Move focus to the right window'})

-- autocmd group first highlight on yank

vim.api.nvim_create_autocmd('TextYankPost' , {
	desc = 'Highlight when Yanking a text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank' , {clear = true}),
	callback = function() 
		vim.highlight.on_yank()
	end
})


-- install lazy package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
	local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
	if vim.v.shell_error ~= 0 then
		error('Error cloning lazy.nvim:\n' .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)


-- setup lazy
require('lazy').setup({
	'tpope/vim-sleuth',
	{
		'lewis6991/gitsigns.nvim',
		opts = {
			signs = {
				add          = { text = '+' },
				change       = { text = '~' },
				delete       = { text = '_' },
				topdelete    = { text = '‾' },
				changedelete = { text = '~' },
				untracked    = { text = '┆' },
			},
		}
	},

	{
		-- Useful plugin to show you pending keybinds.
		'folke/which-key.nvim',
		event = 'VimEnter', -- Sets the loading event to 'VimEnter'
		opts = {
			-- delay between pressing a key and opening which-key (milliseconds)
			-- this setting is independent of vim.opt.timeoutlen
			delay = 50,
			icons = {
				-- set icon mappings to true if you have a Nerd Font
				mappings = vim.g.have_nerd_font,
				-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
				-- default which-key.nvim defined Nerd Font icons, otherwise define a string table
				keys = vim.g.have_nerd_font and {} or {
					Up = '<Up> ',
					Down = '<Down> ',
					Left = '<Left> ',
					Right = '<Right> ',
					C = '<C-…> ',
					M = '<M-…> ',
					D = '<D-…> ',
					S = '<S-…> ',
					CR = '<CR> ',
					Esc = '<Esc> ',
					ScrollWheelDown = '<ScrollWheelDown> ',
					ScrollWheelUp = '<ScrollWheelUp> ',
					NL = '<NL> ',
					BS = '<BS> ',
					Space = '<Space> ',
					Tab = '<Tab> ',
					F1 = '<F1>',
					F2 = '<F2>',
					F3 = '<F3>',
					F4 = '<F4>',
					F5 = '<F5>',
					F6 = '<F6>',
					F7 = '<F7>',
					F8 = '<F8>',
					F9 = '<F9>',
					F10 = '<F10>',
					F11 = '<F11>',
					F12 = '<F12>',
				},
			},

			-- Document existing key chains
			spec = {
				{ '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
				{ '<leader>d', group = '[D]ocument' },
				{ '<leader>r', group = '[R]ename' },
				{ '<leader>s', group = '[S]earch' },
				{ '<leader>w', group = '[W]orkspace' },
				{ '<leader>t', group = '[T]oggle' },
				{ '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
			},
		},
	},
	{
		-- Fuzzy Finder (files, lsp, etc)
		'nvim-telescope/telescope.nvim',
		event = 'VimEnter',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{
				'nvim-telescope/telescope-fzf-native.nvim',

				build = 'make',
				cond = function()
					return vim.fn.executable 'make' == 1
				end,
			},

			'nvim-telescope/telescope-ui-select.nvim',

			{ 'nvim-tree/nvim-web-devicons',
			enabled = vim.g.have_nerd_font
		} 
	},

	config = function() 
		require('telescope').setup {
			extentions = {
				['ui-select'] = {
					require('telescope.themes').get_dropdown()
				}
			}
		}
		pcall(require('telescope').load_extention , 'fzf')
		pcall(require('telescope').load_extention , 'ui-select')


		local builtin = require 'telescope.builtin'
		vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
		vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
		vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
		vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
		vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch Current [W]ord' })
		vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep'})
		vim.keymap.set('n', '<leader>sd', builtin.diagnostics , { desc = '[S]earch [D]iagnostics'})
		vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume}'})
		vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[] Find existing buffers}'})

		vim.keymap.set('n' , '<leader>/' , function() 

			builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown{
				winblend = 10,
				previewer = false
			})

		end , {desc = '[/] Fuzzily search in current buffer'})

		-- search neovim 
		vim.keymap.set('n', '<leader>s/' , function() 
			builtin.live_grep {
				grep_open_files= true,
				prompt_title = 'Live grep in open files'
			} 
		end, { desc =  '[S]earch [/] in Open Files'})

		-- Search neovim config files
		vim.keymap.set('n', '<leader>sn' , function() 
			builtin.find_files {
				cwd = vim.fn.stdpath 'config'
			} end, { desc =  '[S]earch [/] in Open Files'})
		end,
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		'folke/lazydev.nvim',
		ft = 'lua',
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = '${3rd}/luv/library', words = { 'vim%.uv' } },
			},
		},
	},
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{ 'williamboman/mason.nvim' , opts = {}},
			'williamboman/mason-lspconfig.nvim',
			'WhoIsSethDaniel/mason-tool-installer.nvim',
			{ 'j-hui/fidget.nvim', opts = {} },

			--'hrsh7th/nvim-cmp',
			'hrsh7th/cmp-nvim-lsp'

		},

		config = function() 
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or 'n'
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
					end

					map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
					map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
					map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

					map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
					map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
					map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
					map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

					-- Code Actions
					map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
					map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

					    ---@param client vim.lsp.Client
					  ---@param method vim.lsp.protocol.Method
					  ---@param bufnr? integer some lsp support methods only in specific files
					  ---@return boolean
					  local function client_supports_method(client, method, bufnr)
					    if vim.fn.has 'nvim-0.11' == 1 then
					      return client:supports_method(method, bufnr)
					    else
					      return client.supports_method(method, { bufnr = bufnr })
					    end
					 end


				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
						local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
					vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})
					 vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
					      buffer = event.buf,
					      group = highlight_augroup,
					      callback = vim.lsp.buf.clear_references,
					})
					vim.api.nvim_create_autocmd('LspDetach', {
					  group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
					  callback = function(event2)
						   vim.lsp.buf.clear_references()
						   vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
					  end,
				    })
			    end
			 if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
			    map('<leader>th', function()
			      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
			    end, '[T]oggle Inlay [H]ints')
			  end
			end
			})

		 -- Diagnostic Config
		      -- See :help vim.diagnostic.Opts
		      vim.diagnostic.config {
			severity_sort = true,
			float = { border = 'rounded', source = 'if_many' },
			underline = { severity = vim.diagnostic.severity.ERROR },
			signs = vim.g.have_nerd_font and {
			  text = {
			    [vim.diagnostic.severity.ERROR] = '󰅚 ',
			    [vim.diagnostic.severity.WARN] = '󰀪 ',
			    [vim.diagnostic.severity.INFO] = '󰋽 ',
			    [vim.diagnostic.severity.HINT] = '󰌶 ',
			  },
			} or {},
			virtual_text = {
			  source = 'if_many',
			  spacing = 2,
			  format = function(diagnostic)
			    local diagnostic_message = {
			      [vim.diagnostic.severity.ERROR] = diagnostic.message,
			      [vim.diagnostic.severity.WARN] = diagnostic.message,
			      [vim.diagnostic.severity.INFO] = diagnostic.message,
			      [vim.diagnostic.severity.HINT] = diagnostic.message,
			    }
			    return diagnostic_message[diagnostic.severity]
			  end,
			},
		      }


		  -- LSP servers and clients are able to communicate to each other what features they support.
		      --  By default, Neovim doesn't support everything that is in the LSP specification.
		      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
		      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
		      local capabilities = vim.lsp.protocol.make_client_capabilities()
		      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
		      

			
			local servers = {
				lua_ls = {
					settings = {
						Lua  = {
							completion = {
								callSnippet = 'Replace'
							}
						}
					}
				},
				--angularls = {}
			}
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				'stylua', -- Used to format Lua code
			})
			require('mason-tool-installer').setup { ensure_installed = ensure_installed }
			require('mason-lspconfig').setup {
				ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
				automatic_installation = false,
				handlers = {
				  function(server_name)
				    local server = servers[server_name] or {}
				    -- This handles overriding only values explicitly passed
				    -- by the server configuration above. Useful when disabling
				    -- certain features of an LSP (for example, turning off formatting for ts_ls)
				    server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
				    require('lspconfig')[server_name].setup(server)
				  end,
				},
			      }
		end
	},
	 { -- You can easily change to a different colorscheme.
	    -- Change the name of the colorscheme plugin below, and then
	    -- change the command in the config to whatever the name of that colorscheme is.
	    --
	    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
	    'folke/tokyonight.nvim',
	    enabled = false,
	    priority = 1000, -- Make sure to load this before all the other start plugins.
	    config = function()
	      ---@diagnostic disable-next-line: missing-fields
	      require('tokyonight').setup {
		styles = {
		  comments = { italic = false }, -- Disable italics in comments
		},
	      }

	      -- Load the colorscheme here.
	      -- Like many other themes, this one has different styles, and you could load
	      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
	      vim.cmd.colorscheme 'tokyonight-storm'
	    end,
	  },
	{ "rose-pine/neovim", name = "rose-pine"  },
	{'sainnhe/everforest' ,
		priority = 1000,
		config = function()
			vim.g.everforest_enable_italic = true
			vim.cmd.colorscheme 'everforest'
	end

	},
	{
	 'hrsh7th/nvim-cmp',
	 event = 'InsertEnter',
	 dependencies = {
		'L3MON4D3/LuaSnip',
		 version = 'v2.*',
		 build = 'make install_jsregexp',
		opts = {},
		  -- Build Step is needed for regex support in snippets.
		  -- This step is not supported in many windows environments.
		  -- Remove the below condition to re-enable on windows.
		  --if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
		   -- return
		  --end
		 dependencies = {
		  -- `friendly-snippets` contains a variety of premade snippets.
		  --    See the README about individual language/framework/plugin snippets:
		  --    https://github.com/rafamadriz/friendly-snippets
		   {
		     'rafamadriz/friendly-snippets',
		     config = function()
		       require('luasnip.loaders.from_vscode').lazy_load()
		     end,
		   },
		},
		'saadparwaiz1/cmp_luasnip',
		 -- Adds other completion capabilities.
		 --  nvim-cmp does not ship with all sources by default. They are split
		 --  into multiple repos for maintenance purposes.
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-path',
		'hrsh7th/cmp-nvim-lsp-signature-help',
	},
	 config = function()
	  local cmp = require 'cmp'
	  local luasnip = require 'luasnip'
	  luasnip.config.setup {}

	  cmp.setup {
	    snippet = {
		expand = function(args)
		    luasnip.lsp_expand(args.body)
		end,
	  },
	  completion = { completeopt = 'menu,menuone,noinsert'},
	  mapping = cmp.mapping.preset.insert {
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		--
		 -- Accept ([y]es) the completion.
		 --  This will auto-import if your LSP supports it.
		 --  This will expand snippets if the LSP sent a snippet.
		['<CR>'] = cmp.mapping.confirm { select = true },
		['<C-Space>'] = cmp.mapping.complete {},

		['<C-l>'] = cmp.mapping(function()
		  if luasnip.expand_or_locally_jumpable() then
		    luasnip.expand_or_jump()
		  end
		end, { 'i', 's' }),
		['<C-h>'] = cmp.mapping(function()
		  if luasnip.locally_jumpable(-1) then
		    luasnip.jump(-1)
		  end
		end, { 'i', 's' }),
		},
		sources = {
		 {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'nvim_lsp_signature_help' },
		  { name = 'hrsh7th/cmp-cmdline' },
		  { name = 'Jezda1337/nvim-html-css' },
		  { name = 'cmp-scss'},
		  { name = 'roginfarrer/cmp-css-variables'},
        },
	}
	 end
	},
	{
		'echasnovski/mini.nvim',
		config = function ()
			require('mini.ai').setup { n_lines = 500 }
			require('mini.surround').setup()
			local statusline = require 'mini.statusline'
			statusline.setup {
				use_icons = vim.g.have_nerd_font,
				content = {
					active = function()
						local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
						local git           = MiniStatusline.section_git({ trunc_width = 40 })
						local diff          = MiniStatusline.section_diff({ trunc_width = 75 })
						local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
						local lsp           = MiniStatusline.section_lsp({ trunc_width = 75 })
						local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
						local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
						local location      = MiniStatusline.section_location({ trunc_width = 75 })
						local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })

						return MiniStatusline.combine_groups({
						  { hl = mode_hl,                  strings = { mode } },
						  { hl = 'MiniStatuslineDevinfo',  strings = { git, diff, diagnostics, lsp } },
						  '%<', -- Mark general truncate point
						  { hl = 'MiniStatuslineFilename', strings = { filename } },
						  '%=', -- End left alignment
						  { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
						})
					end

				}	
			}
		end
		}
	})



