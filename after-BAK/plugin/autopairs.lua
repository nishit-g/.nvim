local status, formatter = pcall(require, "nvim-autopairs")
if (not status) then return end


formatter.setup{}
