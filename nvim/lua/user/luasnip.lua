local ls = require('luasnip')
local snip = ls.snippet
local text = ls.text_node
local insert = ls.insert_node

ls.add_snippets(nil, {
  go = {
    snip({
      trig = 'ife',
      }, {
      text({'if err != nil {', '\treturn err', '}'}),
      insert(0),
    }),
  },
})

