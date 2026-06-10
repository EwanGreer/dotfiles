do
  vim.loader.enable()

  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  vim.g.have_nerd_font = true

  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.mouse = 'a'
  vim.o.showmode = false
  vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
  vim.o.breakindent = true

  vim.o.tabstop = 4
  vim.o.shiftwidth = 4
  vim.o.softtabstop = 4
  vim.o.expandtab = true

  vim.o.undofile = true
  vim.o.ignorecase = true
  vim.o.smartcase = true
  vim.o.signcolumn = 'yes'
  vim.o.updatetime = 250
  vim.o.timeoutlen = 300
  vim.o.splitright = true
  vim.o.splitbelow = true
  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
  vim.o.inccommand = 'split'
  vim.o.cursorline = true
  vim.o.scrolloff = 10
  vim.o.confirm = true

  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    virtual_text = true,
    virtual_lines = false,
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float {
          bufnr = bufnr,
          scope = 'cursor',
          focus = false,
        }
      end,
    },
  }

  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- Window navigation handled by tmux-navigator plugin (see kickstart.plugins.tmux-navigator)

  -- Buffer navigation
  vim.keymap.set('n', '<S-h>', '<cmd>bprevious<CR>', { desc = 'Prev buffer' })
  vim.keymap.set('n', '<S-l>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
  vim.keymap.set('n', '[b', '<cmd>bprevious<CR>', { desc = 'Prev buffer' })
  vim.keymap.set('n', ']b', '<cmd>bnext<CR>', { desc = 'Next buffer' })
  vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = '[B]uffer [D]elete' })
  vim.keymap.set('n', '<leader>bo', '<cmd>%bdelete|edit#|bdelete#<CR>', { desc = '[B]uffer delete [O]thers' })

  -- Move lines up/down
  vim.keymap.set('n', '<A-j>', '<cmd>execute "move .+1"<CR>==', { desc = 'Move line down' })
  vim.keymap.set('n', '<A-k>', '<cmd>execute "move .-2"<CR>==', { desc = 'Move line up' })
  vim.keymap.set('i', '<A-j>', '<Esc><cmd>execute "move .+1"<CR>==gi', { desc = 'Move line down' })
  vim.keymap.set('i', '<A-k>', '<Esc><cmd>execute "move .-2"<CR>==gi', { desc = 'Move line up' })
  vim.keymap.set('v', '<A-j>', ":move '>+1<CR>gv=gv", { desc = 'Move selection down' })
  vim.keymap.set('v', '<A-k>', ":move '<-2<CR>gv=gv", { desc = 'Move selection up' })

  -- Resize splits with Ctrl+Arrow
  vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<CR>', { desc = 'Increase window height' })
  vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<CR>', { desc = 'Decrease window height' })
  vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<CR>', { desc = 'Decrease window width' })
  vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<CR>', { desc = 'Increase window width' })

  -- Smarter n/N: always search forward with n, backward with N
  vim.keymap.set('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next search result' })
  vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
  vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
  vim.keymap.set('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev search result' })
  vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
  vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })

  -- Don't clobber register on visual paste
  vim.keymap.set('x', 'p', '"_dP', { desc = 'Paste without clobbering register' })

  -- Quickfix navigation
  vim.keymap.set('n', '[q', '<cmd>cprev<CR>', { desc = 'Prev quickfix item' })
  vim.keymap.set('n', ']q', '<cmd>cnext<CR>', { desc = 'Next quickfix item' })
  vim.keymap.set('n', '[Q', '<cmd>cfirst<CR>', { desc = 'First quickfix item' })
  vim.keymap.set('n', ']Q', '<cmd>clast<CR>', { desc = 'Last quickfix item' })

  -- Better up/down on wrapped lines
  vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = 'Down' })
  vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = 'Up' })

  -- Save file
  vim.keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })

  -- Better indenting (reselect after indent)
  vim.keymap.set('x', '<', '<gv')
  vim.keymap.set('x', '>', '>gv')

  -- Add undo break-points
  vim.keymap.set('i', ',', ',<c-g>u')
  vim.keymap.set('i', '.', '.<c-g>u')
  vim.keymap.set('i', ';', ';<c-g>u')

  -- Commenting
  vim.keymap.set('n', 'gco', 'o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Below' })
  vim.keymap.set('n', 'gcO', 'O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Above' })

  -- Buffers
  vim.keymap.set('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
  vim.keymap.set('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })

  -- Diagnostics
  vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
  vim.keymap.set('n', ']d', function() vim.diagnostic.jump { count = 1, float = true } end, { desc = 'Next Diagnostic' })
  vim.keymap.set('n', '[d', function() vim.diagnostic.jump { count = -1, float = true } end, { desc = 'Prev Diagnostic' })
  vim.keymap.set('n', ']e', function() vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR, float = true } end, { desc = 'Next Error' })
  vim.keymap.set('n', '[e', function() vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR, float = true } end, { desc = 'Prev Error' })
  vim.keymap.set('n', ']w', function() vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.WARN, float = true } end, { desc = 'Next Warning' })
  vim.keymap.set('n', '[w', function() vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.WARN, float = true } end, { desc = 'Prev Warning' })

  -- Windows
  vim.keymap.set('n', '<leader>-', '<C-W>s', { desc = 'Split Window Below', remap = true })
  vim.keymap.set('n', '<leader>|', '<C-W>v', { desc = 'Split Window Right', remap = true })
  vim.keymap.set('n', '<leader>wd', '<C-W>c', { desc = 'Delete Window', remap = true })

  -- Floating terminal
  vim.keymap.set({ 'n', 't' }, '<c-/>', function()
    vim.cmd 'botright split | terminal'
  end, { desc = 'Terminal' })

  -- New file
  vim.keymap.set('n', '<leader>fn', '<cmd>enew<cr>', { desc = 'New File' })

  -- Quit
  vim.keymap.set('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit All' })

  -- Tabs
  vim.keymap.set('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New Tab' })
  vim.keymap.set('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
  vim.keymap.set('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
  vim.keymap.set('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })
  vim.keymap.set('n', '<leader><tab>o', '<cmd>tabonly<cr>', { desc = 'Close Other Tabs' })
  vim.keymap.set('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
  vim.keymap.set('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last Tab' })

  -- Keywordprg
  vim.keymap.set('n', '<leader>K', '<cmd>norm! K<cr>', { desc = 'Keywordprg' })

  -- UI Toggles (<leader>u prefix)
  vim.keymap.set('n', '<leader>uw', '<cmd>set wrap!<CR>', { desc = 'Toggle Wrap' })
  vim.keymap.set('n', '<leader>ul', '<cmd>set number!<CR>', { desc = 'Toggle Line Numbers' })
  vim.keymap.set('n', '<leader>uL', '<cmd>set relativenumber!<CR>', { desc = 'Toggle Relative Numbers' })
  vim.keymap.set('n', '<leader>us', '<cmd>set spell!<CR>', { desc = 'Toggle Spelling' })
  vim.keymap.set('n', '<leader>ud', function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  end, { desc = 'Toggle Diagnostics' })
  vim.keymap.set('n', '<leader>uc', function()
    vim.o.conceallevel = vim.o.conceallevel == 0 and 2 or 0
  end, { desc = 'Toggle Conceal' })
  vim.keymap.set('n', '<leader>uf', function()
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    vim.notify('Auto-format ' .. (vim.g.disable_autoformat and 'disabled' or 'enabled'))
  end, { desc = 'Toggle Auto-format' })
  vim.keymap.set('n', '<leader>uF', function()
    vim.b.disable_autoformat = not vim.b.disable_autoformat
    vim.notify('Buffer auto-format ' .. (vim.b.disable_autoformat and 'disabled' or 'enabled'))
  end, { desc = 'Toggle Auto-format (Buffer)' })
  vim.keymap.set('n', '<leader>uT', function()
    if vim.b.ts_highlight then
      vim.treesitter.stop()
    else
      vim.treesitter.start()
    end
  end, { desc = 'Toggle Treesitter Highlight' })
  vim.keymap.set('n', '<leader>uh', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, { desc = 'Toggle Inlay Hints' })
  vim.keymap.set('n', '<leader>ui', vim.show_pos, { desc = 'Inspect Pos' })
  vim.keymap.set('n', '<leader>ur', '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>', { desc = 'Redraw / Clear hlsearch' })

  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })

  vim.api.nvim_create_autocmd('BufReadPost', {
    desc = 'Restore cursor to last position',
    group = vim.api.nvim_create_augroup('kickstart-restore-cursor', { clear = true }),
    callback = function(args)
      local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
      local line_count = vim.api.nvim_buf_line_count(args.buf)
      if mark[1] > 0 and mark[1] <= line_count then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end,
  })

  vim.api.nvim_create_autocmd({ 'FocusLost', 'TermLeave' }, {
    desc = 'Auto-save on focus lost',
    group = vim.api.nvim_create_augroup('kickstart-auto-save', { clear = true }),
    command = 'silent! wall',
  })
end

-- ============================================================
-- SECTION 2: PLUGIN MANAGER INTRO
-- vim.pack intro, build hooks
-- ============================================================
do
  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local stderr = result.stderr or ''
      local stdout = result.stdout or ''
      local output = stderr ~= '' and stderr or stdout
      if output == '' then output = 'No output from build command.' end
      vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
    end
  end

  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= 'install' and kind ~= 'update' then return end

      if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
        run_build(name, { 'make' }, ev.data.path)
        return
      end

      if name == 'LuaSnip' then
        if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
        return
      end

      if name == 'nvim-treesitter' then
        if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
        vim.cmd 'TSUpdate'
        return
      end
    end,
  })
