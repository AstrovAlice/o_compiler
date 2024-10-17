--pars
local text = require("text")
local scan = require("scan")
local ErrorUnit = require("ErrorUnit")
local Lex = require("Lexemes").Lex

local table = require("table")
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
        text.NextLex()
    else
        -- ErrorUnit.expect(scan.lexName(L)) --ниже мой вариант
        -- ErrorUnit.Expect(scan.lexName(L))
        print()
        print("expect bla-bla-bla")
    end
end

function Module()
    Skip(Lex.MODULE)
    if scan.lex == Lex.NAME then
        print("ЫЫЫЫЫЫЫЫЫЫ")
    end
    --     module = scan.name  # Петров Гергий
    --     table.new(items.Module(module))
    --     nextLex()
    -- else:
    --     error.expect("имя")
    -- skip(Lex.SEMI)
    -- if scan.lex == Lex.IMPORT:
    --     Import()
    -- DeclSeq()
    -- if scan.lex == Lex.BEGIN:
    --     nextLex()
    --     StatSeq()
    -- skip(Lex.END)
    -- check(Lex.NAME)
    -- x = table.find(scan.name)
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
    scan.NextLex()
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
    Module()
    -- table.closeScope()
    -- table.closeScope()
end

return pars