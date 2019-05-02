------------------------------------------------------------------------------------------------------
--  Created: Thu May 2 2019
--  Copyright 2019 Mostafa Kanaan [mos.kan@hotmail.com]
------------------------------------------------------------------------------------------------------
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
------------------------------------------------------------------------------------------------------
dofile("Romania-Graph.lua")
dofile("Queue.lua")
dofile("Node.lua")

function BFS(problem, DFS)
    myGraph = problem[1]
    initialState = problem[2]
    goalState = problem[3]

    node = Node:new(initialState, 0)

    if node.state == goalState then
        return Solution(node)
    end

    local frontier

    if (DFS) then
        frontier = Queue:new("LIFO", { node })
    else
        frontier = Queue:new("FIFO", { node })
    end
    explored = {}

    while true do
        if frontier:isEmpty() then
            return Solution(nil) --FAILURE!
        end

        node = frontier:pop()
        explored[node.state] = node.state

        for i, adj in pairs(myGraph:GetNeighbours(node.state)) do
            child = Node:new(adj[1], adj[2])
            if not explored[child.state] then
                child.prev = node

                if child.state == goalState then
                    return Solution(child)
                end
                frontier:push(child)
            end
        end
    end
end

function DFS(problem)
    BFS(problem, true)
end

function Solution(node)
    if (not node) then
        print("No Solution!")
    else
        n = node
        costs = node.path_cost
        path = node.state
        while n.prev do
            n = n.prev
            if (n.prev) then
                costs = costs + n.path_cost
                path = tostring(n.state) .. " -> " .. path
            end
        end
        print("Path= { " .. path .. " }")
        print("Path-Costs= " .. costs)
    end
end
