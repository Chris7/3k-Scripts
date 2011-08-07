demonnic = demonnic or {}
function demonnic:echo(msg)
  cecho(string.format("<red>==<orange>Demonnic<red>==<green>:<grey> %s", msg))
end

demonnic = demonnic or {}
demonnic.chat = demonnic.chat or {}
demonnic.chat.tabsToBlink = demonnic.chat.tabsToBlink or {}
demonnic.chat.config = demonnic.chat.config or {}
demonnic.chat.tabs = demonnic.chat.tabs or {}
demonnic.chat.windows = demonnic.chat.windows or {}
demonnic.chat.config.activeColors = demonnic.chat.config.activeColors or {}
demonnic.chat.config.inactiveColors = demonnic.chat.config.inactiveColors or {}

--[[
This is where all of the configuration options can be set. 
Anything I've put in this script object can be changed, but please do pay attention to what you're doing.
If you change one of the values to something it shouldn't be, you could break it. 
]]


--[[
This is a table of channels you would like.
AKA the place you tell the script what tabs you want.
Each entry must be a string. The defaults should be a pretty effective guide.
]]

demonnic.chat.config.channels = {
  "All",
  "Guild",
  "Gossip",
  "Tells",
  "Says",
  "Souls",
  "Party",
}


--Set this to the name of the channel you want to have everything sent to. 
--Per the default, this would be the "All" channel. If you have a different name for it:
--
--demonnic.chat.config.Alltab = "Bucket"  
--
--And if you don't want it turned on at all:
--
--demonnic.chat.config.Alltab = false

demonnic.chat.config.Alltab = "All"



---------------------------------------------------------------------------------
--                                                                             --
--The infamous blinking stuff!!!                                               --
--                                                                             --
---------------------------------------------------------------------------------

--[[
Do you want tabs to blink when you get new messages, until you click on the tab?
True if yes, false if no.
]]
demonnic.chat.config.blink = true

--How long (in seconds) between blinks? For example, 1 would mean a 1 second pause in between blinks.
demonnic.chat.config.blinkTime = 3

--Blink if the bucket tab ("All" by default, but configured above) is in focus?
demonnic.chat.config.blinkFromAll = false




--Font size for the chat messages

demonnic.chat.config.fontSize = 8

--[[
Should we preserve the formatting of the text. 
Or should we set the background of it to match the window color?
Set this to false if you want the background for all chat to match the background of the window.
Useful if you change the background from black, and don't like the way the pasted chat makes blocks in it
]]

demonnic.chat.config.preserveBackground = false

--[[
Gag the chat lines in the main window?
defaults to false, set to true if you want to gag.
]]

demonnic.chat.config.gag = false

--[[
Number of lines of chat visible at once. 
Will determine how tall the window for the chats is.
]]

demonnic.chat.config.lines = 20

--[[
Number of characters to wrap the chatlines at.
This will also determine how wide the chat windows are.
]]

demonnic.chat.config.width = 60

--[[
Set the color for the active tab. R,G,B format.
The default here is a brightish green
]]

demonnic.chat.config.activeColors = {
  r = 0,
  g = 180,
  b = 0,
}

--[[
Set the color for the inactive tab. R,G,B format.
The default here is a drab grey
]]

demonnic.chat.config.inactiveColors = {
  r = 60,
  g = 60,
  b = 60,
}

--[[
Set the color for the chat window itself. R,G,B format.
Defaulted to the black of my twisted hardened soul. Or something.
]]

demonnic.chat.config.windowColors = {
  r = 0,
  g = 0,
  b = 0,
}

--[[
Set the color for the text on the active tab. Uses color names.
Set the default to purple. So the tab you're looking at, by default will be purple on bright green. 
Did I mention I'm a bit colorblind?
]]

demonnic.chat.config.activeTabText = "purple"

--[[
Set the color for the text on the inactive tabs. Uses color names.
Defaulted this to white. So the tabs you're not looking at will be white text on boring grey background.
]]

demonnic.chat.config.inactiveTabText = "white"

--[[
have to make sure a currentTab is set... 
so we'll use the one for the bucket, or the first one in the channels table
Or, you know... what it's currently set to, if it's already set.
]]
demonnic.chat.currentTab = demonnic.chat.currentTab or demonnic.chat.config.Alltab or demonnic.chat.config.channels[1]

--[[
If the label callbacks ever decide to start taking a function which is part of a table, 0then this will change.
Or if it's modified to take actual functions. Anonymouse function clickcallback would be awfully nice.
]]

