return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<C-\\>", desc = "Toggle terminal" },
    { "<leader>tt", desc = "Terminal toggle" },
    { "<leader>tf", desc = "Terminal float" },
    { "<leader>tg", desc = "Terminal lazygit" },
    { "<leader>tv", desc = "Terminal vertical split" },
    { "<leader>th", desc = "Terminal horizontal split" },
  },
  cmd = {
    "ToggleTerm", "TermExec",
    "ToggleTermToggleAll", "ToggleTermSendCurrentLine",
    "ToggleTermSendVisualLines", "ToggleTermSendVisualSelection"
  },
  opts = {
    -- Size can be a number or function which returns a number
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,

    -- Key mapping to toggle terminal
    open_mapping = [[<C-\>]],

    -- Open the terminal in insert mode
    start_in_insert = true,

    -- Enable shadows for terminal windows
    shading_factor = 2,

    -- Direction ('vertical', 'horizontal', 'tab', 'float')
    direction = 'float',

    -- Integrate with the vim shell environment rather than running a new shell
    shell = vim.o.shell,

    -- Hide numbers in the terminal buffer
    hide_numbers = true,

    -- Automatically close on terminal exit
    close_on_exit = true,


    -- Auto scroll to bottom when entering terminal window
    autoscroll = true,

    -- Float window settings
    float_opts = {
      -- Border style (see ':h nvim_open_win')
      border = 'curved',


      -- Width and height of the terminal float window
      width = function()
        return math.floor(vim.o.columns * 0.85)
      end,
      height = function()
        return math.floor(vim.o.lines * 0.8)
      end,

      -- Transparency

      winblend = 3,

      -- Title and title position
      title = 'Terminal',
      title_pos = 'center',

      -- Highlight groups for various parts

      highlights = {

        border = "FloatBorder",
        background = "Normal",
        title = "Title",

      },
    },

    -- Winbar config
    winbar = {
      enabled = true,
      name_formatter = function(term)
        return term.name
      end,
    },

    -- Persist size between windows
    persist_size = true,

    -- Navigate between windows using vim-tmux-navigator style bindings
    persist_mode = true,
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    -- Setup keymaps
    local map = vim.keymap.set

    -- Toggle terminal
    map('n', '<leader>tt', '<cmd>ToggleTerm<CR>', { desc = "Toggle terminal" })


    -- Terminal in float mode
    map('n', '<leader>tf', '<cmd>ToggleTerm direction=float<CR>', { desc = "Terminal float" })

    -- Terminal in vertical split
    map('n', '<leader>tv', '<cmd>ToggleTerm direction=vertical<CR>', { desc = "Terminal vertical" })

    -- Terminal in horizontal split
    map('n', '<leader>th', '<cmd>ToggleTerm direction=horizontal<CR>', { desc = "Terminal horizontal" })


    -- Add global way to escape terminal mode
    function _G.set_terminal_keymaps()
      local term_opts = { buffer = 0 }
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], term_opts)
      vim.keymap.set('t', 'jj', [[<C-\><C-n>]], term_opts)

      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], term_opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], term_opts)

      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], term_opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], term_opts)

      vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], term_opts)
    end

    -- Auto command to set terminal keymaps when entering terminal
    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

    -- Set up lazygit terminal
    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new({
      cmd = "lazygit",
      dir = "git_dir",
      direction = "float",
      float_opts = {
        border = "curved",
      },
      -- Function to run on opening the terminal
      on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
      end,
      -- Function to run on closing the terminal
      on_close = function(term)
        vim.cmd("startinsert!")
      end,
    })

    -- Function to toggle lazygit
    function _G.lazygit_toggle()
      lazygit:toggle()
    end

    -- Map to toggle lazygit
    map("n", "<leader>tg", "<cmd>lua lazygit_toggle()<CR>", {noremap = true, silent = true, desc = "Lazygit"})

    -- Project-specific terminal (for tmux-like workflow)
    -- Create a function to open a terminal in the project root directory
    function _G.project_terminal()
      local project_root = require("project_nvim.project").get_project_root()
      if project_root then
        Terminal:new({
          dir = project_root,
          direction = "float",
          float_opts = {
            border = "curved",
          }
        }):toggle()
      else
        Terminal:new({
          direction = "float",
          float_opts = {
            border = "curved",
          }
        }):toggle()
      end
    end

    -- Map to open a terminal in the current project
    map("n", "<leader>tp", "<cmd>lua project_terminal()<CR>", {noremap = true, silent = true, desc = "Project Terminal"})
  end,
}
