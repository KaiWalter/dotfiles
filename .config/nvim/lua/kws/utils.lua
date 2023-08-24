function map(mode, lhs, rhs, desc)
  local options = { noremap = true, silent = true, desc = desc }
  vim.keymap.set(mode, lhs, rhs, options)
end

function mapn(lhs, rhs, desc)
  map('n', lhs, rhs, desc)
end

function mapv(lhs, rhs, desc)
  map('v', lhs, rhs, desc)
end
