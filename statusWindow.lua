-------------------------------------------------
--         Put your Lua functions here.        --
--                                             --
-- Note that you can also use external Scripts --
-------------------------------------------------
--stolen from Demonnic's tabbed chat
status = status or {}
status.windows = status.windows or {}
status.labelbox = status.labelbox or {}
status.labels = status.labels or {}
status.windowlist = {"Guild", "Misc"}

function statusResetUI()
  status.container = Geyser.Container:new({
    fontSize = 8,
    x="-50c",
    y="-20c",
    width="200",
    height="200",
    name="StatusWindow",
  })
  status.labelBox = Geyser.HBox:new({
    x=0,
    y=0,
    width = "100%",
    height = "25px",
    name = "StatusWindowLabels",
  },status.container)
end

function statusSwitch(win)
	local oldwin = status.currentWindow
	if oldwin then
		status.windows[oldwin]:hide()
		status.labels[oldwin]:setColor(50,50,50)
		status.labels[oldwin]:echo(oldwin, "white", "c")
	end
	status.currentWindow = win
	status.windows[win]:show()
	status.labels[win]:setColor(0,125,0)
	status.labels[win]:echo(win, "cyan", "c")
end

function status:create()
  --reset the UI
  statusResetUI()
  --iterate the table of channels and create some windows and tabs
  for i,tab in ipairs(status.windowlist) do
    status.labels[tab] = Geyser.Label:new({
      name=string.format("label%s", tab),
    }, status.labelBox)
    status.labels[tab]:echo(tab, "white", "c")
    status.labels[tab]:setColor(50,50,50)
    status.labels[tab]:setClickCallback("statusSwitch", tab)
    status.windows[tab] = Geyser.MiniConsole:new({
      x = 0,
      y = 25,
      height = "100%",
      width = "100%",
      name = string.format("statwin%s", tab),
    }, status.container)
    status.windows[tab]:setFontSize(8)
    status.windows[tab]:setColor(0,0,0)
    status.windows[tab]:hide()
  end
  statusSwitch("Guild")
end

function statusClearWindow(win)
	clearUserWindow(string.format("statwin%s", win))
end

function statusAppendWindow(win, text)
	status.windows[win]:cecho(text)
--	display(text)
end

status:create()