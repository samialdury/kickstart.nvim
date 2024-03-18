-- vim.keymap.set("n", "<leader>h", ":echo 'Hello, world!'<CR>", { noremap = true })

-- Disable arrow keys
local modes = { 'n', 'i', 'v', 'c' }
local keys = { '<up>', '<down>', '<left>', '<right>' }
for _, mode in ipairs(modes) do
  for _, key in ipairs(keys) do
    vim.keymap.set(mode, key, '<nop>', { noremap = true })
  end
end

-- Spectre
vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
  desc = 'Toggle Spectre',
})
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
  desc = 'Search current word',
})
vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
  desc = 'Search current word',
})
vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
  desc = 'Search on current file',
})

-- LazyGit
vim.keymap.set('n', '<leader>lg', '<cmd>LazyGit<CR>', { desc = 'LazyGit' })

-- vim-go
-- run :GoBuild or :GoTestCompile based on the go file
local function build_go_files()
  if vim.endswith(vim.api.nvim_buf_get_name(0), '_test.go') then
    vim.cmd 'GoTestCompile'
  else
    vim.cmd 'GoBuild'
  end
end

vim.keymap.set('n', '<leader>b', build_go_files, { desc = 'Build' })

-- Run gofmt/gofmpt, import packages automatically on save
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('setGoFormatting', { clear = true }),
  pattern = '*.go',
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { 'source.organizeImports' } }
    local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 2000)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, 'utf-16')
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end

    vim.lsp.buf.format()
  end,
})

-- Disable listchars for Go files
vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('disableListChars', { clear = true }),
  pattern = '*.go',
  callback = function()
    vim.opt.list = false
  end,
})

vim.api.nvim_create_user_command('TT', 'set list!', { nargs = 0 }) -- Toggle listchars

-- Fast saving
vim.keymap.set('n', '<Leader>W', ':write!<CR>', { desc = 'Save' })
vim.keymap.set('n', '<Leader>Q', ':q!<CR>', { silent = true, desc = 'Quit' })

-- Exit on jj and jk in insert mode
vim.keymap.set('i', 'jj', '<ESC>')
vim.keymap.set('i', 'jk', '<ESC>')

-- Don't jump forward if I higlight and search for a word
local function stay_star()
  local sview = vim.fn.winsaveview()
  local args = string.format('keepjumps keeppatterns execute %q', 'sil normal! *')
  vim.api.nvim_command(args)
  vim.fn.winrestview(sview)
end
vim.keymap.set('n', '*', stay_star, { noremap = true, silent = true })

-- Open help window in a vertical split to the right.
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = vim.api.nvim_create_augroup('help_window_right', {}),
  pattern = { '*.txt' },
  callback = function()
    if vim.o.filetype == 'help' then
      vim.cmd.wincmd 'L'
    end
  end,
})

-- If I visually select words and paste from clipboard, don't replace my
-- clipboard with the selected word, instead keep my old word in the
-- clipboard
vim.keymap.set('x', 'p', '"_dP')

-- rename the word under the cursor
vim.keymap.set('n', '<leader>rw', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
