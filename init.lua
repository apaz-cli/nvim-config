--[[
====================================================================
====================== APAZ-CLI's NVIM CONFIG ======================
====================================================================

# TODO:
  - Fix up and down arrows
  - Investigate why tab behaves as it does
  - Search and replace
  - petertriho/nvim-scrollbar -> dstein64/nvim-scrollview
  - Cursor jumps back when changing modes


--]]


-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Dev icons
  'ryanoasis/vim-devicons',

  -- Markdown synhi
  'plasticboy/vim-markdown',

  -- PEG synhi
  'taeber/vim-peg',

  -- AI Autocompletion
  'Exafunction/codeium.vim',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
    },
  },

  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },

  {
    "loctvl842/monokai-pro.nvim",
    priority = 1000,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'monokai-pro',
        component_separators = '',
        section_separators = '',
        disabled_filetypes = {
          'NvimTree'
        },
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'os.date("%H:%M", os.time())'},
        lualine_z = {'progress', 'location'},
      }
    },
  },

  {
    -- Scrollbar
    'petertriho/nvim-scrollbar',
    opts = {
      hide_if_all_visible = true,
      throttle_ms = 1000,
      handle = { color = '#403e41' },
      marks = {
        Cursor = {
          color = '#ffd866',
          text = '*',
          gui = 'bold',
        },
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    main = "ibl",
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  {
    -- Top bars
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      animation = false,
      sidebar_filetypes = {
        ['neo-tree'] = {event = 'BufWipeout'},
      }
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
  },

  {
    -- File tree
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
  },
}
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- [[ My custom stuff ]]

-- Stay in insert mode
-- vim.cmd 'autocmd BufEnter * startinsert'

-- Block cursor in insert mode
vim.opt["guicursor"] = ""

-- Allow cursor to move one past the end of the line
vim.cmd 'set virtualedit=onemore'
vim.api.nvim_set_keymap('n', '<end>', '$1l', { noremap = true, silent = true })

-- Don't scroll when moving past the end of the file
-- vim.cmd 'set scrolloff=1000'
-- vim.o.display = "lastline"

-- Disable folding everywhere
vim.cmd 'set nofoldenable'

-- Trigger rerender of status line every 5 seconds for clock
if _G.Statusline_timer == nil then _G.Statusline_timer = vim.loop.new_timer() else _G.Statusline_timer:stop() end
_G.Statusline_timer:start(0, 5000, vim.schedule_wrap( function() vim.api.nvim_command('redrawstatus') end))

-- Turn off lualine inside nvim-tree
vim.cmd [[
  au BufEnter,BufWinEnter,WinEnter,CmdwinEnter * if bufname('%') == "NvimTree" | set laststatus=0 | else | set laststatus=2 | endif
]]

-- Highlight trailing whitespace
-- vim.cmd 'match errorMsg /\s\+$/'
vim.cmd([[
highlight TrailingWhitespace guibg=lightgreen guifg=white
autocmd BufReadPost,BufNewFile,TextChanged,TextChangedI * match TrailingWhitespace /\s\+$/
autocmd InsertEnter * match TrailingWhitespace /\s\+\%#\@<!$/
"autocmd InsertLeave * match TrailingWhitespace /\s\+$/
"autocmd BufWritePre * %s/\s\+$//e
]])


local keymap_all = function(keybind, cmd)
  cmd = cmd:sub(1, 1) == ':' and cmd .. '<CR>' or cmd
  vim.api.nvim_set_keymap('i', keybind, '<C-o>' .. cmd, { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', keybind,            cmd, { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', keybind,            cmd, { noremap = true, silent = true })
end

local hotkey_all = function(key, cmd)
  keymap_all('<C-' .. key .. '>', cmd)
  keymap_all('<C-S-' .. key .. '>', cmd)
end

-- Ctrl + s to save
vim.cmd([[
function! CustomSave()
  " Check if buffer has a name
  if expand('%') == ""
    " Ask for a filename
    let l:filename = input('Save as: ')
    if l:filename != ""
      " Write the file with the given name
      execute 'write ' . l:filename
    endif
  else
    write
  endif
endfunction
]])
hotkey_all('s', ':call CustomSave()')

-- Ctrl + x to quit
vim.cmd([[
function! CustomSaveAndQuit()
  " Check if the buffer has changes
  if &modified
    " Ask the user if they want to save the changes
    let l:choice = confirm("Buffer has been modified. Do you want to save changes?", "&Yes\n&No\n&Cancel")
    if l:choice == 1
      call CustomSave()
    elseif l:choice == 3
      return
    endif
  endif
  quit!
endfunction
]])
hotkey_all('x', ':call CustomSaveAndQuit()')

-- Ctrl + k to cut the current line
-- Ctrl + u to paste the lines
hotkey_all('k', '"+dd')
hotkey_all('u', '"+P')

-- Ctrl + c to copy
-- Ctrl + v to paste
hotkey_all('c', '"+y')
hotkey_all('v', '"+p')

-- Ctrl + w to search
_G.last_jump_search = ''
function SearchForString()
  local search_string = vim.fn.input('Jump to: ')
  if search_string == '' then search_string = _G.last_jump_search end
  _G.last_jump_search = search_string

  local ig = vim.o.ignorecase
  vim.o.ignorecase = true
  vim.cmd('call search("' .. search_string .. '", "w")')
  vim.o.ignorecase = ig
end
hotkey_all('w', ':lua SearchForString()')


-- Jump up/down
vim.cmd([[
function! MoveToNextBlock()
    let l:wrapscan_original = &wrapscan
    set nowrapscan

    " Escape into whitespace.
    "silent! execute "normal! /^\\s*$\\|\%^|^$\<CR>"

    "call search('^\s+(^.*\S.*$)+', 'zWe')
    "call search('^\\s+(^.*\\S.*$)+', 'We')
    "silent! execute "normal! /^\\s+(^.*\\S.*$)+\<CR>"

    " Move cursor to beginning of line
    silent! execute "normal! }j^"

    let &wrapscan = l:wrapscan_original
endfunction
]])

vim.cmd([[
function! MoveToPreviousBlock()
    let l:wrapscan_original = &wrapscan
    set nowrapscan

    " Escape into whitespace.
    if !(getline('.') =~ '^\\s*$' || getline('.') == '')
        silent! execute "normal! ?^\\s*$\\|\%^|^$\<CR>"
    endif

    " Search for the last line of the previous code block by advancing through the whitespace.
    silent! execute "normal! ?^.*\\s*$\\|\%^|^$\<CR>"

    " Advance past the rest of the lines.
    while getline('.') =~ '^\\S*$' || getline('.') == ''
        silent! execute "normal! k"
        if getpos(".")[1] == 1
            break
        endif
    endwhile

    " Keep searching until another whitespace line is found (start of block)
    silent! execute "normal! ?^\\s*$\\|^$\<CR>"

    " If not at the top of the file, go down one line.
    if getpos(".")[1] != 1
        silent! execute "normal! j^"
    endif
endfunction
]])

vim.api.nvim_set_keymap('n', '<C-Down>', ':call MoveToNextBlock()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Up>', ':call MoveToPreviousBlock()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-Down>', '<C-o>:call MoveToNextBlock()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-Up>', '<C-o>:call MoveToPreviousBlock()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-Down>', ':call MoveToNextBlock()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-Up>', ':call MoveToPreviousBlock()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-S-Down>', ':call MoveToNextBlock()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-S-Up>', ':call MoveToPreviousBlock()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-S-Down>', '<C-o>:call MoveToNextBlock()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-S-Up>', '<C-o>:call MoveToPreviousBlock()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-S-Down>', ':call MoveToNextBlock()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-S-Up>', ':call MoveToPreviousBlock()<CR>', { noremap = true, silent = true })

-- Shift plus arrow keys selects text
vim.api.nvim_set_keymap('n', '<S-Right>', 'v<Right>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Left>', 'v<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Up>', 'v<Up>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Down>', 'v<Down>', { noremap = true, silent = true })


-- Configure indent-blankline

local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

local iblhooks = require "ibl.hooks"
iblhooks.register(iblhooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

require("ibl").setup {
  indent = { highlight = highlight, char = "" },
  scope = { enabled = false },
}


-- [[ Kickstart Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim' },
  ignore_install = {},
  modules = {},
  sync_install = false,

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  clangd = {},
  -- gopls = {},
  pyright = {},
  rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Set up color scheme
require('monokai-pro').setup()
vim.cmd([[colorscheme monokai-pro]])

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
capabilities.textDocument.publishDiagnostics = {tagSupport = {valueSet = { 2 }, }, }

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
