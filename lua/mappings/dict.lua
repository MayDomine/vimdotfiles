map("n", "<leader>ww", function ()
  require("dict").lookup(nil, "wn")
end, desc_opts "Dictionary" )

map("n", "<leader>ws", function ()
  require("dict").lookup(nil, "moby-thesaurus")
end, desc_opts  "Dictionary" )
