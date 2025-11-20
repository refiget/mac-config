local ls = require("luasnip")
local s  = ls.snippet
local t  = ls.text_node
local i  = ls.insert_node

ls.add_snippets("python", {
  s("trye", {
    t({
      "import sys, traceback",
      "",
      "try:",
      "    # --- your main script code ---",
      "",
      "except Exception:",
      "    traceback.print_exc()",
      "    sys.exit(1)",
      "",
    }),
    i(0),  -- Cursor will land here (below the whole code block)
  }),
})
