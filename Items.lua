--items
local Items = {}

--модули
Items.Module = {}
function Items.Module:new(OBJname)
    assert(type(OBJname) == "string")
    local obj= {
        item = "Module",
        --поля:
        name = OBJname
    }
    setmetatable(obj, self)
    self.__index = self; return obj
end

--константы
Items.Const = {}
function Items.Const:new(OBJname, OBJtype, OBJvalue)
    assert(type(OBJname) == "string")
    local obj= {
        item = "Const",
        --поля:
        name = OBJname,
        type = OBJtype,
        value = OBJvalue
    }
    setmetatable(obj, self)
    self.__index = self; return obj
end

--переменные
Items.Var = {}
function Items.Var:new(OBJname, OBJtype)
    assert(type(OBJname) == "string")
    local obj= {
        item = "Var",
        --поля:
        name = OBJname,
        type = OBJtype,
        lastUse = 0
    }
    setmetatable(obj, self)
    self.__index = self; return obj
end

--типизация
Items.Type = {}
function Items.Type:new(OBJname, OBJtype)
    assert(type(OBJname) == "string")
    local obj= {
        item = "Type",
        --поля:
        name = OBJname,
        type = OBJtype
    }
    setmetatable(obj, self)
    self.__index = self; return obj
end

--функции
Items.Func = {}
function Items.Func:new(OBJname, OBJtype)
    assert(type(OBJname) == "string")
    local obj= {
        item = "Func",
        --поля:
        name = OBJname,
        type = OBJtype
    }
    setmetatable(obj, self)
    self.__index = self; return obj
end

--процедуры
Items.Proc = {}
function Items.Proc:new(OBJname)
    assert(type(OBJname) == "string")
    local obj= {
        item = "Proc",
        --поля:
        name = OBJname
    }
    setmetatable(obj, self)
    self.__index = self; return obj
end

return Items

--пример из интернета: 
--https://habr.com/ru/articles/259265/

-- --класс
-- Person= {}
-- --тело класса
-- function Person:new(fName, lName)

--     -- свойства
--     local obj= {}
--         obj.firstName = fName
--         obj.lastName = lName

--     -- метод
--     function obj:getName()
--         return self.firstName 
--     end

--     --чистая магия!
--     setmetatable(obj, self)
--     self.__index = self; return obj
-- end

-- --создаем экземпляр класса
-- vasya = Person:new("Вася", "Пупкин")

-- --обращаемся к свойству
-- print(vasya.firstName)    --> результат: Вася

-- --обращаемся к методу
-- print(vasya:getName())  --> результат: Вася
