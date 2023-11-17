-- Best Git plugin alskdfjal
return {
  "tpope/vim-fugitive",
  opt = true,  -- Marks the plugin for lazy loading
  cmd = { 'G', 'Git', 'Gstatus', 'Gblame', 'Gdiff' },
  dependencies = {
    "tpope/vim-rhubarb"
  },
}
