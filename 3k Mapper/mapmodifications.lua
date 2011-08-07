function doRoomDelete(roomId)
	display(roomId)
	--disconnect exits
	local specialExits = getSpecialExits(roomId)
	local tablesize = 0
	if specialExits then
		for i,v in pairs(specialExits) do
			tablesize = tablesize + 1
		end
	end
	if tablesize > 0 then
		for i,v in specialExits do
			if tablesize > 1 then
				if string.sub(v,1,1) == '1' or string.sub(v,1,1) == '0' then
					v = string.sub(v,2)	
				end
			end
			addSpecialExit(i,-1,v)
		end
	end
	deleteRoom(roomId)
	tkm:sqlDeleteRoom(roomId)
end


-------------------------------------------------
--         Put your Lua functions here.        --
--                                             --
-- Note that you can also use external Scripts --
-------------------------------------------------
--[[
colorMappings = {red={0, 255, 0, 0}, green={1, 0, 255, 0}, blue={2, 0, 0, 255},
 yellow={3, 255, 255, 0}, cyan={4, 0, 255, 255}, magenta={5, 255, 0, 255}, default={6, 255, 0,0}}
for i,v in pairs(colorMappings) do
	setCustomEnvColor(v[1], v[2], v[3], v[4])
end
]]
colorMappings = {red=257, green=258, yellow=259, blue=260, magenta=261,
	cyan=262, white=263, black=264, lred=265, lgreen=266, lyellow=267,
	lblue=268, lmagenta=269, lcyan=270, lwhite=271, lblack=272}
--[[
customEnvColors[257] = mpHost->mRed_2;
    customEnvColors[258] = mpHost->mGreen_2;
    customEnvColors[259] = mpHost->mYellow_2;
    customEnvColors[260] = mpHost->mBlue_2;
    customEnvColors[261] = mpHost->mMagenta_2;
    customEnvColors[262] = mpHost->mCyan_2;
    customEnvColors[263] = mpHost->mWhite_2;
    customEnvColors[264] = mpHost->mBlack_2;
    customEnvColors[265] = mpHost->mLightRed_2;
    customEnvColors[266] = mpHost->mLightGreen_2;
    customEnvColors[267] = mpHost->mLightYellow_2;
    customEnvColors[268] = mpHost->mLightBlue_2;
    customEnvColors[269] = mpHost->mLightMagenta_2;
    customEnvColors[270] = mpHost->mLightCyan_2;
    customEnvColors[271] = mpHost->mLightWhite_2;
    customEnvColors[272] = mpHost->mLightBlack_2;
]]

-------------------------------------------------
-- room label the room I'm in
-- room label 342 this is a label in room 342
-- room label green this is a green label where I'm at
-- room label green black this is a green to black label where I'm at
-- room label 34 green black this is a green to black label at room 34
-- how it works: split input string into tokens by space, then determine
-- what to do by checking first few tokens, and finally call the local
-- function with the proper arguments
function tkm.roomLabel(input)
  local tk = input:split(" ")
  local room, fg, bg, message = lastId, "yellow", "red", "Some room label"

  -- input always have to be something, so tk[1] at least always exists
  if tonumber(tk[1]) then
    room = tonumber(table.remove(tk, 1)) -- remove the number, so we're left with the colors or msg
  end

  -- next: is this a foreground color?
  if tk[1] and color_table[tk[1]] then
    fg = table.remove(tk, 1)
  end

  -- next: is this a backround color?
  if tk[1] and color_table[tk[1]] then
    bg = table.remove(tk, 1)
  end

  -- the rest would be our message
  if tk[1] then
    message = table.concat(tk, " ")
  end

  -- if we haven't provided a room ID and we don't know where we are yet, we can't make a label
  if not room then
    echo("We don't know where we are to make a label here.") return
  end

  local x,y = getRoomCoordinates(room)
  local f1,f2,f3 = unpack(color_table[fg])
  local b1,b2,b3 = unpack(color_table[bg])

  -- finally: do it :)

  local lid = createMapLabel(getRoomArea(room), message, x, y, f1,f2,f3, b1,b2,b3)
  echo(string.format("Created new label #%d '%s' in %s.", lid, message, getRoomAreaName(getRoomArea(room))))
end
