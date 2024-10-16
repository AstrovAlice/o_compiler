--Lexemes

local lexemes = {
    Lex = {
        NONE = "NONE",
        NAME = "NAME",
        NUM = "NUM",
        MODULE = "MODULE",
        IMPORT = 4,
        BEGIN = 5,
        END = "END",
        CONST = "CONST",
        VAR = 8,
        WHILE = 9,
        DO = 10,
        IF = 11,
        THEN = 12,
        ELSIF = 13,
        ELSE = 14,
        MULT = 15,
        DIV = 16,
        MOD = 17,
        PLUS = 18,
        MINUS = 19,
        EQ = 20,
        NE = 21,
        LT = 22,
        LE = 23,
        GT = 24,
        GE = 25,
        DOT = ".",
        COMMA = ",",
        COLON = 28,
        SEMI = ";",
        ASS = 30,
        SASS = 31,
        LPAR = 32,
        RPAR = 33,
        EOT = 34
    }
}

return lexemes.Lex