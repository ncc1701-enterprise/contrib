
RegisterChatLUACommand('help','ShowMotd("http://steamcommunity.com/groups/swampservers/discussions/0/133255810024702956/")')

RegisterChatConsoleCommand({'skip','voteskip'},"cinema_voteskip")
RegisterChatLUACommand('thirdperson',"THIRDPERSON = !THIRDPERSON")
RegisterChatLUACommand('virtualreality',"BOBBINGVIEW = !BOBBINGVIEW")
RegisterChatLUACommand({'global','ooc'},[[chat.AddText("[orange]Press "..input.LookupBinding("messagemode2"):upper().." to speak in Global chat.")]])

RegisterChatCommand({'kills','showkills'}, function(ply, arg)
	BotSayGlobal(ply:Nick().." has gotten [edgy]"..tostring(playerstats[ply:SteamID64()]["stat_kills"]).."[fbc] lifetime kills!")
end, {global=true, throttle=true})

RegisterChatCommand({'deaths','showdeaths'}, function(ply, arg)
	BotSayGlobal(ply:Nick().." has died [edgy]"..tostring(playerstats[ply:SteamID64()]["stat_deaths"]).."[fbc] times!")
end, {global=true, throttle=true})

RegisterChatCommand({'playtime','showplaytime'}, function(ply, arg)
	BotSayGlobal(ply:Nick().." has played for [rainbow]"..tostring(math.floor(playerstats[ply:SteamID64()]["stat_minutes"]/60)).."[fbc] hours!")
end, {global=true, throttle=true})

RegisterChatConsoleCommand({'drop','dropweapon'}, "drop")
RegisterChatConsoleCommand('dropall', "dropall")

concommand.Add("drop", function(ply, cmd, args)
	ply.LastWepDropTime = ply.LastWepDropTime or 0
	if (CurTime() - ply.LastWepDropTime) < 2 then
		return
	end
	ply.LastWepDropTime = CurTime()
	if IsValid(ply:GetActiveWeapon()) then
		local cl = ply:GetActiveWeapon():GetClass()
		if cl=="weapon_ebola" then return end
		ply:StripWeapon(cl)
	end
end)

concommand.Add("dropall", function(ply, cmd, args)
	ply.LastWepDropTime = ply.LastWepDropTime or 0
	if (CurTime() - ply.LastWepDropTime) < 2 then
		return
	end
	ply.LastWepDropTime = CurTime()
	for k,v in pairs(ply:GetWeapons()) do
		local cl = v:GetClass()
		if cl~="weapon_ebola" then
			ply:StripWeapon(cl)
		end
	end
end)
