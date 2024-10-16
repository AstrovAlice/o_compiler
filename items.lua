--items

local items = {

}

-- Module = {}
-- Module.__index = Module

-- function Module:new(name)
--     assert(type(name) == "string")
--     local obj = setmetatable({}, Module)
--     obj.name = name
--     return obj
-- end

-- -- Определяем класс Const
-- Const = {}
-- Const.__index = Const

-- function Const:new(name, typ, value)
--     assert(type(name) == "string")
--     local obj = setmetatable({}, Const)
--     obj.name = name
--     obj.typ = typ
--     obj.value = value
--     return obj
-- end

-- -- Определяем класс Var
-- Var = {}
-- Var.__index = Var

-- function Var:new(name, typ)
--     assert(type(name) == "string")
--     local obj = setmetatable({}, Var)
--     obj.name = name
--     obj.typ = typ
--     obj.lastUse = 0
--     return obj
-- end

-- -- Определяем класс Type
-- Type = {}
-- Type.__index = Type

-- function Type:new(name, typ)
--     assert(type(name) == "string")
--     local obj = setmetatable({}, Type)
--     obj.name = name
--     obj.typ = typ
--     return obj
-- end

-- -- Определяем класс Func
-- Func = {}
-- Func.__index = Func

-- function Func:new(name, typ)
--     assert(type(name) == "string")
--     local obj = setmetatable({}, Func)
--     obj.name = name
--     obj.typ = typ
--     return obj
-- end

-- -- Определяем класс Proc
-- Proc = {}
-- Proc.__index = Proc

-- function Proc:new(name)
--     assert(type(name) == "string")
--     local obj = setmetatable({}, Proc)
--     obj.name = name
--     return obj
-- end

-- -- Определяем класс ShortVar
-- ShortVar = {}
-- ShortVar.__index = ShortVar

-- function ShortVar:new(name)
--     local obj = setmetatable({}, ShortVar)
--     obj.name = name
--     return obj
-- end

return items