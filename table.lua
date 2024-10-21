--Table
local Table = {
    _table = {}
}

--imports
local Items = require("Items")
local ErrorUnit = require("ErrorUnit")


--function for Table only
function Table.OpenScope()
    table.insert(Table._table, {})
end

function Table.CloseScope()
    Table._table.pop()
end

function Table.Add(item)
    local last = Table._table[#Table._table]
    last[item.name] = item
end

--function
function Table.New(item)
    local last = Table._table[#Table._table]
    if item.name == last.name then
        ErrorUnit.CtxError("Re-announcement of name")
    else
        Table.Add(item)
    end
end

function Table.Find(name)
    for i = #Table._table, 1, -1 do
        local block = Table._table[i]
        if block[name] then
            return block[name]
        end
    end
    -- error("non declared name")
end

function Table.GetVars()
    local vars = {}
    local lastBlock = Table._table[#Table._table]
    for item in lastBlock.values() do
        if type(item) == Items.Var then
            vars.append(item)
        end
    end
    return vars
end

return Table