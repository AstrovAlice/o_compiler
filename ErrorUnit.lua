--ErrorUnit

local loc = require("loc")
-- local ch = require("text").ch

local ErrorUnit = {}

function ErrorUnit._error(msg, p)
    -- while ch ~= chEOL and text.ch ~= text.chEOT do                                 нет возможности добавить сюда text, тк всё ломается
    --     text.NextCh()
    -- end
    print()
    print(string.rep(' ', p - 1) .. '^')
    print(msg)
    os.exit(1)
end

function ErrorUnit.LexError(msg)
    ErrorUnit._error(msg, loc.pos)
end

function ErrorUnit.Expect(msg)
    ErrorUnit._error("expect "..msg, loc.lexPos)
end

function ErrorUnit.CtxError(msg)
    ErrorUnit._error(msg, loc.lexPos)
end

function ErrorUnit.Error(msg)
    print()
    print(msg)
    os.exit(2)
end

function ErrorUnit.Warmimg(msg)
    print()
    print(msg)
end

return ErrorUnit