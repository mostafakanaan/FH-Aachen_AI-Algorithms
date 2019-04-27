----------------------------------------------------------------------------
--  Class.lua - Implementation of Standard and Copy constructor for tables
--
--  
--  Created: Mon Nov 09 09:15:24 2009
--  (c) by the Lua Wiki [http://lua-users.org/wiki/LuaClassesWithMetatable]
--
----------------------------------------------------------------------------
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU Library General Public License for more details.
--
--  Read the full text in the LICENSE.GPL file in the doc directory.




function Class(members)
  members = members or {}
  local mt = {
    __metatable = members;
    __index     = members;
  }
  local function new(_, init)
    return setmetatable(init or {}, mt)
  end
  local function copy(obj, ...)
    local newobj = obj:new(unpack(arg))
    for n,v in pairs(obj) do newobj[n] = v end
    return newobj
  end
  members.new  = members.new  or new
  members.copy = members.copy or copy
  return mt
end


---- Benutzung:
--[[
NeueKlasse = {}
local NeueKlasse_mt = Class(NeueKlasse)

function NeueKlasse:new(arg1, arg2, arg3)
   
   -- Initialisierung der Members
   local arg1 = arg1
   local arg2 = arg2
   local arg3 = arg3
   
   return setmetatable( {arg1 = arg1, arg2=arg2, arg3=arg3}, NeueKlasse_mt)
end


function test()
   local a = NeueKlasse:new(1,2,3)
   local b = NeueKlasse:new(4,5,6)

--]]