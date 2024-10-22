--gen
local gen = {}
--imports
local ovm = require("ovm")
local Lex = require("Lexemes")

gen.PC = 0

function gen.Cmd(cmd)
    ovm.M[gen.PC] = cmd
    gen.PC = gen.PC + 1
end

function gen.Const(c)
    gen.Cmd(math.abs(c))
    if c < 0 then
        gen.Cmd(ovm.NEG)
    end
end

function gen.Addr(v)
    gen.Cmd(v.lastUse)
    v.lastUse = gen.PC + 1
end

function gen.Comp(op)
    gen.Cmd(0)
    if op == Lex.EQ then
        gen.Cmd(ovm.IFNE)
    elseif op == Lex.NE then
        gen.Cmd(ovm.IFEQ)
    elseif op == Lex.GE then
        gen.Cmd(ovm.IFLT)
    elseif op == Lex.GT then
        gen.Cmd(ovm.IFLE)
    elseif op == Lex.LE then
        gen.Cmd(ovm.IFGT)
    elseif op == Lex.LT then
        gen.Cmd(ovm.IFGE)
    end
end

function gen.Fixup(A, PC)
    while A > 0 do
        local temp = ovm.M[A - 2]
        ovm.M[A - 2] = PC
        A = temp
    end
end

return gen