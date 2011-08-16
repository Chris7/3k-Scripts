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
  local qtindex = 0
  local qtpath = ""
  speedWalking = 1
  roomsToWalk = speedWalkPath
  for i,v in pairs(speedWalkPath) do
	for j,k in pairs(exits) do
		if v==k then
			if necro then
				if qtindex == 0 then
					qtpath = j.."/"
				else
					qtpath = qtpath..j.."/"
				end
				qtindex = qtindex+1
				local script = tkm:getRoomScript(v)
				if script then
					display('script')
					display(script)
					qtpath = qtpath..script.."/"
					qtindex = qtindex+1
				end
				if qtindex > 40 then
					send("qtrance "..qtpath)
					qtpath = ""
					qtindex = 0
				end
			else
				send(j)
--				display(j)
--				display(qtpath)
				execRoomScript(v)
			end
			lastId = v
			break
		end
	end
    exits = getAllExits(lastId)
  end
  if necro then
    send("qtrance "..qtpath)
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
