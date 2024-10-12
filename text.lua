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

function text.Reset()
    -- if #arg < 2 then
    --     error.Error("Запуск: lua O.lua <файл программы>")
    -- else
    --     -- Пытаемся открыть файл
    --     local file, err = io.open(arg[2], "r")
    --     if not file then
    --         error.Error("Ошибка открытия файла: " .. err)
    --     end

    --     local content, read_err = file:read("*a")
    --     if not content then
    --         file:close()
    --         error.Error("Ошибка чтения файла: " .. read_err)
    --     end

    --     text._src = content
    --     file:close()
    -- end
end

function text.NextCh()
    if text._i < #text._src then
        text.ch = text._src:sub(text._i, text._i) 
        io.write(text.ch) 
        loc.pos = loc.pos + 1
        text._i = text._i + 1
        if text.ch == '\n' or text.ch == '\r' then
            text.ch = text.chEOL 
            loc.pos = 0
        end
    else
        text.ch = text.chEOT  -- Конец файла
    end
end

return text