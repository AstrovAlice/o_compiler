-- text
local loc = require("loc")
local error = require("error")

local text = {
    chEOT = "\0",
    chEOL = "\n",
    chSPACE = ' ',
    chTAB = '\t',

    _src = nil,
    _i = 0,
    ch = ""
}

function text.Reset(args)
    local args = {"", "test\\Prime.o"}
    if #args < 2 then
        error.Error("Запуск: lua O.lua <файл программы>")
    else
        -- Пытаемся открыть файл
        local file, err = io.open(args[2], "r")
        if not file then
            error.Error("Ошибка открытия файла: " .. err)
        end

        local content, read_err = file:read("*a")
        if not content then
            file:close()
            error.Error("Ошибка чтения файла: " .. read_err)
        end

        text._src = content
        file:close()
    end
end

function text.NextCh()
    if text._i < #text._src then
        text.ch = text._src[text._i]
        text.ch = string.sub(text._src, text._i, text._i)
        io.write(text.ch)
        loc.pos = loc.pos + 1
        text._i = text._i + 1
        if text.ch == '\n' or text.ch == '\r' then
            text.ch = text.chEOL
            loc.pos = 0
        end
    else
        text.ch = text.chEOT
    end
end

return text