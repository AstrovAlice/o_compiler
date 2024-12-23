--pars
local text = require("text")
local scan = require("scan")
local ErrorUnit = require("ErrorUnit")
local Lex = require("Lexemes")

local Table = require("Table")
local Items = require("Items")
local gen = require("gen")
local ovm = require("ovm")


local pars = {}

Types = {
    Bool = "boolean",
    Int = "number"
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
        Table.New(Items.Module:new(name))
    else
        ErrorUnit.CtxError("you can use only 'In' and 'Out'")
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
        local x = Table.Find(scan.name)
        scan.NextLex()
        if x.item ~= "Const" then
            ErrorUnit.Expect("const")
        else
            return x.value * sign
        end
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
    Table.New(Items.Const:new(name, Types.Int, value))
end

function Type()
    Check(Lex.NAME)
    local x = Table.Find(scan.name)
    -- if type(x) ~= type(Items.Type) then    !!!
    if x.item ~= "Type" then
        ErrorUnit.Expect("name of type")
    end
    scan.NextLex()
end

function VarDecl()
    Check(Lex.NAME)
    Table.New(Items.Var:new(scan.name, Types.Int))
    scan.NextLex()
    while scan.lex == Lex.COMMA do
        scan.NextLex()
        Check(Lex.NAME)
        Table.New(Items.Var:new(scan.name, Types.Int))
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

function IntExpr()
    local T = Expression()
    if T ~= Types.Int then
        ErrorUnit.Expect("выражение целого типа")
    end
end

function Function(x)
    if x.name == "ABS" then
        IntExpr()
        gen.Cmd(ovm.DUP)
        gen.Cmd(0)
        gen.Cmd(gen.PC + 3)
        gen.Cmd(ovm.IFGE)
        gen.Cmd(ovm.NEG)
    elseif x.name == "MIN" then
        Type()
        gen.Cmd(scan.MAXINT)
        gen.Cmd(ovm.NEG)
        gen.Cmd(1)
        gen.Cmd(ovm.SUB)
    elseif x.name == "MAX" then
        Type()
        gen.Cmd(scan.MAXINT)
    elseif x.name == "ODD" then
        IntExpr()
        gen.Cmd(2)
        gen.Cmd(ovm.MOD)
        gen.Cmd(0)
        gen.Cmd(0)
        gen.Cmd(ovm.IFEQ)
    else
        assert(false, "Unknown function: " .. x.name)
    end
end

function Factor()
    if scan.lex == Lex.NAME then
        local x = Table.Find(scan.name)
        if x.item == "Const" then
            gen.Const(x.value)
            scan.NextLex()
            return x.type
        elseif x.item == "Var" then
            gen.Addr(x)
            gen.Cmd(ovm.LOAD)
            scan.NextLex()
            return x.type
        elseif x.item == "Func" then
            scan.NextLex()
            Skip(Lex.LPAR)
            Function(x)
            Skip(Lex.RPAR)
            return x.type
        else
            ErrorUnit.Expect("name of const, variable or function")
        end
    elseif scan.lex == Lex.NUM then
        gen.Cmd(scan.num)
        scan.NextLex()
        return Types.Int
    elseif scan.lex == Lex.LPAR then
        scan.NextLex()
        T = Expression()
        Skip(Lex.RPAR)
        return T
    else
        ErrorUnit.Expect("name, number or  '('")
    end
end

function Term()
    local T = Factor()
    while scan.lex == Lex.MULT or scan.lex ==  Lex.DIV or scan.lex ==  Lex.MOD do
        Op = scan.lex
        TestInt(T)
        scan.NextLex()
        T = Factor()
        TestInt(T)
        if Op == Lex.DIV then
            gen.Cmd(ovm.DIV)
        elseif Op == Lex.MULT then
            gen.Cmd(ovm.MULT)
        else
            gen.Cmd(ovm.MOD)
        end
    end
    return T
end

function SimpleExpression()
    if scan.lex == Lex.PLUS or scan.lex ==Lex.MINUS then
        local op = scan.lex
        scan.NextLex()
        local T = Term()
        TestInt(T)
        if op == Lex.MINUS then
            gen.Cmd(ovm.NEG)
        end
    else
        T = Term()
    end
    while scan.lex == Lex.PLUS or scan.lex ==Lex.MINUS do
        local op = scan.lex
        TestInt(T)
        scan.NextLex()
        T = Term()
        TestInt(T)
        if op == Lex.PLUS then
            gen.Cmd(ovm.ADD)
        else
            gen.Cmd(ovm.SUB)
        end
    end
    return T
end

function TestInt(T)
    if T ~= Types.Int then
        ErrorUnit.Expect("выражение целого типа")
    end
end

function Expression()
    local T = SimpleExpression()
    if scan.lex == Lex.EQ or scan.lex ==  Lex.NE or
    scan.lex == Lex.GT or  scan.lex == Lex.GE or
    scan.lex == Lex.LT or scan.lex == Lex.LE then
        local op = scan.lex
        TestInt(T)
        scan.NextLex()
        T = SimpleExpression()
        TestInt(T)
        gen.Comp(op)
        return Types.Bool
    else
        return T
    end
end

function AssStatement(x)
    gen.Addr(x)
    Skip(Lex.NAME)
    Skip(Lex.ASS)
    local T = Expression()
    if x.type ~= T then
        ErrorUnit.ctxError("Type mismatch during assignment")
    end
    gen.Cmd(ovm.SAVE)
end

function Variable()
    Check(Lex.NAME)
    local v = Table.Find(scan.name)
    if v.item ~= "Var" then
        ErrorUnit.Expect("имя переменной")
    end
    gen.Addr(v)
    scan.NextLex()
end

function Procedure(x)
    if x.name == "HALT" then
        local value = ConstExpr()
        gen.Const(value)
        gen.Cmd(ovm.STOP)
    elseif x.name == "INC" then
        Variable()
        gen.Cmd(ovm.DUP)
        gen.Cmd(ovm.LOAD)
        if scan.lex == Lex.COMMA then
            scan.NextLex()
            IntExpr()
        else
            gen.Cmd(1)
        gen.Cmd(ovm.ADD)
        gen.Cmd(ovm.SAVE)
        end
    elseif x.name == "DEC"then
        Variable()
        gen.Cmd(ovm.DUP)
        gen.Cmd(ovm.LOAD)
        if scan.lex == Lex.COMMA then
            scan.NextLex()
            IntExpr()
        else
            gen.Cmd(1)
        end
        gen.Cmd(ovm.SUB)
        gen.Cmd(ovm.SAVE)
    elseif x.name == "In.Open" then
        io.write()--pass
    elseif x.name == "In.Int" then
        Variable()
        gen.Cmd(ovm.IN)
        gen.Cmd(ovm.SAVE)
    elseif x.name == "Out.Int" then
        IntExpr()
        Skip(Lex.COMMA)
        IntExpr()
        gen.Cmd(ovm.OUT)
    elseif x.name == "Out.Ln" then
        gen.Cmd(ovm.LN)
    else
        assert(false, "Unknown function: " .. x.name)
    end
end

function CallStatement(x)
    Skip(Lex.NAME)
    if scan.lex == Lex.DOT then
        if x.item ~= "Module" then
            ErrorUnit.Expect("name of module before dot")
        end
        scan.NextLex()
        Check(Lex.NAME)
        local key = x.name.."."..scan.name
        x = Table.Find(key)
        if x.item ~= "Proc" then
            ErrorUnit.Expect("procedure")
        end
        scan.NextLex()
    elseif x.item ~= "Proc" then
        ErrorUnit.Expect("procedure name")
    end
    if scan.lex == Lex.LPAR then
        scan.NextLex()
        Procedure(x)
        Skip(Lex.RPAR)
    elseif x.name == "Out.Ln" then
        gen.Cmd(ovm.LN)
    elseif x.name ~= "Out.Ln" and x.name ~= "In.Open" then
        ErrorUnit.Expect("Out.Ln or In.Open")
    end
end

function AssOrCall()
    Check(Lex.NAME)
    local x = Table.Find(scan.name)
    -- print() 
    -- print("type(x):"..type(x))
    -- print()
    -- print("type(Items.Var):"..type(Items.Var)) --отладка
    -- print()
    if x.item == "Var" then
        AssStatement(x)
    elseif x.item == "Proc" or x.item == "Module" then
        CallStatement(x)
    else
        ErrorUnit.Expect("name of function or variable")
    end
end

function IfStatement()
    Skip(Lex.IF)
    BoolExpr()
    CondPC = gen.PC
    LastGOTO = 0
    Skip(Lex.THEN)
    StatSeq()
    while scan.lex == Lex.ELSIF do
        gen.Cmd(LastGOTO)
        gen.Cmd(ovm.GOTO)
        LastGOTO = gen.PC
        gen.fixup(CondPC, gen.PC)
        scan.NextLex()
        BoolExpr()
        CondPC = gen.PC
        Skip(Lex.THEN)
        StatSeq()
    end
    if scan.lex == Lex.ELSE then
        gen.Cmd(LastGOTO)
        gen.Cmd(ovm.GOTO)
        LastGOTO = gen.PC
        gen.Fixup(CondPC, gen.PC)
        scan.NextLex()
        StatSeq()
    else
        gen.Fixup(CondPC, gen.PC)
    end
    Skip(Lex.END)
    gen.Fixup(LastGOTO, gen.PC)
end

function TestBool(T)
    if T ~= Types.Bool then
        ErrorUnit.Expect("boolean statement")
    end
end

function BoolExpr()
    local T = Expression()
    TestBool(T)
end

function WhileStatement()
    local WhilePC = gen.PC
    Skip(Lex.WHILE)
    BoolExpr()
    local CondPC = gen.PC
    Skip(Lex.DO)
    StatSeq()
    Skip(Lex.END)
    gen.Cmd(WhilePC)
    gen.Cmd(ovm.GOTO)
    gen.Fixup(CondPC, gen.PC)
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
        local module = scan.name
        Table.New(Items.Module:new(module))
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
    Check(Lex.NAME)
    -- local x = Table.Find(scan.name)
    -- if x.name ~= Items.Module then
    --     ErrorUnit.Expect("other module name")
    -- elseif x.name ~= module.name then
    --     ErrorUnit.Expect("module name "..module)
    -- end
    -- scan.NextLex()
    -- Skip(Lex.DOT)
    gen.Cmd(ovm.STOP)
    -- AllocVars()
end

function AllocVars()
    local vars = Table.GetVars()
    for v = 1, #vars do
        if vars[v].lastUse > 0 then
            gen.fixup(vars[v].lastUse, gen.PC)
            gen.Cmd(0)
        else
            ErrorUnit.Warning("variable "..vars[v].name.." объявлена, но не используется")
        end
    end
end

function pars.Compile()
    text.NextCh()
    scan.name = text.ch
    scan.NextLex()
    Table.OpenScope()

    T = Types

    Table.Add(Items.Func:new("ABS", T.Int))
    Table.Add(Items.Func:new("MAX", T.Int))
    Table.Add(Items.Func:new("MIN", T.Int))
    Table.Add(Items.Func:new("ODD", T.Bool))
    Table.Add(Items.Proc:new("HALT"))
    Table.Add(Items.Proc:new("INC"))
    Table.Add(Items.Proc:new("DEC"))
    Table.Add(Items.Proc:new("In.Open"))
    Table.Add(Items.Proc:new("In.Int"))
    Table.Add(Items.Proc:new("Out.Int"))
    Table.Add(Items.Proc:new("Out.Ln"))
    -- Table.Add(Items.Proc:new("Out.Line")) --сам добавил
    Table.Add(Items.Type:new("INTEGER", T.Int))

    Table.OpenScope()
    Module()
    Table.CloseScope()
    Table.CloseScope()
    print("\n")
end

return pars