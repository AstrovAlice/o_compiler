--Table
local Table = {}

--imports
local items = require("items")
local ErrorUnit = require("ErrorUnit")

--var


--function for Table only
function OpenScope()
    Table._table.append({})
end

function CloseScope()
    Table._table.pop()
end

function Add(item)
    last = Table._table[#Table._table]
    last[item.name] = item
end

--function
function Table.New(item)
    local last = Table._table[#Table._table]
    if item.name ~= last then                                                                  --!!!
        ErrorUnit.CtxError("Повторное объявление имени")
    else
        Add(item)
    end
end

return Table
-- def new(item):
--     last = _table[-1]
--     if item.name in last:
--         error.ctxError("Повторное объявление имени")
--     else:
--         add(item)


-- def find(name):
--     for block in reversed(_table):
--         if name in block:
--             return block[name]
--     error.ctxError("Необъявленное имя")


-- def getVars():
--     vars = []
--     lastBlock = _table[-1]
--     for item in lastBlock.values():
--         if type(item) == items.Var:
--             vars.append(item)
--     return vars