runtime ./plug.vim

syntax on
" set background = dark
set number
set termguicolors
colorscheme onedark
" colorscheme kanagawa
set relativenumber
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set clipboard=unnamed
set cursorline
highlight CursorLineNr cterm=bold ctermbg=15 ctermfg=8 gui=NONE  guifg=#e8bc1c
" set ctermbg=none 
" set guibg=none
lua <<EOF
local map = vim.api.nvim_set_keymap

vim.g.mapleader=' '

-- Better Window Navigation
local opts = {noremap = true, silent=true}
map("n", "<C-h>", "<C-w>h",opts)
map("n", "<C-l>", "<C-w>l",opts)
map("n", "<C-j>", "<C-w>j",opts)
map("n", "<C-k>", "<C-w>k",opts)

-- Move Code line up / down
-- Visual mode
map("v", "J", ":m '>+1<CR>gv=gv",opts)
map("v", "K", ":m '<-2<CR>gv=gv",opts)
-- Normal Mode

--Copy till end of the line 
map("n", "Y", "y$",opts)

-- Better Escape 
map("i", "jj", "<Esc>",opts)

-- Close Buffer // Copied from chadrc github
map("n", "<leader>x", ":lua close_buffer() <CR>",opts)
map("n", "<Esc>", ":noh <CR>", opts)
-- Git mappings
map("n", "<leader>gp", ":Git push<CR>", opts)
map("n", "<leader>g", ":G<CR>", opts)
map("n", "<leader>gc", ":Git commit<CR>", opts)
map("n", "<leader>gb", ":Git blame<CR>", opts)
map("n", "<leader>gh", ":diffget //2<CR>", opts)
map("n", "<leader>gl", ":diffget //3<CR>", opts)
map("n", "<leader><C-f>", ":silent !tmux neww tmux-sessionizer<CR>", opts)

close_buffer = function(bufexpr, force)
   -- This is a modification of a NeoVim plugin from
   -- Author: ojroques - Olivier Roques
   -- Src: https://github.com/ojroques/nvim-bufdel
   -- (Author has okayed copy-paste)

   -- Options
   local opts = {
      next = "cycle", -- how to retrieve the next buffer
      quit = false, -- exit when last buffer is deleted
      --TODO make this a chadrc flag/option
   }

   -- ----------------
   -- Helper functions
   -- ----------------

   -- Switch to buffer 'buf' on each window from list 'windows'
   local function switch_buffer(windows, buf)
      local cur_win = vim.fn.winnr()
      for _, winid in ipairs(windows) do
         vim.cmd(string.format("%d wincmd w", vim.fn.win_id2win(winid)))
         vim.cmd(string.format("buffer %d", buf))
      end
      vim.cmd(string.format("%d wincmd w", cur_win)) -- return to original window
   end

   -- Select the first buffer with a number greater than given buffer
   local function get_next_buf(buf)
      local next = vim.fn.bufnr "#"
      if opts.next == "alternate" and vim.fn.buflisted(next) == 1 then
         return next
      end
      for i = 0, vim.fn.bufnr "$" - 1 do
         next = (buf + i) % vim.fn.bufnr "$" + 1 -- will loop back to 1
         if vim.fn.buflisted(next) == 1 then
            return next
         end
      end
   end

   -- ----------------
   -- End helper functions
   -- ----------------

   local buf = vim.fn.bufnr()
   if vim.fn.buflisted(buf) == 0 then -- exit if buffer number is invalid
      vim.cmd "close"
      return
   end

   if #vim.fn.getbufinfo { buflisted = 1 } < 2 then
      if opts.quit then
         -- exit when there is only one buffer left
         if force then
            vim.cmd "qall!"
         else
            vim.cmd "confirm qall"
         end
         return
      end

      local chad_term, type = pcall(function()
         return vim.api.nvim_buf_get_var(buf, "term_type")
      end)

      if chad_term then
         -- Must be a window type
         vim.cmd(string.format("setlocal nobl", buf))
         vim.cmd "enew"
         return
      end
      -- don't exit and create a new empty buffer
      vim.cmd "enew"
      vim.cmd "bp"
   end

   local next_buf = get_next_buf(buf)
   local windows = vim.fn.getbufinfo(buf)[1].windows

   -- force deletion of terminal buffers to avoid the prompt
   if force or vim.fn.getbufvar(buf, "&buftype") == "terminal" then
      local chad_term, type = pcall(function()
         return vim.api.nvim_buf_get_var(buf, "term_type")
      end)

      -- TODO this scope is error prone, make resilient
      if chad_term then
         if type == "wind" then
            -- hide from bufferline
            vim.cmd(string.format("%d bufdo setlocal nobl", buf))
            -- swtich to another buff
            -- TODO switch to next bufffer, this works too
            vim.cmd "BufferLineCycleNext"
         else
            local cur_win = vim.fn.winnr()
            -- we can close this window
            vim.cmd(string.format("%d wincmd c", cur_win))
            return
         end
      else
         switch_buffer(windows, next_buf)
         vim.cmd(string.format("bd! %d", buf))
      end
   else
      switch_buffer(windows, next_buf)
      vim.cmd(string.format("silent! confirm bd %d", buf))
   end
   -- revert buffer switches if user has canceled deletion
   if vim.fn.buflisted(buf) == 1 then
      switch_buffer(windows, buf)
   end
end


EOF

