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
        EQ = 20,
        NE = 21,
        LT = 22,
        LE = 23,
        GT = 24,
        GE = 25,
        DOT = ".",
        COMMA = ",",
        COLON = ":",
        SEMI = ";",
        ASS = ":=",
        SASS = 31,
        LPAR = 32,
        RPAR = 33,
        EOT = 34
    }
}

return lexemes.Lex