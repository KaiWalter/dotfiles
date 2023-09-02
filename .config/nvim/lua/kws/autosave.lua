local buffer_number = -1
local window_number = -1

local function log(_, data)
  if data then
    vim.api.nvim_buf_set_lines(buffer_number, -1, -1, true, data)
  end
end

local function open_buffer()
  if not vim.api.nvim_win_is_valid(window_number) then
    buffer_number = -1
  end
  if buffer_number == -1 then
    vim.api.nvim_command('botright new')
    buffer_number = vim.api.nvim_get_current_buf()
    window_number = vim.api.nvim_get_current_win()
  end
end

-- vim.api.nvim_create_autocmd("BufWritePost", {
--   group = vim.api.nvim_create_augroup("KWSAutoSave", { clear = true }),
--   pattern = "Program.cs",
--   callback = function()
--     open_buffer()
--     vim.api.nvim_buf_set_lines(buffer_number, 0, -1, true, {})
--     vim.fn.jobstart({ "dotnet", "run" }, {
--       stdout_buffered = true,
--       on_stdout = log,
--       stderr_buffered = true,
--       on_stderr = log,
--     })
--   end,
-- })

-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
--   pattern = '/*',
--   callback = function(t)
--     vim.cmd.NvimTreeClose()
--     print(t.file)
--   end
-- })

function kwsCreate()
  open_buffer()
  print(buffer_number, ':', window_number)
  vim.api.nvim_buf_set_lines(buffer_number, 0, -1, true, {})
end

function kwsLog()
  vim.api.nvim_buf_set_lines(buffer_number, -1, -1, true, { 'test' })
end

vim.api.nvim_create_user_command('KwsCreate', kwsCreate, {})
vim.api.nvim_create_user_command('KwsLog', kwsLog, {})
