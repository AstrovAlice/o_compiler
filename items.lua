--items
local Items = {}

Items.Module = {}
function Items.Module:new(OBJname)
    assert(type(OBJname) == "string")
    local obj= {
        name = OBJname
    }
    setmetatable(obj, self)
    self.__index = self; return obj
end


Items.Const = {}
function Items.Const:new(OBJname, OBJtype, OBJvalue)
    assert(type(OBJname) == "string")
    local obj= {
        name = OBJname,
        type = OBJtype,
        value = OBJvalue
    }
    setmetatable(obj, self)
    self.__index = self; return obj
end


Items.Var = {}
function Items.Var:new(OBJname, OBJtype)
    assert(type(OBJname) == "string")
    local obj= {
        name = OBJname,
        type = OBJtype
    }
    setmetatable(obj, self)
    self.__index = self; return obj
end


Items.Type = {}
function Items.Type:new(OBJname, OBJtype)
    assert(type(OBJname) == "string")
    local obj= {
        name = OBJname,
        type = OBJtype
    }
    setmetatable(obj, self)
    self.__index = self; return obj
end


Items.Func = {}
function Items.Func:new(OBJname, OBJtype)
    assert(type(OBJname) == "string")
    local obj= {
        name = OBJname,
        type = OBJtype
    }
    setmetatable(obj, self)
    self.__index = self; return obj
end


Items.Proc = {}
function Items.Proc:new(OBJname)
    assert(type(OBJname) == "string")
    local obj= {
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