end

---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

-- ============================================================
-- SECTION 3: UI / CORE UX PLUGINS
-- guess-indent, gitsigns, which-key, colorscheme, todo-comments, mini modules
-- ============================================================
do
  vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {}

  if vim.g.have_nerd_font then vim.pack.add { gh 'nvim-tree/nvim-web-devicons' } end

  vim.pack.add { gh 'folke/which-key.nvim' }
  require('which-key').setup {
    delay = 300,
    icons = { mappings = vim.g.have_nerd_font },
    spec = {
      { '<leader>b', group = '[B]uffer' },
      { '<leader>d', group = '[D]ebug' },
      { '<leader>u', group = '[U]I Toggles' },
      { '<leader>x', group = 'Trouble' },
      { '<leader>q', group = 'Session' },
      { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
      { '<leader>t', group = '[T]est' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { '<leader>r', group = '[R]efactor', mode = { 'n', 'v' } },
      { 'gr', group = 'LSP Actions', mode = { 'n' } },
    },
  }

  vim.pack.add { gh 'navarasu/onedark.nvim' }
  require('onedark').setup {
    style = 'dark',
    code_style = {
      comments = 'none',
    },
  }
  require('onedark').load()

  vim.pack.add { gh 'folke/todo-comments.nvim' }
  require('todo-comments').setup { signs = false }

  vim.pack.add { gh 'nvim-mini/mini.nvim' }

  require('mini.ai').setup {
    -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
    mappings = {
      around_next = 'aa',
      inside_next = 'ii',
    },
    n_lines = 500,
  }

  require('mini.surround').setup()

  require('mini.tabline').setup()

  local statusline = require 'mini.statusline'
  statusline.setup { use_icons = vim.g.have_nerd_font }
  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_location = function() return '%2l:%-2v' end
end

-- ============================================================
-- SECTION 4: SEARCH & NAVIGATION
-- Telescope setup, keymaps, LSP picker mappings
-- ============================================================
do
  ---@type (string|vim.pack.Spec)[]
  local telescope_plugins = {
    gh 'nvim-lua/plenary.nvim',
    gh 'nvim-telescope/telescope.nvim',
    gh 'nvim-telescope/telescope-ui-select.nvim',
    gh 'nvim-telescope/telescope-live-grep-args.nvim',
  }
  if vim.fn.executable 'make' == 1 then table.insert(telescope_plugins, gh 'nvim-telescope/telescope-fzf-native.nvim') end

  vim.pack.add(telescope_plugins)

  require('telescope').setup {
    extensions = {
      ['ui-select'] = { require('telescope.themes').get_dropdown() },
      live_grep_args = {
        mappings = {
          i = {
            ['<C-k>'] = require('telescope-live-grep-args.actions').quote_prompt(),
            ['<C-i>'] = require('telescope-live-grep-args.actions').quote_prompt { postfix = ' --iglob ' },
          },
        },
      },
    },
  }

  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'ui-select')
  pcall(require('telescope').load_extension, 'live_grep_args')

  local builtin = require 'telescope.builtin'
  vim.keymap.set('n', '<leader><space>', builtin.find_files, { desc = 'Find Files' })
  vim.keymap.set('n', '<leader>,', builtin.buffers, { desc = 'Buffers' })
  vim.keymap.set('n', '<leader>:', builtin.command_history, { desc = 'Command History' })
  vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
  vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
  vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent' })
  vim.keymap.set('n', '<leader>fc', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = 'Find Config File' })
  vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = 'Find Files (git)' })
  local lga = require('telescope').extensions.live_grep_args
  vim.keymap.set('n', '<leader>sg', lga.live_grep_args, { desc = 'Grep (with args)' })
  vim.keymap.set({ 'n', 'x' }, '<leader>sw', builtin.grep_string, { desc = 'Grep Word' })
  vim.keymap.set('n', '<leader>sb', builtin.current_buffer_fuzzy_find, { desc = 'Buffer Lines' })
  vim.keymap.set('n', '<leader>sB', function() builtin.live_grep { grep_open_files = true } end, { desc = 'Grep Open Buffers' })
  vim.keymap.set('n', '<leader>sc', builtin.command_history, { desc = 'Command History' })
  vim.keymap.set('n', '<leader>sC', builtin.commands, { desc = 'Commands' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Diagnostics' })
  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Help Pages' })
  vim.keymap.set('n', '<leader>sH', builtin.highlights, { desc = 'Highlights' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Keymaps' })
  vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = 'Marks' })
  vim.keymap.set('n', '<leader>sR', builtin.resume, { desc = 'Resume' })
  vim.keymap.set('n', '<leader>sq', builtin.quickfix, { desc = 'Quickfix List' })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
    callback = function(event)
      local buf = event.buf
      vim.keymap.set('n', 'gd', builtin.lsp_definitions, { buffer = buf, desc = 'Goto Definition' })
      vim.keymap.set('n', 'gr', builtin.lsp_references, { buffer = buf, desc = 'References' })
      vim.keymap.set('n', 'gI', builtin.lsp_implementations, { buffer = buf, desc = 'Goto Implementation' })
      vim.keymap.set('n', 'gy', builtin.lsp_type_definitions, { buffer = buf, desc = 'Goto Type Definition' })
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = buf, desc = 'Goto Declaration' })
      vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, { buffer = buf, desc = 'Signature Help' })
      vim.keymap.set('n', '<leader>ss', builtin.lsp_document_symbols, { buffer = buf, desc = 'LSP Symbols' })
      vim.keymap.set('n', '<leader>sS', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'LSP Workspace Symbols' })
      vim.keymap.set({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, { buffer = buf, desc = 'Code Action' })
      vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { buffer = buf, desc = 'Rename' })
      vim.keymap.set('n', '<leader>cl', '<cmd>LspInfo<cr>', { buffer = buf, desc = 'Lsp Info' })
    end,
  })

  vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Grep (Root Dir)' })
