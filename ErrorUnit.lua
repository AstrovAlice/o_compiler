--ErrorUnit

local loc = require("loc")
-- local text = require("text")

local ErrorUnit = {}

function ErrorUnit._error(msg, p)
    -- while text.ch ~= text.chEOL and text.ch ~= text.chEOT do                                 нет возможности добавить сюда text, тк всё ломается
    --     text.NextCh()
    -- end
    print()
    print(string.rep(' ', p - 1) .. '^')
    print(msg)
    os.exit(1)
end

function LexError(msg)
    ErrorUnit._error(msg, loc.pos)
end

function Expect(msg)
    ErrorUnit._error("expect "..msg, loc.lexPos)
end

function CtxError(msg)
    ErrorUnit._error(msg, loc.lexPos)
end

function Error(msg)
    print()
    print(msg)
    os.exit(2)
end

function Warmimg(msg)
    print()
    print(msg)
end

return ErrorUnit