---------------------------------------------------------------------------

script_name("radio")
script_version_number(2.1)
script_version("2.1")
script_author("Narvell")
script_dependencies("SAMPFUNCS")
script_moonloader(26)
script_url("narvell.pw")

---------------------------------------------------------------------------

local sampev = require 'lib.samp.events'
local inicfg = require "inicfg"
local mainIni = inicfg.load(nil, "radio")

---------------------------------------------------------------------------

chatTag = "{FF5F5F}"..thisScript().name.."{ffffff}"

---------------------------------------------------------------------------

timerVarOne = os.time()
timerVarTwo = os.time()

MyNickname = ""

---------------------------------------------------------------------------

function main()
  while not isSampAvailable() do wait(1000) end

  sampRegisterChatCommand("sr", EnableRadio)

  sampRegisterChatCommand("r1", r1Func)
  sampRegisterChatCommand("r2", r2Func)
  sampRegisterChatCommand("r3", r3Func)
  sampRegisterChatCommand("r4", r4Func)

  if not mainIni then
    resetIniSettings()
    wait(1000)
    mainIni = inicfg.load(nil, "radio")
  end

  while true do wait(0)
    result, MyID = sampGetPlayerIdByCharHandle(playerPed)
    MyNickname = sampGetPlayerNickname(MyID)

    timerOne = tonumber(os.time() - timerVarOne)
    timerTwo = tonumber(os.time() - timerVarTwo)

    text, prefix, color, pcolor = sampGetChatString(99)

    if mainIni.settings.enable then
      RP()
    end

  end
end

function sampev.onServerMessage(color, text)
  if not sampIsChatInputActive() then
    if string.find(text, ".+  "..MyNickname..":  .+") then
      if timerTwo >= mainIni.settings.timer_outgoing then
        -- sampAddChatMessage("!", - 1)
        isSendMessage = true
      end
    elseif string.find(text, ".+  %a+_%a+:  .+") then
      if timerOne >= mainIni.settings.timer_incoming then
        -- sampAddChatMessage("!", - 1)
        isReceiveMessage = true
      end
    end
  end
end

function RP()
  if isSendMessage then
    wait(1100)
    sampSendChat(mainIni.settings.outgoing)
    timerVarTwo = os.time()
    -- sampAddChatMessage("!", - 1)
    isSendMessage = false
  end
  if isReceiveMessage then
    sampSendChat(mainIni.settings.incoming)
    timerVarOne = os.time()
    -- sampAddChatMessage("!", - 1)
    isReceiveMessage = false
  end
end

---------------------------------------------------------------------------

function EnableRadio()
  mainIni.settings.enable = not mainIni.settings.enable
  if mainIni.settings.enable then
    sampAddChatMessage("["..chatTag.."]: Отыгровка включена.", - 1)
  else
    sampAddChatMessage("["..chatTag.."]: Отыгровка выключена.", - 1)
  end
end

---------------------------------------------------------------------------

function r1Func(text)
  sampSendChat("/r "..mainIni.settings.r1Tag.." "..text, - 1)
end

function r2Func(text)
  sampSendChat("/r "..mainIni.settings.r2Tag.." "..text, - 1)
end

function r3Func(text)
  sampSendChat("/r "..mainIni.settings.r3Tag.." "..text, - 1)
end

function r4Func(text)
  sampSendChat("/r "..mainIni.settings.r4Tag.." "..text, - 1)
end

function resetIniSettings()
  local mainIni = inicfg.load({
    settings =
    {
      enable = true,
      timer_incoming = 20,
      timer_outgoing = 10,

      r1Tag = "[TagOme]:",
      r2Tag = "[TagTwo]:",
      r3Tag = "[TagThree]:",
      r4Tag = "[TagFour]:",

      incoming = "/seedo Из радиостанции доносятся звуки переговоров",
      outgoing = "/seeme Нажал кнопку на тангенте рации и передал сообщение",
    },
  })
  inicfg.save(mainIni, "radio")
end
