
----------------------------------------------------------------------------
--  romania.lua - Implementation of a DFS and BFS for Romania map from 
--     Russel-Norvig .
--
--  Created: Tue Apr 02 10:46:58 2012
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
--  printf -- from the lua wiki page
-----------------------------------------------------------------------------

printf = 
   function(s,...)
      return io.write(s:format(...))
   end 


-----------------------------------------------------------------------------
-- is -- indent string returns  a string indented by level indent
-- @param indent - integer indicating the depth as indentation 
-----------------------------------------------------------------------------

function is(indent)
--   print(indent)
   local tab=""
   for i=1,indent-2 do tab=tab .. "  " end
   if indent > 1 then  tab = tab .. "|-" end
   return tab
end

-----------------------------------------------------------------------------
-- traverse - outputs a nested tables with indentation
--    @param t - the table to be printed
--           level - indentation level 
-----------------------------------------------------------------------------

function traverse(t)
   return travtab(t, 0)
end


function travtab(t, level)
   if type(t) == "table" then
      level = level + 1
      printf("%s%s\n", is(level), tostring(t))
      for i,v in ipairs(t) do travtab(v, level+1) end
   else
      printf("%s%s\n", is(level), tostring(t))   
   end
end


-----------------------------------------------------------------------------

dofile("Class.lua")
dofile("Graph.lua")

romania = Graph:new( {'Or', 'Ne', 'Ze', 'Ia', 'Ar', 'Si', 'Fa', 
		      'Va', 'Ri', 'Ti', 'Lu', 'Pi', 'Ur', 'Hi',
		      'Me', 'Bu', 'Dr', 'Ef', 'Cr', 'Gi'},
		     {
			{'Or', 'Ze', 71}, {'Or', 'Si', 151}, 
			{'Ne', 'Ia', 87}, {'Ze', 'Ar', 75},
			{'Ia', 'Va', 92}, {'Ar', 'Si', 140},
			{'Ar', 'Ti', 118}, {'Si', 'Fa', 99}, 
			{'Si', 'Ri', 80}, {'Fa', 'Bu', 211},
			{'Va', 'Ur', 142}, {'Ri', 'Pi', 97},
			{'Ri', 'Cr', 146}, {'Ti', 'Lu', 111},
			{'Lu', 'Me', 70}, {'Me', 'Dr', 75},
			{'Dr', 'Cr', 120}, {'Cr', 'Pi', 138},
			{'Pi', 'Bu', 101}, {'Bu', 'Gi', 90},
			{'Bu', 'Ur', 85}, {'Ur', 'Hi', 98}, 
			{'Hi', 'Ef', 86}
		     },
		     false )

--[[

  - -  -  - -				 Gi		Hi - Ef
/              \		    /	  /
Or - Ze - Ar -  Si - Fa - Bu - Ur
		 /       \		  /		  \
       Ti    Cr  - Ri -  Pi			Va
      /     /  \		 /			|
     /     Dr  	 -  -  -			Ia
	/	  /							|
   Lu -  Me							Ne

]]