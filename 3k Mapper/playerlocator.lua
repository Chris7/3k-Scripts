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
	local pExits = tkm:SqlFindDesc(desc[1])
	display(pExits:fetch({}))
end

function doFind(results, desc)
	local pExits = {}
	if table.getn(results) == 1 then
		onPlayerMove(tonumber(results[1]))
		comTable = {}
	else
		--multiple entries, do room descs
		display(results)
		for i,v in pairs(results) do
			local res = tkm:SqlGetRoomDesc(v)
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
