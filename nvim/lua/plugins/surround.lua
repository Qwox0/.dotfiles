local keys = {
    { "ds",  nil, desc = "[D]elete [S]urroundings" },
    { "cs",  nil, desc = "[C]hange [S]urroundings" },
    { "cS",  nil, desc = "[C]hange [S]urroundings, placing the surrounded text on its own line(s)" },
    { "ys",  nil, desc = "[Y]ou [S]urround" },
    { "yss", nil, desc = "Add Surrounding on current line" },
    { "ySS", nil, desc = "Add Surrounding on current line, placing the surrounded text on its own line(s)" },
    { "S",   nil, desc = "[S]urround",                                                                     mode = "v" },
    { "gS",  nil, desc = "[S]urround, placing the surrounded text on its own line(s)",                     mode = "v" },
}

return { -- ds": "word" -> word; cs"(: "word" -> ( word )
    "tpope/vim-surround",
    keys = keys,
}
