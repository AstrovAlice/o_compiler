-- text
local loc = require("loc")
local ErrorUnit = require("ErrorUnit")

local text = {
    chEOT = "\0", --конец текста
    chEOL = "\n", --конец строки
    chSPACE = " ", --пробел
    chTAB = "\t", --Табуляция

    _src = nil, --текст
    _i = 1, --позиция в тексте
    ch = "" --символ
}

--загрузка файла в text._src
function text.Reset()
    local args = {"", "test\\Prime.o"}
    if #args < 2 then
        ErrorUnit.Error("LOL")
    else
        -- Пытаемся открыть файл
        local file, err
        
        file, err = io.open(args[2], "r")--local убран, чтобы глаза подсветка предупреждений не морочила
        if not file then
            ErrorUnit.Error("cant open file: " .. err)
        end

        local content, read_err = file:read("*a")
        if not content then
            file:close()
            ErrorUnit.Error("dont read: " .. read_err)
        end

        text._src = content
        file:close()
    end
end

--взятие следующего символа (неглобальная функция)
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