function demonnicChatSwitch(chat)
  local r = demonnic.chat.config.inactiveColors.r
  local g = demonnic.chat.config.inactiveColors.g
  local b = demonnic.chat.config.inactiveColors.b
  local newr = demonnic.chat.config.activeColors.r
  local newg = demonnic.chat.config.activeColors.g
  local newb = demonnic.chat.config.activeColors.b
  local oldchat = demonnic.chat.currentTab
  if demonnic.chat.currentTab ~= chat then
    demonnic.chat.windows[oldchat]:hide()
    demonnic.chat.tabs[oldchat]:setColor(r,g,b)
    demonnic.chat.tabs[oldchat]:echo(oldchat, demonnic.chat.config.inactiveTabText, "c")
    if demonnic.chat.config.blink and demonnic.chat.tabsToBlink[chat] then
      demonnic.chat.tabsToBlink[chat] = nil
    end
    if demonnic.chat.config.blink and chat == demonnic.chat.config.Alltab then
      demonnic.chat.tabsToBlink = {}
    end
  end
  demonnic.chat.tabs[chat]:setColor(newr,newg,newb)
  demonnic.chat.tabs[chat]:echo(chat, demonnic.chat.config.activeTabText, "c")
  demonnic.chat.windows[chat]:show()
  demonnic.chat.currentTab = chat  
end

function demonnic.chat:resetUI()
  demonnic.chat.container = Geyser.Container:new({
    fontSize = demonnic.chat.config.fontSize,
    x=string.format("-%ic",demonnic.chat.config.width + 2),
    y=0,
    width="-15px",
    height=string.format("%ic", demonnic.chat.config.lines + 2),
    name="DemonChat",
  })

  demonnic.chat.tabBox = Geyser.HBox:new({
    x=0,
    y=0,
    width = "100%",
    height = "25px",
    name = "DemonChatTabs",
  },demonnic.chat.container)
end

function demonnic.chat:create()
  --reset the UI
  demonnic.chat:resetUI()
  --Set some variables locally to increase readability
  local r = demonnic.chat.config.inactiveColors.r
  local g = demonnic.chat.config.inactiveColors.g
  local b = demonnic.chat.config.inactiveColors.b
  local winr = demonnic.chat.config.windowColors.r
  local wing = demonnic.chat.config.windowColors.g
  local winb = demonnic.chat.config.windowColors.b

  --iterate the table of channels and create some windows and tabs
  for i,tab in ipairs(demonnic.chat.config.channels) do
    demonnic.chat.tabs[tab] = Geyser.Label:new({
      name=string.format("tab%s", tab),
    }, demonnic.chat.tabBox)
    demonnic.chat.tabs[tab]:echo(tab, demonnic.chat.config.inactiveTabText, "c")
    demonnic.chat.tabs[tab]:setColor(r,g,b)
    demonnic.chat.tabs[tab]:setClickCallback("demonnicChatSwitch", tab)
    demonnic.chat.windows[tab] = Geyser.MiniConsole:new({
--      fontSize = demonnic.chat.config.fontSize,
      x = 0,
      y = 25,
      height = "100%",
      width = "100%",
      name = string.format("win%s", tab),
    }, demonnic.chat.container)
    demonnic.chat.windows[tab]:setFontSize(demonnic.chat.config.fontSize)
    demonnic.chat.windows[tab]:setColor(winr,wing,winb)
    demonnic.chat.windows[tab]:setWrap(demonnic.chat.config.width)
    demonnic.chat.windows[tab]:hide()
  end
  local showme = demonnic.chat.config.Alltab or demonnic.chat.config.channels[1]
  demonnicChatSwitch(showme)
  --start the blink timers, if enabled
  if demonnic.chat.config.blink and not demonnic.chat.blinkTimerOn then
    demonnic.chat:blink()
  end
end

function demonnic.chat:append(chat)
  local r = demonnic.chat.config.windowColors.r
  local g = demonnic.chat.config.windowColors.g
  local b = demonnic.chat.config.windowColors.b
  selectCurrentLine()
  if demonnic.chat.config.preserveBackground then
    setBgColor(r,g,b)
  end
  copy()
  appendBuffer(string.format("win%s", chat))
  if demonnic.chat.config.gag then 
    deleteLine() 
    tempLineTrigger(1,1, [[if isPrompt() then deleteLine() end]])
  end
  if demonnic.chat.config.Alltab then appendBuffer(string.format("win%s", demonnic.chat.config.Alltab)) end
  if demonnic.chat.config.blink then 
    if (demonnic.chat.config.Alltab == demonnic.chat.currentTab) and not demonnic.chat.config.blinkOnAll then
      return
    else
      demonnic.chat.tabsToBlink[chat] = true
    end
  end
end

function demonnic.chat:blink()
  if demonnic.chat.blinkID then killTimer(demonnic.chat.blinkID) end
  if not demonnic.chat.config.blink then 
    demonnic.chat.blinkTimerOn = false
    return 
  end
  for tab,_ in pairs(demonnic.chat.tabsToBlink) do
    demonnic.chat.tabs[tab]:flash()
  end
  demonnic.chat.blinkID = tempTimer(demonnic.chat.config.blinkTime, function () demonnic.chat:blink() end)
end

function demonnicOnStart()
  demonnic.chat:create()
end