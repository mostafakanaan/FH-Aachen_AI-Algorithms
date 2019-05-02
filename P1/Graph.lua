----------------------------------------------------------------------------
--  astar.lua - Implementation of AStar
--
--  Created: Mon Nov 09 09:15:24 2009
--  Copyright  2009-2010  Alexander Ferrein [alexander.ferrein@gmail.com]
--
----------------------------------------------------------------------------

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

-----------------------------------------------------------------------------
-- Class Graph - implements a simple Graph structure. Edges are stored in an 
--               adjacency matrix.
--
--               
--               The auxiliary function Class is defined in Class.lua
-----------------------------------------------------------------------------

Graph = {}
local Graph_mt = Class(Graph)

Graph.HashDelim = "::"



-----------------------------------------------------------------------------
-- Graph:new - constructor 
--      
--    @param Vertices - a table of key values (strings) for the vertices
--           Edges - a table of tables of edges in form from {v1, v2, w}, 
--                   where v1 is the source v2 the target and w the weight of
--                   the edge
--           Directed - a boolean value to indicate if the graph is directed
--           INIT_S - the initial state of the graph
--           GOAL_S - the goal state of the graph
--
--    @return the metatable 
-----------------------------------------------------------------------------

function Graph:new(Vertices, Edges, Directed)
    local matrix = {}

    for i, e in pairs(Edges) do
        matrix[self:SetHash(e[1], e[2])] = e[3]
        if not Directed then
            matrix[self:SetHash(e[2], e[1])] = e[3]
        end
    end

    local vertex_lookup = {}
    for i, v in pairs(Vertices) do
        vertex_lookup[v] = i
    end

    local num_v = #Vertices

    return setmetatable({ vertices = Vertices, vertex_lookup = vertex_lookup,
                          adj = matrix, num_v = num_v },
            Graph_mt)
end



-----------------------------------------------------------------------------
-- Graph:split_string - splits a string by a Graph.delimiter
--           each edge is stored in an associative array addressed by
--           'v1::v2'. Split string returns the vertex keys in a table
--    @param str - the edge string
--           pat - the delimited
--    @return a table of to vertex keys as strings 
--
-- Graph:Dehash - is the frontend to split string
--
-- Graph:Sethash - encodes the edge key as 'v1::v2'
-----------------------------------------------------------------------------

function Graph:split_string(str, pat)
    local t = {}  -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(t, cap)
        end
        last_end = e + 1
        s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
        cap = str:sub(last_end)
        table.insert(t, cap)
    end
    return t
end

function Graph:Dehash(value)
    return self:split_string(value, self.HashDelim)
end

function Graph:SetHash(e1, e2)
    return tostring(e1) .. self.HashDelim .. tostring(e2)
end


-----------------------------------------------------------------------------
-- Graph:GetCellString - outputs the stringvalue *value* centered in a columns with
--                       width *col*
--                     - moved to Aux.lua
--    @param t - string value which needs to be output
--           col - the column width 
-----------------------------------------------------------------------------

function Graph:GetCellString(value, col)
    local mid = col / 2 + 0.5 * (col % 2)

    if value == nil then
        value = ""
    end

    local val = tostring(value)
    local len = #val
    local offset = len / 2 - 0.5 * (len % 2)
    local lpad = mid - offset - 1
    local rpad = col - len - lpad

    local string = ""

    for i = 1, lpad do
        string = string .. " "
    end
    string = string .. val
    for i = 1, rpad do
        string = string .. " "
    end
    return string
end


-----------------------------------------------------------------------------
-- Graph:Print - pretty prints the adjacency matrix
-- 
-----------------------------------------------------------------------------


function Graph:Print()
    local tab = self:DehashedTable()
    local col = 3

    local delim = ""
    for i = 1, col do
        delim = delim .. "-"
    end
    local hline = delim .. "|"

    printf("%s|", self:GetCellString("", col))
    for i = 1, self.num_v do
        printf("%s|", self:GetCellString(self.vertices[i], col))
        hline = hline .. delim .. "|"
    end
    hline = hline .. "\n"
    printf("\n%s", hline)

    for i = 1, self.num_v do
        printf("%s|", self:GetCellString(self.vertices[i], col))
        for j = 1, self.num_v do
            printf("%s|", self:GetCellString(tab[i][j], col))
        end
        printf("\n%s", hline)
    end

end

-----------------------------------------------------------------------------
-- Graph:DehashedTable - decodes the adjacency matrix such that it can be
--                       output row-wise
--
-----------------------------------------------------------------------------

function Graph:DehashedTable()
    local tab = {}
    for i = 1, self.num_v do
        tab[i] = {}
    end
    for i, v in pairs(self.adj) do
        local elem = self:Dehash(i)
        local i = self.vertex_lookup[elem[1]]
        local j = self.vertex_lookup[elem[2]]
        tab[i][j] = v
    end
    return tab
end

-----------------------------------------------------------------------------
-- Graph:GetEdge - get the edge weight of the edge v1,v2
--   @param v1 - source vertex
--          v2 - target vertex
--
--   @return the weight of the edge if existant or nil
-----------------------------------------------------------------------------

function Graph:GetEdge(v1, v2)
    local hash = self:SetHash(v1, v2)
    return self.adj[hash]
end


-----------------------------------------------------------------------------
-- Graph:Neighbours - get all adjacent vertices of a vertex
--   @param v -  vertex
--
--   @return table of all adjacent vertices ands their weights { {v, w} , ...}
-----------------------------------------------------------------------------

function Graph:GetNeighbours(vertex)
    local neighbours = {}
    for i, v in pairs(self.vertices) do
        local hash = self:SetHash(vertex, v)
        local val = self.adj[hash]
        if val ~= nil then
            table.insert(neighbours, #neighbours + 1, { v, val })
        end
    end
    return neighbours
end

-----------------------------------------------------------------------------
-- Graph:PrintNeighbours - prints all adjacent neigbours together with their 
--                         incident edges to the screen
--
--   @param v -  vertex
-----------------------------------------------------------------------------



function Graph:PrintNeighbours(vertex)
    local neighbours = self:GetNeighbours(vertex)
    for i, v in pairs(neighbours) do
        printf("%s --- %s ---> %s\n", self:GetCellString(vertex, 5),
                self:GetCellString(v[2], 5), self:GetCellString(tostring(v[1]), 5))
    end
end
