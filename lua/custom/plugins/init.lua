-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha',
        integrations = {
          cmp = true,
          gitsigns = true,
          mini = true,
          mason = true,
          markdown = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { 'italic' },
              hints = { 'italic' },
              warnings = { 'italic' },
              information = { 'italic' },
            },
            underlines = {
              errors = { 'underline' },
              hints = { 'underline' },
              warnings = { 'underline' },
              information = { 'underline' },
            },
            inlay_hints = {
              background = true,
            },
          },
          telescope = true,
          treesitter = true,
          which_key = true,
        },
      }
    end,
  },
  {
    'christoomey/vim-tmux-navigator',
    lazy = false,
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
    },
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },
  },
  {
    'tpope/vim-fugitive',
  },
  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
    },
  },
  {
    'nvim-pack/nvim-spectre',
  },
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    lazy = true,
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = '[[',
            jump_next = ']]',
            accept = '<CR>',
            refresh = 'gr',
            open = '<M-CR>',
          },
          layout = {
            position = 'bottom', -- | top | left | right
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true, -- This
          debounce = 75,
          keymap = {
            accept = '<C-a>',
            accept_word = false,
            accept_line = false,
            next = '<M-]>',
            prev = '<M-[>',
            dismiss = '<C-]>',
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ['.'] = false,
        },
        copilot_node_command = 'node', -- Node.js version must be > 18.x
        server_opts_overrides = {},
      }
    end,
  },
  {
    'kdheepak/lazygit.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
  },
  {
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',
    cmd = { 'MarkdownPreview' },
    dependencies = {
      'zhaozg/vim-diagram',
      'aklt/plantuml-syntax',
    },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },
  {
    'fatih/vim-go',
    config = function()
      -- we disable most of these features because treesitter and nvim-lsp
      -- take care of it
      vim.g['go_gopls_enabled'] = 0
      vim.g['go_code_completion_enabled'] = 0
      vim.g['go_fmt_autosave'] = 0
      vim.g['go_imports_autosave'] = 0
      vim.g['go_mod_fmt_autosave'] = 0
      vim.g['go_doc_keywordprg_enabled'] = 0
      vim.g['go_def_mapping_enabled'] = 0
      vim.g['go_textobj_enabled'] = 0
      vim.g['go_list_type'] = 'quickfix'
    end,
  },
  {
    'windwp/nvim-autopairs',
    -- Optional dependency
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      require('nvim-autopairs').setup {}
      -- If you want to automatically add `(` after selecting a function or method
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  {
    'ethanholz/nvim-lastplace',
    config = function()
      require('nvim-lastplace').setup {
        lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help' },
        lastplace_ignore_filetype = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' },
        lastplace_open_folds = true,
      }
    end,
  },
  -- Alternate between files, such as foo.go and foo_test.go
  {
    'rgroli/other.nvim',
    config = function()
      require('other-nvim').setup {
        mappings = {
          'rails', --builtin mapping
          {
            pattern = '(.*).go$',
            target = '%1_test.go',
            context = 'test',
          },
          {
            pattern = '(.*)_test.go$',
            target = '%1.go',
            context = 'file',
          },
        },
      }

      vim.api.nvim_create_user_command('A', function(opts)
        require('other-nvim').open(opts.fargs[1])
      end, { nargs = '*' })

      vim.api.nvim_create_user_command('AV', function(opts)
        require('other-nvim').openVSplit(opts.fargs[1])
      end, { nargs = '*' })

      vim.api.nvim_create_user_command('AS', function(opts)
        require('other-nvim').openSplit(opts.fargs[1])
      end, { nargs = '*' })
    end,
  },
  {
    'ThePrimeagen/vim-be-good',
    lazy = false,
  },
}
