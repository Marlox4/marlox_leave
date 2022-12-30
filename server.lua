TriggerEvent('esx:getSharedObject', function(sharedObject)
    ESX = sharedObject
end)

RegisterCommand("testing", function(source, args, rawcmd)
    local coords = GetEntityCoords(GetPlayerPed(source))
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent("marlox_senden", -1, source, coords, xPlayer.getIdentifier(), "dsadasd")
    discordlogs(coords,"DASDASD ", xPlayer)
end)

AddEventHandler("playerDropped", function(reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent("marlox_senden", -1, source, GetEntityCoords(GetPlayerPed(source)), xPlayer.getIdentifier(), reason)
    if Discord.DiscordLog then
        discordlogs(GetEntityCoords(GetPlayerPed(source)), reason, xPlayer)
    end
end)

function discordlogs(coords,text, xPlayer)
    local discord = "UNBEKANNT"
    for m, n in ipairs(GetPlayerIdentifiers(xPlayer.source)) do
        if n:match("discord") then
            discord = n:gsub("discord:", "")
        end
    end
    local embeds = {
        {
            ["title"]= Discord.title,
            ["description"]= "**"..text.."**",
            ["type"]= "rich",
            ["color"] =Discord.color,
            ["fields"] = {
                {
                    ["name"] = "``Identifier``",
                    ["value"] = xPlayer.getIdentifier().."\nDiscord: <@"..discord..">",
                },{
                    ["name"] = "``Name``",
                    ["value"] = GetPlayerName(xPlayer.source),
                },{
                    ["name"] = "``Spieler ID``",
                    ["value"] = xPlayer.source,
                },{
                    ["name"] = "``Koordianten``",
                    ["value"] = "X: "..coords.x..", Y: "..coords.y..", Z: "..coords.z,
                },{
                    ["name"] = "``Grund``",
                    ["value"] = text,
                },
            },
            ["footer"]=  {
            ["text"]= Discord.text,
            ["icon_url"] = Discord.icon_url
        },
        },
    }
    PerformHttpRequest(Discord.webhook, function(err, text, headers) end, 'POST', json.encode({avatar_url = Discord.avatar_url, username =Discord.username,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end