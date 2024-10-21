--ovm
local ovm = {
    MEM_SIZE = 8 * 1024,

    STOP = -1,
    ADD = -2,
    SUB = -3,
    MULT = -4,
    DIV = -5,
    MOD = -6,
    NEG = -7,
    LOAD = -8,
    SAVE = -9,
    DUP = -10,
    DROP = -11,
    SWAP = -12,
    OVER = -13,
    GOTO = -14,
    IFLT = -15,
    IFLE = -16,
    IFGT = -17,
    IFGE = -18,
    IFEQ = -19,
    IFNE = -20,
    IN = -21,
    OUT = -22,
    LN = -23,
    _mnemo = {
        [1]="",
        [2]="STOP",
        [3]="ADD",
        [4]="SUB",
        [5]="MULT",
        [6]="DIV",
        [7]="MOD",
        [8]="NEG",
        [9]="LOAD",
        [10]="SAVE",
        [11]="DUP",
        [12]="DROP",
        [13]="SWAP",
        [14]="OVER",
        [15]="GOTO",
        [16]="IFLT",
        [17]="IFLE",
        [18]="IFGT",
        [19]="IFGE",
        [20]="IFEQ",
        [21]="IFNE",
        [22]="IN",
        [23]="OUT",
        [24]="LN"
    }
}
--imports
local ErrorUnit = require("ErrorUnit")

ovm.PC = 0
ovm.M = {}
for i = 1, ovm.MEM_SIZE do
    ovm.M[i] = ovm.STOP
end

function ovm.PrintCode(PC)
    for pc = 1, PC do
        if ovm.M[pc] >= 0 then
            print(pc..") "..ovm.M[pc])
        else 
            print(ovm._mnemo[-ovm.M[pc]])
        end
    end
end


function ovm.Run()
    -- print("ovm.Run()")
    --     ovm.PC = 0
    -- SP = MEM_SIZE
    -- cnt = 0
    -- while true do
    --     local cnt += 1
    --     cmd = M[PC]
    --     PC = PC + 1
    --     if cmd >= 0:
    --         SP -= 1
    --         M[SP] = cmd
    --     elif cmd == ADD:
    --         SP += 1
    --         M[SP] = M[SP] + M[SP - 1]
    --     elif cmd == SUB:
    --         SP += 1
    --         M[SP] = M[SP] - M[SP - 1]
    --     elif cmd == MULT:
    --         SP += 1
    --         M[SP] = M[SP] * M[SP - 1]
    --     elif cmd == DIV:
    --         SP += 1
    --         M[SP] = M[SP] // M[SP - 1]
    --     elif cmd == MOD:
    --         SP += 1
    --         M[SP] = M[SP] % M[SP - 1]
    --     elif cmd == NEG:
    --         M[SP] = -M[SP]
    --     elif cmd == LOAD:
    --         M[SP] = M[M[SP]]
    --     elif cmd == SAVE:
    --         M[M[SP + 1]] = M[SP]
    --         SP += 2
    --     elif cmd == DUP:
    --         M[SP - 1] = M[SP]
    --         SP -= 1
    --     elif cmd == DROP:
    --         SP += 1
    --     elif cmd == SWAP:
    --         temp = M[SP]
    --         M[SP] = M[SP + 1]
    --         M[SP + 1] = temp
    --     elif cmd == OVER:
    --         SP -= 1
    --         M[SP] = M[SP + 2]
    --     elif cmd == GOTO:
    --         PC = M[SP]
    --         SP += 1
    --     elif cmd == IFEQ:
    --         if M[SP + 2] == M[SP + 1]:
    --             PC = M[SP]
    --         SP += 3
    --     elif cmd == IFNE:
    --         if M[SP + 2] != M[SP + 1]:
    --             PC = M[SP]
    --         SP += 3
    --     elif cmd == IFLT:
    --         if M[SP + 2] < M[SP + 1]:
    --             PC = M[SP]
    --         SP += 3
    --     elif cmd == IFLE:
    --         if M[SP + 2] <= M[SP + 1]:
    --             PC = M[SP]
    --         SP += 3
    --     elif cmd == IFGT:
    --         if M[SP + 2] > M[SP + 1]:
    --             PC = M[SP]
    --         SP += 3
    --     elif cmd == IFGE:
    --         if M[SP + 2] >= M[SP + 1]:
    --             PC = M[SP]
    --         SP += 3
    --     elif cmd == IN:
    --         SP -= 1
    --         try:
    --             M[SP] = int(input("?"))
    --         except:
    --             error.Error("Неправильный ввод")
    --     elif cmd == OUT:
    --         print(f"{M[SP + 1]:{M[SP]}}", end="")
    --         SP += 2
    --     elif cmd == LN:
    --         print()
    --     elif cmd == STOP:
    --         break
    --     else:
    --         error.Error("Недопустимая команда")
end


return ovm

-- # Виртуальная машина

-- import error

-- STOP = -1
-- ADD = -2
-- SUB = -3
-- MULT = -4
-- DIV = -5
-- MOD = -6
-- NEG = -7
-- LOAD = -8
-- SAVE = -9
-- DUP = -10
-- DROP = -11
-- SWAP = -12
-- OVER = -13
-- GOTO = -14
-- IFLT = -15
-- IFLE = -16
-- IFGT = -17
-- IFGE = -18
-- IFEQ = -19
-- IFNE = -20
-- IN = -21
-- OUT = -22
-- LN = -23

-- MEM_SIZE = 8 * 1024

-- M = [STOP] * MEM_SIZE

-- _mnemo = [
--     "",
--     "STOP",
--     "ADD",
--     "SUB",
--     "MULT",
--     "DIV",
--     "MOD",
--     "NEG",
--     "LOAD",
--     "SAVE",
--     "DUP",
--     "DROP",
--     "SWAP",
--     "OVER",
--     "GOTO",
--     "IFLT",
--     "IFLE",
--     "IFGT",
--     "IFGE",
--     "IFEQ",
--     "IFNE",
--     "IN",
--     "OUT",
--     "LN"
-- ]