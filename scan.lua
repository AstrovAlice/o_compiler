--scan

local ErrorUnit = require("ErrorUnit")
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
    },
    _names = {
        [Lex.NAME]  = "имя",
        [Lex.NUM]   = "число",
        [Lex.MULT]  =  "*",
        [Lex.PLUS]  = "+",
        [Lex.MINUS] = "-",
        [Lex.EQ]    = "=",
        [Lex.NE]    = "#",
        [Lex.LT]    = "<",
        [Lex.LE]    = "<=",
        [Lex.GT]    = ">",
        [Lex.GE]    = ">=",
        [Lex.DOT]   = ".",
        [Lex.COMMA] = ",",
        [Lex.COLON] = ":",
        [Lex.SEMI]  = ";",
        [Lex.ASS]   =  ":=",
        [Lex.LPAR]  =  "(",
        [Lex.RPAR]  =  ")",
        [Lex.EOT]   = "конец текста"
    }
}

function scan.lexName(L)
    return scan._names[L] or L.name
end

function scan.scanIdent()
    local name = text.ch
    text.NextCh()
    while "A" <= text.ch and text.ch <= "Z" or "a" <= text.ch and text.ch <= "z" or "0" <= text.ch and text.ch <= "9" do
        name = name..text.ch
        text.NextCh()
    end
    scan.lex = Lex.NONE
    --lex = _kw.get(name, Lex.NAME)
end

function scan.NextLex()
    while text.ch == " " or text.ch == "\t" or text.ch == "\r" or text.ch == "\n" do
        text.NextCh()
    end
    scan.lexPos = text.pos
    if "A" <= text.ch and text.ch <= "Z" or "a" <= text.ch and text.ch <= "z" then
        return scan.scanIdent()
    elseif "0" <= text.ch and text.ch <= "9" then
        return scan.scanNumber()
    elseif text.ch == ";" then
        text.NextCh()
        return Lex.SEMICOLON
    elseif text.ch== ":" then
        text.NextCh()
        if text.ch == "=" then
            text.NextCh()
            return Lex.ASSIGN
        else
            return Lex.COLON
        end
    elseif text.ch == "," then
        text.NextCh()
        return Lex.COMMA
    elseif text.ch == "(" then
        text.NextCh()
        if text.ch == "*" then
            text.NextCh()
            scan.skipComment()
            return scan()
        else
            return Lex.LPAR
        end
    elseif text.ch == ")" then
        text.NextCh()
        return Lex.RPAR
    elseif text.ch == "." then
        text.NextCh()
        return Lex.DOT
    elseif text.ch == "+" then
        text.NextCh()
        return Lex.PLUS
    elseif text.ch == "-" then
        text.NextCh()
        return Lex.MINUS
    elseif text.ch == "*" then
        text.NextCh()
        return Lex.MULTIPLY
    elseif text.ch == "=" then
        text.NextCh()
        return Lex.EQ
    elseif text.ch == "#" then
        text.NextCh()
        return Lex.NE
    elseif text.ch == "<" then
        text.NextCh()
        if text.ch == "=" then
            text.NextCh()
            return Lex.LE
        else
            return Lex.LT
        end
    elseif text.ch == ">" then
        text.NextCh()
        if text.ch == "=" then
            text.NextCh()
            return Lex.GE
        else
            return Lex.GT
        end
    elseif text.ch == text.chEOT then
        return Lex.EOT
    else
        print(text.ch)
        ErrorUnit.Error("недопустимый символ")
    end
end

return scan