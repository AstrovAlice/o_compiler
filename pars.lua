--pars
local text = require("text")
local scan = require("scan")
local ErrorUnit = require("ErrorUnit")
local Lex = require("Lexemes")

local Table = require("Table")
local items = require("items")
local gen = require("gen")
local ovm = require("ovm")


local pars = {}

Types = {
    Bool = 0,
    Int = 1
}

-- function pars.NextCh()
--     ch = text.NextCh()
--     return ch
-- end

-- function pars.NextLex()
--     lex = scan.NextLex()
--     return lex
-- end

function Skip(L)
    if scan.lex == L then
        scan.NextLex()
    else
        ErrorUnit.Expect(L)
    end
end

function Check(L)
    if scan.Lex ~= L then
        ErrorUnit.Expect(scan.lexName(L))
    end
end

function ImportModule()
    Check(Lex.NAME)
    local name = scan.name
    if name == "In" or name == "Out" then
        -- Table.new(items.Module(name))
    else
        ErrorUnit.CtxError("Предусмотрены только модули In и Out")
    end
    text.NextLex()
end

function Import()
    Skip(Lex.IMPORT)
    ImportModule()
    while scan.lex == Lex.COMMA do
        text.NextLex()
        ImportModule()
    end
    Skip(Lex.SEMI)
end

function DeclSeq()
    print("DeclSeq")
end

function Module()
    Skip(Lex.MODULE)
    if scan.lex == Lex.NAME then
        -- local module = scan.name
        -- Table.new(items.Module(module))
        scan.NextLex()
    else
        ErrorUnit.Expect("имя")
    end
    Skip(Lex.SEMI)
    if scan.lex == Lex.IMPORT then
        -- Import()
    end
    -- DeclSeq()
    if scan.lex == Lex.BEGIN then
        text.NextLex()
        -- StatSeq()
    end
    Skip(Lex.END)
    Check(Lex.NAME)

    -- x = Table.find(scan.name)
    -- if type(x) != items.Module:
    --     error.expect("имя модуля")
    -- elif x.name != module:  # Пeтров Георгий
    --     error.expect("имя модуля " + module)
    -- nextLex()
    -- skip(Lex.DOT)
    -- gen.Cmd(cm.STOP)
    -- AllocVars()
end

function pars.Compile()
    text.NextCh()
    scan.name = text.ch
    scan.NextLex()
    -- Table.openScope()

    T = Types

    -- Table.add(items.Func("abs", T.Int))
    -- Table.add(items.Func("max", T.Int))
    -- Table.add(items.Func("min", T.Int))
    -- Table.add(items.Func("odd", T.Bool))
    -- Table.add(items.Proc("halt"))
    -- Table.add(items.Proc("inc"))
    -- Table.add(items.Proc("dec"))
    -- Table.add(items.Proc("In.open"))
    -- Table.add(items.Proc("In.int"))
    -- Table.add(items.Proc("Out.int"))
    -- Table.add(items.Proc("Out.ln"))
    -- Table.add(items.Type("int", T.Int))

    -- Table.openScope()
    Module()
    -- Table.closeScope()
    -- Table.closeScope()
end

return pars