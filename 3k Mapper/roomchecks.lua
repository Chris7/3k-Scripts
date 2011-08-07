function checkCoords(RoomId, dir, roomname, roomdesc)
	--check if a room exists already in the proposed direction
	--and if so and rooms match, will create an exit for that room
	dirtype=dirtypes[dir]
	if dirtype == nil then
		return 0
	end
	dirlocation = diroffset[dirtype]
	if dirlocation == nil then
		calculateMapOffset()
		dirlocation = diroffset[dirtype]
	end
	local location = {lastx,lasty,lastz}
	local newloc = add_arrays(location, dirlocation)
	local conflicts = getRoomsByPosition(UserArea, newloc[1], newloc[2], newloc[3])
	local firstconflict = conflicts[0]	
	if firstconflict then
		--a room existed where we want to go, does an exit exist to it?
		local conflictingroom = checkExit(lastId, dir)
		echo("\nconflict exists")
		if conflictingroom then
			echo(" with exit\n")
			--a room exists and an exit also exists in the given direction
			--check if the descriptions and name match, if so it's the same room to us
			if checkRoomInfo(firstconflict, roomdesc, roomname) then
				return firstconflict
			else
				--it isn't the same room, but it still conflicts, change scale to 1/2 and add it
				priorMapScale = mapScale
				mapScale = mapScale/2
				calculateMapOffset()
				return nil
			end
		else
			echo(" without exit\n")
			--no direction to this room, but a room exists in that direction, is it an unconnected room?
			local roominfo = checkRoomInfo(firstconflict, roomdesc, roomname)
			if roominfo then
				--the room is the same, make the exit
				if mapspecial then
					addSpecialExit(RoomId, firstconflict, specialexitcommand)	
					mapspecial = nil
				else
					setExit(RoomId, firstconflict, dirtype)
					setExit(firstconflict, RoomId, reversedir[dirtype])
				end
			else
				--there is no direction to the next room, but there is a conflict, half
				--the scale and put room there
				priorMapScale = mapScale
				mapScale = mapScale/2
				calculateMapOffset()
				return nil
			end
		end
	end	
	return firstconflict
end

function checkRoomInfo(roomId, roomdesc, roomname)
	--checks the the supplied roomdesc and name are the same as roomId
	local name = getRoomName(roomId)
	local desc = tkm:SqlGetRoomDesc(roomId)
	display(name)
	display(desc)
	if ((roomname == name) or (removeRoomExits(roomname) == removeRoomExits(name)))
	 and ((roomdesc == desc) or (removeBreaks(roomdesc) == removeSqlBreaks(desc))) then
		return roomId
	else
		return nil
	end
end

function getCoordsOfDir(roomID, dir)
	--takes a room id and a direction and returns
	--the coords of the room in a given direction from
	--the supplied room
	if firstRoom == true then
		return {0,0,0,nil}
	end
	dirtype=dirtypes[dir]
	if dirtype == nil then
		return 0
	end
	dirlocation = diroffset[dirtype]
	if lastx == nil then
		lastx,lasty,lastz = 0,0,0
	end
	local location = {lastx,lasty,lastz}
	local newloc = add_arrays(location, dirlocation)
	return {newloc[1],newloc[2],newloc[3],dirtype}
end

function checkExit(roomId, dir)
	--input is a room id and a direction(word dir, not numerical)
	--outputs room num if it exists, nil otherwise
	if roomId == nil then
		return nil
	end
	local exits = getRoomExits(roomId)
	for i,v in pairs(exits or {}) do
		if i == dir then
			--set lastId to the room we are moving to and coords
			return v
		end
	end
	local exits = getSpecialExits(roomId)
	for i,v in pairs(exits or {}) do
		if string.sub(v,1,1) == '1' or string.sub(v,1,1) == '0' then
			v = string.sub(v,2)
		else
		end
		if v == dir then
			--set lastId to the room we are moving to and coords
			return i
		end
	end
	return nil
end
