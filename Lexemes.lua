--Lexemes

local lexemes = {
    Lex = {
        NONE = "NONE",
        NAME = "NAME",
        NUM = "NUM",
        MODULE = "MODULE",
        IMPORT = "IMPORT",
        BEGIN = "BEGIN",
        END = "END",
        CONST = "CONST",
        VAR = "VAR",
        WHILE = "WHILE",
        DO = "DO",
        IF = "IF",
        THEN = "THEN",
        ELSIF = "ELSEIF",
        ELSE = "ELSE",
        MULT = "MULT",
        DIV = "DIV",
        MOD = "MOD",
        PLUS = "+",
        MINUS = "-",
        EQ = "=",
        NE = "#",
        LT = "<",
        LE = "<=",
        GT = ">",
        GE = ">=",
        DOT = ".",
        COMMA = ",",
        COLON = ":",
        SEMI = ";",
        ASS = ":=",
        SASS = "ВОТ ТУТ ВОТ ЧЕСТНО НЕ ЕБУ ВООБЩЕ", --исправить
        LPAR = "(",
        RPAR = ")",
        EOT = require('text').chEOT
    }
}

return lexemes.Lex