function doSpeedWalk()
  if #speedWalkPath == 0 then
    echo("Couldn't find a path to the destination :(")
  end
  for i = 1, #speedWalkPath do
    speedWalkPath[i] = tonumber(speedWalkPath[i])
  end
  if mouseLocation then
	display("mouse location")
	mouseLocation = nil
	lastId = speedWalkPath[table.getn(speedWalkPath)]
	onPlayerMove(lastId)
	return
  end
  exits = getAllExits(lastId)
  speedWalking = 1
  roomsToWalk = speedWalkPath
  for i,v in pairs(speedWalkPath) do
	for j,k in pairs(exits) do
		if v==k then
			send(j)
			execRoomScript(v)
			lastId = v
			break
		end
	end
    exits = getAllExits(lastId)
  end
  speedwalking = nil
end

function execRoomScript(roomId)
	local script = tkm:getRoomScript(roomId)
	if script then
		display(script)
		send(script)
	end
end

function getAllExits(roomId)
   local exits = getRoomExits(lastId)
   local sexits = swapKeysValues(getSpecialExits(lastId))
   return concatTables(exits,sexits)
end
