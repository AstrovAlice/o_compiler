--pars
local text = require("text")
local scan = require("scan")

local table = require("table")
local items = require("items")
local gen = require("gen")
local ovm = require("ovm")


local pars = {

}

Types = {
    Bool = 0,
    Int = 1
}

function pars.Compile()
    -- print(text._src)
    while text.ch ~= text.EOT do
        text.NextCh()
    end
    -- text.nextLex()
    -- print(text.ch)
    -- print(text.nextLex())
    -- table.openScope()

    T = Types

    -- table.add(items.Func("abs", T.Int))
    -- table.add(items.Func("max", T.Int))
    -- table.add(items.Func("min", T.Int))
    -- table.add(items.Func("odd", T.Bool))
    -- table.add(items.Proc("halt"))
    -- table.add(items.Proc("inc"))
    -- table.add(items.Proc("dec"))
    -- table.add(items.Proc("In.open"))
    -- table.add(items.Proc("In.int"))
    -- table.add(items.Proc("Out.int"))
    -- table.add(items.Proc("Out.ln"))
    -- table.add(items.Type("int", T.Int))

    -- table.openScope()
    -- Module()
    -- table.closeScope()
    -- table.closeScope()
end

return pars