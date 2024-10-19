--Table
local Table = {
    _table = {}
}

--imports
local items = require("items")
local ErrorUnit = require("ErrorUnit")


--function for Table only
function OpenScope()
    Table._table.append({})
end

function CloseScope()
    Table._table.pop()
end

function Add(item)
    local last = Table._table[#Table._table]
    last[item.name] = item
end

--function
function Table.New(item)
    local last = Table._table[#Table._table]
    if item.name ~= last then
        ErrorUnit.CtxError("secend initialising of this name")
    else
        Add(item)
    end
end

function Table.find(name)
    for i = #Table._table, 1, -1 do
        local block = Table._table[i]
        if block[name] then
            return block[name]
        end
    end
    error("non declared name")
end

function Table.GetVars()
    local vars = {}
    local lastBlock = Table._table[#Table._table]
    for item in lastBlock.values() do
        if type(item) == items.Var then
            vars.append(item)
        end
    end
    return vars
end

return Table