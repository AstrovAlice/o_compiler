--o compiler
local text = require("text")
local pars = require("pars")
local ovm = require("ovm")
local gen = require("gen")

print("it's a O-compiler")


text.Reset()
pars.Compile()

print("compiling is complite")
ovm.PrintCode(gen.PC)

local start_time = os.clock()
ovm.Run()
local end_time = os.clock()

print("runing time: " ..(end_time - start_time).. "c")