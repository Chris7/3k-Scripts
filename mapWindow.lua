mapwin = mapwin or {}
mapwin.windows = mapwin.windows or {}
mapwin.labelbox = mapwin.labelbox or {}
mapwin.labels = mapwin.labels or {}
mapwin.windowlist = {"Map", "Room Info", "Favorites"}

function mapwinResetUI()
  mapwin.container = Geyser.Container:new({
    fontSize = 8,
    x="-65c",
    y="-30c",
    width="420",
    height="300",
    name="mapwinWindow",
  })
  mapwin.labelBox = Geyser.HBox:new({
    x=0,
    y=0,
    width = "100%",
    height = "25px",
    name = "mapwinWindowLabels",
  },mapwin.container)
end

function mapwinSwitch(win)
	local oldwin = mapwin.currentWindow
	if oldwin then
		mapwin.windows[oldwin]:hide()
		mapwin.labels[oldwin]:setColor(50,50,50)
		mapwin.labels[oldwin]:echo(oldwin, "white", "c")
	end
	mapwin.currentWindow = win
	mapwin.windows[win]:show()
	mapwin.labels[win]:setColor(0,125,0)
	mapwin.labels[win]:echo(win, "cyan", "c")
end

function mapwin:create()
  --reset the UI
  mapwinResetUI()
  --iterate the table of channels and create some windows and tabs
  for i,tab in ipairs(mapwin.windowlist) do
    mapwin.labels[tab] = Geyser.Label:new({
      name=string.format("label%s", tab),
    }, mapwin.labelBox)
    mapwin.labels[tab]:echo(tab, "white", "c")
    mapwin.labels[tab]:setColor(50,50,50)
    mapwin.labels[tab]:setClickCallback("mapwinSwitch", tab)
    if tab == "Map" then
 	mapwin.windows[tab] = Geyser.Mapper:new({
      x = 0,
      y = 25,
      height = "100%",
      width = "100%",
      name = string.format("mapwin%s", tab),
    }, mapwin.container)
    mapwin.windows[tab]:hide()
    else
    mapwin.windows[tab] = Geyser.MiniConsole:new({
      x = 0,
      y = 25,
      height = "100%",
      width = "100%",
      name = string.format("mapwin%s", tab),
    }, mapwin.container)
    mapwin.windows[tab]:setFontSize(8)
    mapwin.windows[tab]:setColor(0,0,0)
    mapwin.windows[tab]:hide()
    end
  end
  mapwinSwitch("Map")
end

function mapwinClearWindow(win)
	clearUserWindow(string.format("mapwin%s", win))
end

function mapwinAppendWindow(win, text)
	mapwin.windows[win]:cecho(text)
--	display(text)
end

function mapwinAppendWindowClickable(win, text, command, tip)
	echoLink(mapwin.windows[win].name, text, command, tip)
end

mapwin:create()

function updateRoomInfo()
   mapwinClearWindow("Room Info")
   updatedesc = tkm:SqlGetRoomDesc( lastId)
   local exits = getAllExits()
	local exitlist = "Exits: "
   updatedesc = string.gsub(updatedesc, ".\n", " ")
	local desc = wrap(updatedesc, 60)
   mapwinAppendWindow("Room Info", "<cyan>"..desc.."\n")
	local exitlen = 0 --for wrapping
   if exits then
		for i,v in pairs(exits) do
			exitlen = exitlen+string.len(i)
			if exitlen > 30 then
				mapwinAppendWindow("Room Info", "\n")
				exitlen=0
			end
			mapwinAppendWindowClickable("Room Info", i..", ", [[send("]]..i..[[");onFollow("]]..i..[[")]], i)
		end
	end
end

function wrap(str, limit, indent, indent1)
     indent = indent or ""
     indent1 = indent1 or indent
     limit = limit or 72
     local here = 1-#indent1
     return indent1..str:gsub("(%s+)()(%S+)()",
                              function(sp, st, word, fi)
                                if fi-here > limit then
                                  here = st - #indent
                                  return "\n"..indent..word
                                end
                              end)
end
