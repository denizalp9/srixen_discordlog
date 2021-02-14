# srixen_discordlog
Fivem server logging for basic and default events

## Setting up config.lua

Config.steamApiKey = "" Steam API Key is required to log chat messages with the players steam profile picture and name. You can get yours on: https://steamcommunity.com/dev/apikey

Config.webhookName = "YourWebhookNameHere" Your webhook name is the name of the discord logger 

Config.webhookLogo = "https://img.icons8.com/color/452/fivem.png" Your webhook logo is the profile picture of the discord logger

Config.useMultipleChannels = true Set to true if you want to use different text channel for each event.

Config.webhookUrl = "" This url will be used if useMultipleChannels is set to false.
