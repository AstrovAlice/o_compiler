--scan

local error = require("error")
local text = require("text")
local loc = require("loc")

local Lex = require("Lexemes").Lex

local scan = {
    MAXINT = 0x7FFFFFFF,
    lex = Lex.NONE,
    num = 0,
    name = "",
    semicolon = false,
    _kw = {
        ["module"] = Lex.MODULE,
        ["import"] = Lex.IMPORT,
        ["const"] = Lex.CONST,
        ["var"] = Lex.VAR,
        ["begin"] = Lex.BEGIN,
        ["end"] = Lex.END,
        ["if"] = Lex.IF,
        ["then"] = Lex.THEN,
        ["elsif"] = Lex.ELSIF,
        ["else"] = Lex.ELSE,
        ["while"] = Lex.WHILE,
        ["do"] = Lex.DO,
        ["div"] = Lex.DIV,
        ["mod"] = Lex.MOD,
        ["array"] = Lex.NONE,
        ["record"] = Lex.NONE,
        ["pointer"] = Lex.NONE,
        ["set"] = Lex.NONE,
        ["with"] = Lex.NONE,
        ["case"] = Lex.NONE,
        ["of"] = Lex.NONE,
        ["loop"] = Lex.NONE,
        ["exit"] = Lex.NONE,
        ["procedure"] = Lex.NONE,
        ["for"] = Lex.NONE,
        ["to"] = Lex.NONE,
        ["by"] = Lex.NONE,
        ["in"] = Lex.NONE,
        ["is"] = Lex.NONE,
        ["nil"] = Lex.NONE,
        ["or"] = Lex.NONE,
        ["type"] = Lex.NONE,
        ["repeat"] = Lex.NONE,
        ["until"] = Lex.NONE,
        ["return"] = Lex.NONE
    }
}



return scan