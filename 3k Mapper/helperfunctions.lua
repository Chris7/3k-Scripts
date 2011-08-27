function mapon()
	return mapstatus
end

function Set(input)
    s = {}
    for _,v in pairs(input) do
        s[v] = true
    end
end

function add_arrays(array1, array2)
	local output = {}
	for i,v in ipairs(array1) do
		output[i] = v+array2[i]
	end
	return output
end

function convertRoomName(name)
	local strpos = string.find(name, tkm.specialChar)
	local trimname = name
	if strpos then 
		trimname = string.sub(trimname,0,strpos-1)
	end
	trimname = string.gsub(trimname, "^%s*(.-)%s*$", "%1")
	return trimname
end

function removeRoomExits(name)
	local roomname = convertRoomName(name)
	roomname = string.gsub(roomname, "%([%a+,?]+%)", "")
	roomname = string.gsub(roomname, "^%s*(.-)%s*$", "%1")
	return roomname
end

function removeDescBreaks(desc)
	local nobreaks = string.gsub(desc, ".\n", "") --specialized for our maps
	return nobreaks
end

function removeBreaks(desc)
	--remove line breaks
	local nobreaks = string.gsub(desc, "\n", "")
	return nobreaks
end

function swapKeysValues(table)
	local output = {}
	for i,v in pairs(table) do
		test = string.sub(v, 1,1)
		if (tonumber(test) and tonumber(test) >= 0) then
			v = string.sub(v, 2)
		end
		output[v] = i
	end
	return output
end

function concatTables(table1, table2)
	local output = {}
	for i,v in pairs(table1) do
		output[i] = v
	end
	for i,v in pairs(table2) do
		output[i] = v
	end
	return output
end
