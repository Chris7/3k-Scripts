require "luasql"

function tkm:SqlInsertRoom( RoomId, RoomDesc, RoomScript)
	RoomDesc = string.gsub(RoomDesc, "'", "''")
	if RoomScript then
		RoomScript = string.gsub(RoomScript, "'", "''")
		assert (con:execute(string.format([[INSERT INTO Rooms VALUES (NULL, '%d', '%s', '%s')]],RoomId, RoomDesc, RoomScript)))
	else
		assert (con:execute(string.format([[INSERT INTO Rooms VALUES (NULL, '%d', '%s', NULL)]],RoomId, RoomDesc)))
	end
end

function tkm:sqlDeleteRoom(RoomId)
	assert (con:execute(string.format([[DELETE FROM Rooms WHERE RoomId = '%d']],RoomId)))	
end

function tkm:SqlGetRoomDesc( RoomId)
	res = assert (con:execute(string.format([[SELECT RoomDesc FROM Rooms WHERE RoomId = '%d']],RoomId)))
	return res:fetch({})[1]
end

function tkm:SqlFindDesc(RoomDesc)
	local sql = string.format([[SELECT RoomId FROM Rooms WHERE RoomDesc LIKE '%s']],RoomDesc)
	return assert(con:execute(sql))
end

function tkm:getRoomScript( RoomId)
	res = assert (con:execute(string.format([[SELECT RoomScript FROM Rooms WHERE RoomId = '%d']],RoomId)))
	return res:fetch({})[1]
end

function tkm:resetConn()
	tkm:closeSql()
	tkm:initSql()
end

function tkm:closeSql()
	if con then
		con:close()
		con = nil
	end
	if env then
		env:close()
		env = nil
	end
end

function tkm:dropSqlDB()
	if con then
		con:close()		
	end
	if env then
		env:close()
	end
	tkm:initSql()
	assert (con:execute[[DROP TABLE Rooms]])
end

function tkm:makeSqlDB()
	tkm:closeSql()
	tkm:initSql()
	assert (con:execute[[
	  CREATE TABLE Rooms(
	    UId INTEGER PRIMARY KEY AUTOINCREMENT,
		 RoomId INTERGER,
	    RoomDesc varchar,
		RoomScript varchar
	  )
	]])
end

function tkm:initSql()
	-- create environment object
	env = assert (luasql.sqlite3())
	-- connect to data source
	local dir = getMudletHomeDir()
	local loc = string.find(dir, "[\\/]profiles[\\/]")
	local profilename = string.sub(dir,loc+10)
	local file = getMudletHomeDir().."/"..profilename.."_map.sqlite3"
	con = assert (env:connect(file))
end
tkm:initSql()
