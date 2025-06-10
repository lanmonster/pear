local M = {}
local options = {}
M.setup = function(opts)
  opts = opts or {}
  opts.pears = opts.pears or {}
  opts.open_in = opts.open_in or 'place'
  options = opts
end
M.create_pear = function(desired_ext, gen_target_basename)
  return function(filename, ext)
    if ext ~= desired_ext then
      return nil
    end
    return gen_target_basename(filename)
  end
end

local float_window = function(text)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, 0, false, vim.split(text, '\n'))
  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)
  return buf, win
end

M.jump_pair = function()
  local ext = vim.fn.expand('%:e')
  local filename = vim.fn.expand('%:t')
  for _, pear in ipairs(options.pears) do
    local target = pear(filename, ext)
    if target == nil then
      goto continue
    end
    local path = vim.fn.findfile(target, vim.fn.expand('%:h'))
    if path ~= '' then
      vim.cmd('edit ' .. path)
      return
    end
    ::continue::
  end
  print('No matching pair for ' .. filename)
end

return M
