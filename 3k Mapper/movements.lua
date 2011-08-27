function onPlayerMove(roomid)
	roomid = tonumber(roomid)
	centerview(roomid)
	lastId = roomid
	lastx,lasty,lastz = getRoomCoordinates(lastId)
	UserArea = getRoomArea(roomid)
	updateRoomInfo()
end

function onFollow(direction)
	--direction populated when we are following, otherwise we're looking
	--at the player's input via comTable
	if direction then
		checkLastCommand(direction)
		onPlayerMove(lastId)
		table.remove(comTable,1)
	else
		if roomsToWalk then
			if (#roomsToWalk == 0) then
				roomsToWalk = nil
				speedWalking = 0
				onFollow(nil)
			else
				onPlayerMove(roomsToWalk[1])
				table.remove(roomsToWalk,1)
			end
		else
			local lastcommand = comTable[1]
			if lastcommand == nil then
				return
			end
			checkedcommand = checkLastCommand(lastcommand)
		end
	end
	onPlayerMove(lastId)
	table.remove(comTable,1)
end

function roomWalk(roomid)
	local result = gotoRoom(roomid)
	if result then
		lastId = roomid
		centerview(lastId)
	end
end
