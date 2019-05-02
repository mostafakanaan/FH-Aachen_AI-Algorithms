------------------------------------------------------------------------------------------------------
--  Created: Sun Apr 28 2019
--  Copyright 2019 Mostafa Kanaan [mos.kan@hotmail.com]
------------------------------------------------------------------------------------------------------
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
------------------------------------------------------------------------------------------------------
dofile("Class.lua")

Node = {}
local Node_mt = Class(Node)
------------------------------------------------------------------------------------------------------

function Node:new(State, Path_COST)
    State = State or "Undefined"
    Path_COST = Path_COST or 0
    return setmetatable({ state= State, path_cost = Path_COST, prev= "Undefined"},
            Node_mt)
end

function Node:initialize(Other)
    self.state= Other[1]
    self.weight= Other[2]
end

function Node:setPrev(node)
    self.prev = node
end
