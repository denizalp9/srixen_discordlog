Config = {}
Config.webhook = {}

Config.steamApiKey = "" -- https://steamcommunity.com/dev/apikey
Config.webhookName = "YourWebhookNameHere" 
Config.webhookLogo = "https://cdn.discordapp.com/avatars/397804198483460107/00178a8ac33d06fc1e91c5e111835a9e.png?size=256"
Config.useMultipleChannels = true   -- set to "true" if you want to use a text channel for each event, set to "false" if you dont.

-- If useMultipleChannels is set to false, the variable below will be the default text channel
Config.webhookUrl = ""

-- If not, all the variables below will be the channel for each event
Config.webhook.chatMessage = ""
Config.webhook.resources = ""
Config.webhook.connections = ""
Config.webhook.deathlog = ""