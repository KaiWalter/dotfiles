local rest = require('rest-nvim')
mapn('<leader>rr', rest.run, "[R]est [R]un")
mapn('<leader>rl', rest.last, "[R]est [L] run")
