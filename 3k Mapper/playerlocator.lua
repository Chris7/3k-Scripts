function onFindMe(name, desc, exits)
	beforeconvert = getKeys(searchRoom(name))
	withexits = getKeys(searchRoom(convertRoomName(name)))
	withoutexits = getKeys(searchRoom(removeRoomExits(name)))
	local pExits = {}
	if table.getn(withoutexits)>0 then
		doFind(withoutexits, desc)
	elseif table.getn(withexits)>0 then
		doFind(withexits, desc)
	elseif table.getn(beforeconvert)>0 then
		doFind(beforeconvert,desc)
	else
		doDescFind(desc)
	end
end

function getKeys(table)
	--returns the keys of our table (in this case the value from seachRoom)
	output = {}
	local iter = 1
	for i,v in pairs(table) do
		output[iter] = v
		iter = iter + 1
	end
	return output
end

function doDescFind(desc)
	desc = string.sub(desc,0,string.len(desc)-1)
	desc = string.split(desc, "\n")
	local pExits = searchRoomUserData("description", desc[1])
	local count = 0
	local roomId
	if (pExits) then
		for i,v in pairs(pExits) do
			count = count+1
			roomId = i
			if count > 1 then
				break
			end
		end
		if (count == 1) then
			onPlayerMove(roomId)
		else
			display(pExits)
		end
	end
end

function doFind(results, desc)
	local pExits = {}
	if table.getn(results) == 1 then
		onPlayerMove(tonumber(results[1]))
		comTable = {}
	else
		--multiple entries, do room descs
		--display(results)
		for i,v in pairs(results) do
			local roomdesc = getRoomUserData(v, "description")
			roomdesc = string.gsub(roomdesc,".\n","")
			--display(desc)
			--display(roomdesc)
			if desc == roomdesc then
				pExits[v] = roomdesc
			end
		end
		if table.getn(pExits) == 1 then
			onPlayerMove(pExits[1])
			comTable = {}
		else
			echo("Possible Rooms:\n")
			display(pExits)
		end
	end
end
