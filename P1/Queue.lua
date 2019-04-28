------------------------------------------------------------------------------------------------------
--  Created: Fri Apr 26 2019
--  Copyright 2019 Mostafa Kanaan [mos.kan@hotmail.com]
------------------------------------------------------------------------------------------------------
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
------------------------------------------------------------------------------------------------------
dofile("Class.lua")

Queue = {} --FIFO/LIFO
PriorityQueue = {} --PRIO
local Queue_mt = Class(Queue)
local PriorityQueue_mt = Class(PriorityQueue)

------------------------------------------FIFO/LIFO Queue---------------------------------------------
function Queue:new(Queuetype, Elements)
    Elements = Elements or {}
    local tempSize = #Elements
    return setmetatable({ list = Elements, queueType = Queuetype, size = tempSize }, Queue_mt)
end

function Queue:push(Element)
    table.insert(self.list, Element)
    self.size = self.size + 1
end

function Queue:pop()
    if self.size > 0 then
        self.size = self.size - 1
        if self.queueType == "FIFO" then
            return table.remove(self.list, 1)
        elseif self.queueType == "LIFO" then
            return table.remove(self.list)
        end
    else
        error("Nothing to pop - Queue is empty!")
    end
end

function Queue:isEmpty()
    return self.size == 0
end

function Queue:printElements()
    print("_______")
    for key, element in pairs(self.list) do
        print(key .. ":" .. "|" .. element .. "|")
    end
end

------------------------------------------Priority Queue---------------------------------------------
function PriorityQueue:new(Elements)
    Elements = Elements or {}
    local tempSize = #Elements
    return setmetatable({ heap = PriorityQueue:heapify(Elements),
                          size = tempSize }, PriorityQueue_mt)
end

function PriorityQueue:heapify(Tree)
    --A Tree with 1 or less Nodes is a MinHeap
    if #Tree > 1 then
        --Otherwise bubble down and build a MinHeap!
        local half = math.floor(#Tree / 2)
        for i = half, 1, -1 do
            self:bubbleDown(Tree, #Tree, i)
        end
    end
    return Tree
end

function PriorityQueue:bubbleUp(Tree, i)
    if i > 1 then
        local parent
        if math.fmod(i, 2) == 0 then
            --i is left child
            parent = i / 2
        else
            --i is right child
            parent = math.floor((i - 1) / 2)
        end

        if Tree[i] < Tree[parent] then
            Tree[i], Tree[parent] = Tree[parent], Tree[i]
        end
    end
end

function PriorityQueue:bubbleDown(Tree, n, i)
    smallest = i                        --The index of the smallest
    l = 2 * i                           --Left Node
    r = 2 * i + 1                       --Right Node

    if (l <= n and Tree[l] < Tree[smallest]) then
        smallest = l
    end

    if (r <= n and Tree[r] < Tree[smallest]) then
        smallest = r
    end

    if (i ~= smallest) then
        --Make sure that root is the smallest
        Tree[i], Tree[smallest] = Tree[smallest], Tree[i]
        --Fix the new swapped child node's Tree
        self:bubbleDown(Tree, n, smallest)
    end
end

function PriorityQueue:isEmpty()
    return self.size == 0
end

function PriorityQueue:push(Element)
    table.insert(self.heap, Element)
    self.size = self.size + 1
    self:bubbleUp(self.heap, self.size) --TODO:bubbleUp not working properly!
end

function PriorityQueue:pop()
    if self.size > 0 then
        local out = self.heap[1]
        self.heap[1], self.heap[self.size] = self.heap[self.size], self.heap[1]
        table.remove(self.heap)
        self:heapify(self.heap)
        self.size = self.size - 1
        return out
    else
        error("Nothing to pop - Queue is empty!")
    end
end

function PriorityQueue:printElements()
    print("_______")
    for key, element in pairs(self.heap) do
        print(key .. ":" .. "|" .. element .. "|")
    end
end