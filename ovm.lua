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
for i = 0, ovm.MEM_SIZE do
    ovm.M[i] = ovm.STOP
end

function ovm.PrintCode(PC)
    for pc = 1, PC do
        if ovm.M[pc] >= 0 then
            print(pc..') '.. ovm.M[pc])
        else
            print(pc..') '.. ovm._mnemo[-ovm.M[pc]])
        end
    end
end

function GetInput()
    io.write("? ")
    return tonumber(io.read())
end

function ovm.Run()
    local PC = 0
    local SP = ovm.MEM_SIZE
    local cnt = 0

    while true do
        cnt = cnt + 1
        local cmd = ovm.M[PC]
        PC = PC + 1
        if cmd >= 0 then
            SP = SP - 1
            ovm.M[SP] = cmd
        elseif cmd == ovm.ADD then
            SP = SP + 1
            ovm.M[SP] = ovm.M[SP] + ovm.M[SP - 1]
        elseif cmd == ovm.SUB then
            SP = SP + 1
            ovm.M[SP] = ovm.M[SP] - ovm.M[SP - 1]
        elseif cmd == ovm.MULT then
            SP = SP + 1
            ovm.M[SP] = ovm.M[SP] * ovm.M[SP - 1]
        elseif cmd == ovm.DIV then
            SP = SP + 1
            ovm.M[SP] = ovm.M[SP] // ovm.M[SP - 1]
        elseif cmd == ovm.MOD then
            SP = SP + 1
            ovm.M[SP] = ovm.M[SP] % ovm.M[SP - 1]
        elseif cmd == ovm.NEG then
            ovm.M[SP] = -ovm.M[SP]
        elseif cmd == ovm.LOAD then
            ovm.M[SP] = ovm.M[ovm.M[SP]]
        elseif cmd == ovm.SAVE then
            ovm.M[ovm.M[SP + 1]] = ovm.M[SP]
            SP = SP + 2
        elseif cmd == ovm.DUP then
            ovm.M[SP - 1] = ovm.M[SP]
            SP = SP - 1
        elseif cmd == ovm.DROP then
            SP = SP + 1
        elseif cmd == ovm.SWAP then
            local temp = ovm.M[SP]
            ovm.M[SP] = ovm.M[SP + 1]
            ovm.M[SP + 1] = temp
        elseif cmd == ovm.OVER then
            SP = SP - 1
            ovm.M[SP] = ovm.M[SP + 2]
        elseif cmd == ovm.GOTO then
            PC = ovm.M[SP]
            SP = SP + 1
        elseif cmd == ovm.IFEQ then
            if ovm.M[SP + 2] == ovm.M[SP + 1] then
                PC = ovm.M[SP]
            end
            SP = SP + 3
        elseif cmd == ovm.IFNE then
            if ovm.M[SP + 2] ~= ovm.M[SP + 1] then
                PC = ovm.M[SP]
            end
            SP = SP + 3
        elseif cmd == ovm.IFLT then
            if ovm.M[SP + 2] < ovm.M[SP + 1]then
                PC = ovm.M[SP]
            end
            SP = SP + 3
        elseif cmd == ovm.IFLE then
            if ovm.M[SP + 2] <= ovm.M[SP + 1] then
                PC = ovm.M[SP]
            end
            SP = SP + 3
        elseif cmd == ovm.IFGT then
            if ovm.M[SP + 2] > ovm.M[SP + 1] then
                PC = ovm.M[SP]
            end
            SP = SP + 3
        elseif cmd == ovm.IFGE then
            if ovm.M[SP + 2] >= ovm.M[SP + 1] then
                PC = ovm.M[SP]
            end
            SP = SP + 3
        elseif cmd == ovm.IN then
            SP = SP - 1
            local success, result = pcall(GetInput)
            if success then
                ovm.M[SP] = result
            else
                ErrorUnit.Error("input is wrong")
            end
        elseif cmd == ovm.OUT then
            io.write(string.format("%" .. ovm.M[SP] .. "s", ovm.M[SP + 1]))
            SP = SP + 2
        elseif cmd == ovm.LN then
            print()
        elseif cmd == ovm.STOP then
            break
        else
            ErrorUnit.Error("command is not available")
        end
    end
end


return ovm