--o compiler
local text = require("text")
local pars = require("pars")
local ovm = require("ovm")
local gen = require("gen")

print("it's a O-compiler")


text.Reset() --Подготовка текста к прочтению
pars.Compile() --компиляция/создание кода

print("compiling is complite")
ovm.PrintCode(gen.PC) --вывод скомпилированного кода

local start_time = os.clock()
ovm.Run() --старт программы
local end_time = os.clock()

print("runing time: " ..(end_time - start_time).. "c")