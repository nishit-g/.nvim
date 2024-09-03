-- For easily commenting stuff
return {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },    
    config = function()
        require('Comment').setup()
    end
}
