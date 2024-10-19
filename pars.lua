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

function Skip(L)
    if scan.lex == L then
        scan.NextLex()
    else
        ErrorUnit.Expect(L)
    end
end

function Check(L)
    if scan.lex ~= L then
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
    scan.NextLex()
end

function Import()
    Skip(Lex.IMPORT)
    ImportModule()
    while scan.lex == Lex.COMMA do
        scan.NextLex()
        ImportModule()
    end
    Skip(Lex.SEMI)
end

function ConstExpr()
    local sign = 1
    if scan.lex == Lex.PLUS or scan.lex == Lex.MINUS then
        if scan.lex == Lex.MINUS then
            sign = -1
        end
        scan.NextLex()
    end
    if scan.lex == Lex.NUM then
        local value = scan.value * sign
        scan.NextLex()
        return value
    elseif scan.lex == Lex.NAME then
        -- local x = table.find(scan.name)
        -- scan.NextLex()
        -- if type(x) ~= items.Const then
        --     ErrorUnit.Expect("const")
        -- else
        --     return x.value * sign
        -- end
    else
        ErrorUnit.Expect("number or name")
    end
end

function ConstDecl()
    Check(Lex.NAME)
    local name = scan.name
    scan.NextLex()
    Skip(Lex.EQ)
    local value = ConstExpr()
    -- table.new(items.Const(name, Types.Int, value))
end

function Type()
    Check(Lex.NAME)
    -- x = table.find(scan.name)
    -- if type(x) ~= items.Type then
    --     ErrorUnit.Expect("name of type")
    -- end
    scan.NextLex()
end

function VarDecl()
    Check(Lex.NAME)
    -- table.new(items.Var(scan.name, Types.Int))
    scan.NextLex()
    while scan.lex == Lex.COMMA do
        scan.NextLex()
        Check(Lex.NAME)
        -- table.new(items.Var(scan.name, Types.Int))
        scan.NextLex()
    end
    Skip(Lex.COLON)
    Type()
end

function DeclSeq()
    while scan.lex == Lex.CONST or scan.lex == Lex.VAR do
        if scan.lex == Lex.CONST then
            scan.NextLex()
            while scan.lex == Lex.NAME do
                ConstDecl()
                Skip(Lex.SEMI)
            end
        else
            scan.NextLex()
            while scan.lex == Lex.NAME do
                VarDecl()
                Skip(Lex.SEMI)
            end
        end
    end
end

function AssOrCall()
    -- Check(Lex.NAME)
    -- x = table.find(scan.name)
    -- if type(x) == items.Var then
    --     AssStatement(x)
    -- elseif type(x) == items.Proc or type(x) == items.Module then
    --     CallStatement(x)
    -- else
    --     ErrorUnit.Expect("name of function or variable")
    -- end
end

function IfStatement()
    -- Skip(Lex.IF)
    -- BoolExpr()
    -- CondPC = gen.PC
    -- LastGOTO = 0
    -- skip(Lex.THEN)
    -- StatSeq()
    -- while scan.lex == Lex.ELSIF:
    --     gen.Cmd(LastGOTO)
    --     gen.Cmd(cm.GOTO)
    --     LastGOTO = gen.PC
    --     gen.fixup(CondPC, gen.PC)
    --     nextLex()
    --     BoolExpr()
    --     CondPC = gen.PC  # Тут была ошибка. Этой строки не было.
    --     skip(Lex.THEN)
    --     StatSeq()
    -- if scan.lex == Lex.ELSE:
    --     gen.Cmd(LastGOTO)
    --     gen.Cmd(cm.GOTO)
    --     LastGOTO = gen.PC
    --     gen.fixup(CondPC, gen.PC)
    --     scan.NextLex()
    --     StatSeq()
    -- else:
    --     gen.fixup(CondPC, gen.PC)
    -- Skip(Lex.END)
    -- gen.fixup(LastGOTO, gen.PC)
end

function WhileStatement()
    -- WhilePC = gen.PC
    -- Skip(Lex.WHILE)
    -- BoolExpr()
    -- CondPC = gen.PC
    -- skip(Lex.DO)
    -- StatSeq()
    -- skip(Lex.END)
    -- gen.Cmd(WhilePC)
    -- gen.Cmd(cm.GOTO)
    -- # ovm.M[CondPC-2] = gen.PC
    -- gen.fixup(CondPC, gen.PC)
end

function Statement()
    if scan.lex == Lex.NAME then
        AssOrCall()
    elseif scan.lex == Lex.IF then
        IfStatement()
    elseif scan.lex == Lex.WHILE then
        WhileStatement()
    end
end

function StatSeq()
    Statement()
    while scan.lex == Lex.SEMI do
        scan.NextLex()
        Statement()
    end
end

function Module()
    Skip(Lex.MODULE)
    if scan.lex == Lex.NAME then
        -- local module = scan.name
        -- Table.new(items.Module(module))
        scan.NextLex()
    else
        ErrorUnit.Expect("name")
    end
    Skip(Lex.SEMI)
    if scan.lex == Lex.IMPORT then
        Import()
    end
    DeclSeq()
    if scan.lex == Lex.BEGIN then
        scan.NextLex()
        StatSeq()
    end
    Skip(Lex.END)
    -- Check(Lex.NAME)
    Skip(Lex.NAME)
    Skip(Lex.DOT)

    -- scan.NextLex()
    -- Skip(Lex.DOT)

    -- x = Table.find(scan.name)
    -- if type(x) != items.Module:
    --     error.expect("имя модуля")
    -- elif x.name != module:  
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
    print("\n")
end

return pars