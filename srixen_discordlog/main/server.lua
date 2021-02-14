-- Made by Srixen github.com/denizalp9, inspired from source code of Tazi0

function sendEmbed(header, message, color, ...) -- ... = webhookUrl
    local connect = {
          {
              ["color"] = color,
              ["title"] = "**".. header .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = "Improved discord logging by Srixen",
              },
          }
      }
    
    if not Config.useMultipleChannels then
        PerformHttpRequest(Config.webhookUrl, function(err, text, headers) end, 'POST', json.encode({username = Config.webhookName, embeds = connect, avatar_url = Config.webhookLogo}), { ['Content-Type'] = 'application/json' }) 
    elseif Config.useMultipleChannels then
        PerformHttpRequest(..., function(err, text, headers) end, 'POST', json.encode({username = Config.webhookName, embeds = connect, avatar_url = Config.webhookLogo}), { ['Content-Type'] = 'application/json' }) 
    end
end

function stringsplit(input, seperator)
	if seperator == nil then
		seperator = '%s'
	end
	local t={} ; i=1
	for str in string.gmatch(input, '([^'..seperator..']+)') do
		t[i] = str
		i = i + 1
	end
	return t
end

function GetIDFromSource(Type, ID)
    local IDs = GetPlayerIdentifiers(ID)
    for k, CurrentID in pairs(IDs) do
        local ID = stringsplit(CurrentID, ':')
        if (ID[1]:lower() == string.lower(Type)) then
            return ID[2]:lower()
        end
    end
    return nil
end

-- Default Events:

AddEventHandler('playerConnecting', function() 
    sendEmbed("Server Login", "**" .. GetPlayerName(source) .. "** is connecting to the server.", 3066993, Config.webhook.connections)
end)

AddEventHandler('playerDropped', function(reason) 
	local color = 15105570
	if string.match(reason, "Kicked") or string.match(reason, "Banned") then
		color = 10038562
	end
    sendEmbed("Server Logout", "**" .. GetPlayerName(source) .. "** has left the server. \n Reason: ".. reason, color, Config.webhook.connections)
end)

local doOk = true

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        sendEmbed('Resource Start','The resource **' .. resourceName .. '** has been started.', 10181046, Config.webhook.resources)
    else
        if not Config.useMultipleChannels then
            if Config.webhookUrl == '' or Config.webhookUrl == nil then
                print('\n[WARNING] srixen_discordlog: You are using single-channeled logging and the Config.webhookUrl is empty. Please be aware that the logger wont work unless there is a webhook registered to config.lua.\n')
                doOk = false
            end
            if doOk then
                print('\n[INFO] srixen_discordlog: Everything is up and running !\n')
            end   
        else
            if Config.webhook.chatMessage == '' or Config.webhook.chatMessage == nil then
                print('\n[WARNING] srixen_discordlog: You are using multi-channeled logging and the Config.webhook.chatMessage is empty. Please be aware that the chat logger wont work unless there is a webhook registered to config.lua.\n')
                doOk = false
            end
            if Config.webhook.connections == '' or Config.webhook.connections == nil then
                print('\n[WARNING] srixen_discordlog: You are using multi-channeled logging and the Config.webhook.connections is empty. Please be aware that the connection logger wont work unless there is a webhook registered to config.lua.\n')
                doOk = false
            end
            if Config.webhook.deathlog == '' or Config.webhook.deathlog == nil then
                print('\n[WARNING] srixen_discordlog: You are using multi-channeled logging and the Config.webhook.deathlog is empty. Please be aware that the death logger wont work unless there is a webhook registered to config.lua.\n')
                doOk = false
            end
            if Config.webhook.resources == '' or Config.webhook.resources == nil then
                print('\n[WARNING] srixen_discordlog: You are using multi-channeled logging and the Config.webhook.resources is empty. Please be aware that the resource logger wont work unless there is a webhook registered to config.lua.\n')
                doOk = false
            end
            if doOk then
                print('\n[INFO] srixen_discordlog: Everything is up and running !\n')
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        sendEmbed('Discord Logger has been stopped', 'This resource will not send any messages furthermore.', 15158332, Config.webhook.resources)
    else
        sendEmbed('Resource Stop', 'The resource **' .. resourceName .. '** was stopped.', 10181046, Config.webhook.resources)
    end
end)  
  
-- Chat 

AddEventHandler('chatMessage', function(source, name, message) 
    if message:sub(1, 1) == '/' then
        sendEmbed('Player tried to execute a command', 'Player: **' .. GetPlayerName(source) .. '** ran the command: ' .. message , 10181046, Config.webhook.chatMessage)
    else
        if string.match(message, "@everyone") then
            message = message:gsub("@everyone", "`@everyone`")
        end
        if string.match(message, "@here") then
            message = message:gsub("@here", "`@here`")
        end
        if Config.steamApiKey == '' or Config.steamApiKey == nil then
            PerformHttpRequest(Config.webhook.chatMessage, function(err, text, headers) end, 'POST', json.encode({username = name .. " [" .. source .. "]", content = message, tts = false}), { ['Content-Type'] = 'application/json' })
        else
            PerformHttpRequest('https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=' .. Config.steamApiKey .. '&steamids=' .. tonumber(GetIDFromSource('steam', source), 16), function(err, text, headers)
                local image = string.match(text, '"avatarfull":"(.-)","')
                PerformHttpRequest(Config.webhook.chatMessage, function(err, text, headers) end, 'POST', json.encode({username = name .. " [" .. source .. "]", content = message, avatar_url = image, tts = false}), { ['Content-Type'] = 'application/json' })
            end)
        end
    end
end)

-- Player Death Event

RegisterServerEvent('playerDied')
AddEventHandler('playerDied',function(message)
    sendEmbed("Death log", message, 15158332, Config.webhook.deathlog)
end)

--[[
Color codes for embed messages:

DEFAULT: 0,
AQUA: 1752220,
GREEN: 3066993,
BLUE: 3447003,
PURPLE: 10181046,
GOLD: 15844367,
ORANGE: 15105570,
RED: 15158332,
GREY: 9807270,
DARKER_GREY: 8359053,
NAVY: 3426654,
DARK_AQUA: 1146986,
DARK_GREEN: 2067276,
DARK_BLUE: 2123412,
DARK_PURPLE: 7419530,
DARK_GOLD: 12745742,
DARK_ORANGE: 11027200,
DARK_RED: 10038562,
DARK_GREY: 9936031,
LIGHT_GREY: 12370112,
DARK_NAVY: 2899536,
LUMINOUS_VIVID_PINK: 16580705,
DARK_VIVID_PINK: 12320855

--thanks to thomasbnt
]]