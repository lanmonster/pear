# pear.nvim

Easily switch between two file pairs

## Install

```lua
return {
    "sylvanfranklin/pear",
    config = function()
        local pear = require("pear")
        vim.keymap.set("n", "<leader>b", function() pear.jump_pairs() end, { silent = true })
    end
}
```
