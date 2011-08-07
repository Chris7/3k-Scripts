function onCheckRoom(roomname, roomdesc, roomexits)
	--Called whenever a room is entered
	if mapon() == nil and mapfollow == nil then
		table.remove(comTable,1)
		return
	end
	if mapspecial then
		checkedcommand = specialdirection
	else
		local lastcommand = comTable[1]
	--	display(lastcommand)
		if lastcommand == nil then
			return
		end
		checkedcommand = checkLastCommand(lastcommand)
	end
	if checkedcommand and mapfollow == nil then
       if firstRoom == false then
			lastx,lasty,lastz = getRoomCoordinates(lastId)
			collisions = checkCoords(lastId, checkedcommand, roomname, roomdesc)
			if collisions then
				--there was an overlapping room AND an exit existed to it.
				--or room was the same as we made the exit within checkCoords function
				lastId = collisions
			else
				--no overlapping room, make a new one in the given direction
				lastId = makeNewRoom(roomname, roomdesc, roomexits, checkedcommand)
			end
		else
			lastId = makeNewRoom(roomname, roomdesc, roomexits, checkedcommand)
			firstRoom = false
		end
	end	
	onPlayerMove(lastId)
	table.remove(comTable,1)
end

function makeNewRoom( roomname, roomdesc, roomexits, checkedcommand)
	--makes a new room obviously
	local roomID  = createRoomID()
	display("making new room")
	display(roomname)
	addRoom( roomID )
	setRoomName( roomID, convertRoomName(roomname ))
	tkm:SqlInsertRoom( roomID, roomdesc )
	xyzd = getCoordsOfDir(roomID, checkedcommand)
	lastx,lasty,lastz,dirtype = xyzd[1],xyzd[2],xyzd[3],xyzd[4]
	setRoomCoordinates(roomID, lastx,lasty,lastz)
	if firstRoom == false then
		if mapspecial then
			addSpecialExit(lastId,roomID,specialexitcommand)
			mapspecial = nil
		else 
			setExit(lastId, roomID, dirtype)
			setExit(roomID, lastId, reversedir[dirtype])
		end
	end
	if UserArea == nil then UserArea = 101 end
	setRoomArea( roomID, UserArea )
	--restore the initial scaling if we changed it
	if mapScale ~= priorMapScale then
		mapScale = priorMapScale
		calculateMapOffset()
	end	
	return roomID
end

function checkLastCommand(lastcommand)
	--checks if the command sent is in the exits of the current room
	--returns nil if it exists, otherwise returns the exit we should map
	--IE IF THIS FUNCTION RETURNS TRUE, THERE IS NO EXIT!
	if firstRoom == true then
		return 1
	end
--	display(lastcommand)
	local exit = checkExit(lastId, lastcommand)
--	display(exit)
	if exit then
		lastId = exit
		lastx,lasty,lastz = getRoomCoordinates(exit)
		return nil
	end
	--return the direction we should map if it doesn't exist in the current room
--	display("no exit found in checklastcommand")
	return lastcommand
end