end

-- ============================================================
-- SECTION 5: LSP
-- LSP keymaps, server configuration, Mason tools installations
-- ============================================================
do
  vim.pack.add { gh 'j-hui/fidget.nvim' }
  require('fidget').setup {}

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
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

    end,
  })

  ---@type table<string, vim.lsp.Config>
  local servers = {
    gopls = {
      root_markers = { 'go.mod', 'go.work', '.git' },
      settings = {
        gopls = {
          analyses = { ST1000 = false },
          staticcheck = true,
          gofumpt = true,
        },
      },
    },

    ruby_lsp = {
      cmd = { 'ruby-lsp' },
      root_markers = { 'Gemfile', '.git' },
    },

    lua_ls = {
      on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false

        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            version = 'LuaJIT',
            path = { 'lua/?.lua', 'lua/?/init.lua' },
          },
          workspace = {
            checkThirdParty = false,
            library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
              '${3rd}/luv/library',
              '${3rd}/busted/library',
            }),
          },
        })
      end,
      ---@type lspconfig.settings.lua_ls
      settings = {
        Lua = {
          format = { enable = false },
        },
      },
    },
  }

  vim.pack.add {
    gh 'neovim/nvim-lspconfig',
    gh 'mason-org/mason.nvim',
    gh 'mason-org/mason-lspconfig.nvim',
    gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  }

  require('mason').setup {}

  local ensure_installed = vim.tbl_filter(function(name)
    return name ~= 'ruby_lsp'
  end, vim.tbl_keys(servers or {}))
  vim.list_extend(ensure_installed, {
    'stylua',
    'gofumpt',
    'goimports',
    'golangci-lint',
  })

  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  for name, server in pairs(servers) do
    vim.lsp.config(name, server)
    vim.lsp.enable(name)
  end
