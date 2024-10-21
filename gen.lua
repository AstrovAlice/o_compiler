--gen
local gen = {}
--imports
local ovm = require("ovm")
local Lex = require("Lexemes").Lex

gen.PC = 0

function gen.Cmd(cmd)
    -- ovm.M[gen.PC] = cmd
    -- gen.PC = gen.PC + 1
end

function gen.Const(c)
    -- gen.Cmd(abs(c))
    -- if c < 0 then
    --     gen.Cmd(cm.NEG)
    -- end
end

function gen.Addr(v)
    gen.Cmd(v.lastUse)
    v.lastUse = gen.PC + 1
end

function Comp(op)
    -- gen.Cmd(0)
    -- if op == Lex.EQ then
    --     gen.Cmd(cm.IFNE)
    -- elseif op == Lex.NE then
    --     gen.Cmd(cm.IFEQ)
    -- elseif op == Lex.GE then
    --     gen.Cmd(cm.IFLT)
    -- elseif op == Lex.GT then
    --     gen.Cmd(cm.IFLE)
    -- elseif op == Lex.LE then
    --     gen.Cmd(cm.IFGT)
    -- elseif op == Lex.LT then
    --     gen.Cmd(cm.IFGE)
end

function Fixup(A, PC)
    while A > 0 do
        local temp = ovm.M[A - 2]
        ovm.M[A - 2] = PC
        A = temp
    end
end

return gen