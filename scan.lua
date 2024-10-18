--scan

local ErrorUnit = require("ErrorUnit")
local text = require("text")
local loc = require("loc")

local Lex = require("Lexemes")

local scan = {
    MAXINT = 0x7FFFFFFF,
    lex = Lex.NONE,
    num = 0,
    name = "",
    semicolon = false,
    _kw = {
        ["ARRAY"] = Lex.NONE,
        ["BEGIN"] = Lex.BEGIN,
        ["BY"] = Lex.NONE,
        ["CASE"] = Lex.NONE,
        ["CONST"] = Lex.CONST,
        ["DIV"] = Lex.DIV,
        ["DO"] = Lex.DO,
        ["ELSE"] = Lex.ELSE,
        ["ELSIF"] = Lex.ELSIF,
        ["END"] = Lex.END,
        ["EXIT"] = Lex.NONE,
        ["FOR"] = Lex.NONE,
        ["IF"] = Lex.IF,
        ["IMPORT"] = Lex.IMPORT,
        ["IN"] = Lex.NONE,
        ["IS"] = Lex.NONE,
        ["LOOP"] = Lex.NONE,
        ["MOD"] = Lex.MOD,
        ["MODULE"] = Lex.MODULE,
        ["NIL"] = Lex.NONE,
        ["OF"] = Lex.NONE,
        ["OR"] = Lex.NONE,
        ["POINTER"] = Lex.NONE,
        ["PROCEDURE"] = Lex.NONE,
        ["RECORD"] = Lex.NONE,
        ["REPEAT"] = Lex.NONE,
        ["RETURN"] = Lex.NONE,
        ["THEN"] = Lex.THEN,
        ["TO"] = Lex.NONE,
        ["TYPE"] = Lex.NONE,
        ["UNTIL"] = Lex.NONE,
        ["VAR"] = Lex.VAR,
        ["WHILE"] = Lex.WHILE,
        ["WITH"] = Lex.NONE
    },
    _names = {
        [Lex.NAME]  = "name",
        [Lex.NUM]   = "number",
        [Lex.MULT]  = "*",
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
        [Lex.ASS]   = ":=",
        [Lex.LPAR]  = "(",
        [Lex.RPAR]  = ")",
        [Lex.EOT]   = "end of text"
    }
}

function scan.lexName(L)
    return scan._names[L] or L.name
end

function scan.scanIdent()
    scan.name = text.ch
    text.NextCh()
    while "A" <= text.ch and text.ch <= "Z" or "a" <= text.ch and text.ch <= "z" or "0" <= text.ch and text.ch <= "9" do
        scan.name = scan.name..text.ch
        text.NextCh()
    end
    if scan._kw[scan.name] then
        return scan._kw[scan.name]
    else
        return Lex.NAME
    end
end

function scan.scanNumber()
    assert(text.ch >= "0" and text.ch <= "9")
    scan.value = string.byte(text.ch) - string.byte("0")
    text.NextCh()
    while (text.ch >= "0" and text.ch <= "9") do
        local d = string.byte(text.ch) - string.byte("0")
        scan.value = scan.value * 10 + d
        if scan.value > scan.MAXINT then
            error(string.format("слишком большое число, максимум %d", scan.MAXINT))
        end
        text.NextChar()
    end
    return Lex.NUM
end

function scan.NextLex()
    while text.ch == " " or text.ch == "\t" or text.ch == "\r" or text.ch == "\n" do
        text.NextCh()
    end
    scan.lexPos = text.pos
    if "A" <= text.ch and text.ch <= "Z" or "a" <= text.ch and text.ch <= "z" then
        scan.lex = scan.scanIdent()
    elseif "0" <= text.ch and text.ch <= "9" then
        scan.lex = scan.scanNumber()
    elseif text.ch == ";" then
        text.NextCh()
        scan.lex = Lex.SEMI
    elseif text.ch== ":" then
        text.NextCh()
        if text.ch == "=" then
            text.NextCh()
            scan.lex = Lex.ASSIGN
        else
            scan.lex = Lex.COLON
        end
    elseif text.ch == "," then
        text.NextCh()
        scan.lex = Lex.COMMA
    elseif text.ch == "(" then
        text.NextCh()
        if text.ch == "*" then
            text.NextCh()
            scan.skipComment()
            scan.lex = scan()
        else
            scan.lex = Lex.LPAR
        end
    elseif text.ch == ")" then
        text.NextCh()
        scan.lex = Lex.RPAR
    elseif text.ch == "." then
        text.NextCh()
        scan.lex = Lex.DOT
    elseif text.ch == "+" then
        text.NextCh()
        scan.lex = Lex.PLUS
    elseif text.ch == "-" then
        text.NextCh()
        scan.lex = Lex.MINUS
    elseif text.ch == "*" then
        text.NextCh()
        scan.lex = Lex.MULTIPLY
    elseif text.ch == "=" then
        text.NextCh()
        scan.lex = Lex.EQ
    elseif text.ch == "#" then
        text.NextCh()
        scan.lex = Lex.NE
    elseif text.ch == "<" then
        text.NextCh()
        if text.ch == "=" then
            text.NextCh()
            scan.lex = Lex.LE
        else
            scan.lex = Lex.LT
        end
    elseif text.ch == ">" then
        text.NextCh()
        if text.ch == "=" then
            text.NextCh()
            scan.lex = Lex.GE
        else
            scan.lex = Lex.GT
        end
    elseif text.ch == text.chEOT then
        scan.lex = Lex.EOT
    else
        print(text.ch)
        ErrorUnit.Error("недопустимый символ")
    end
end

return scan