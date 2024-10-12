--o compiler
local text = require("text")
-- local pars = require("pars")
-- local ovm = require("ovm")
-- local gen = require("gen")

print("it's a O compiler")


-- text.Reset()
-- pars.Compile()
print("compiling is complite")
-- ovm.printCode(gen.PC)

local t1 = os.date("%H:%M:%S")
-- ovm.Run()
local t2 = os.date("%H:%M:%S")

local time = t2
print("runing time: " ..time.. "c")

text.say_hello("Sofa")
print(text.value)