end

-- ============================================================
-- SECTION 6: FORMATTING
-- conform.nvim setup and keymap
-- ============================================================
do
  vim.pack.add { gh 'stevearc/conform.nvim' }
  require('conform').setup {
    notify_on_error = false,
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return nil end
      return { timeout_ms = 3000, lsp_format = 'fallback' }
    end,
    default_format_opts = {
      lsp_format = 'fallback',
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      go = { 'gofumpt', 'goimports' },
    },
  }

  vim.keymap.set({ 'n', 'v' }, '<leader>cf', function() require('conform').format { async = true } end, { desc = 'Format buffer' })
end

-- ============================================================
-- SECTION 7: AUTOCOMPLETE & SNIPPETS
-- blink.cmp and luasnip setup
-- ============================================================
do
  vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
  require('luasnip').setup {}

  vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
  require('blink.cmp').setup {
    keymap = {
      preset = 'default',
      ['<CR>'] = { 'accept', 'fallback' },
    },
    appearance = { nerd_font_variant = 'mono' },
    completion = {
      list = { selection = { preselect = false, auto_insert = false } },
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets' },
    },

    snippets = { preset = 'luasnip' },
    fuzzy = { implementation = 'lua' },
    signature = { enabled = true },
  }
end

-- ============================================================
-- SECTION 8: TREESITTER
-- Parser installation, syntax highlighting, folds, indentation
-- ============================================================
do
  vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }

  local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
  require('nvim-treesitter').install(parsers)

  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    if not vim.treesitter.language.add(language) then return end
    vim.treesitter.start(buf, language)

    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil
    if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
  end

  local available_parsers = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match

      local language = vim.treesitter.language.get_lang(filetype)
      if not language then return end

      local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

      if vim.tbl_contains(installed_parsers, language) then
        -- Enable the parser if it is already installed
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
        require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
      else
        -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
        treesitter_try_attach(buf, language)
      end
    end,
  })
end

-- ============================================================
-- SECTION 9: OPTIONAL EXAMPLES / NEXT STEPS
-- kickstart.plugins.* examples
-- ============================================================
do
  require 'kickstart.plugins.debug'
  require 'kickstart.plugins.indent_line'
  require 'kickstart.plugins.lint'
  require 'kickstart.plugins.autopairs'
  require 'kickstart.plugins.snacks'
  require 'kickstart.plugins.gitsigns'
  require 'kickstart.plugins.flash'
  require 'kickstart.plugins.trouble'
  require 'kickstart.plugins.noice'
  require 'kickstart.plugins.ts-comments'
  require 'kickstart.plugins.session'
  require 'kickstart.plugins.neotest'
  require 'kickstart.plugins.tmux-navigator'
  require 'kickstart.plugins.dadbod'
  require 'kickstart.plugins.refactoring'
  require 'custom.plugins'
end

-- vim: ts=2 sts=2 sw=2 et
