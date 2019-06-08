util.AddNetworkString("bodygroupy_skiny")
util.AddNetworkString("bodygroupy_grupy")
util.AddNetworkString("otwarciemenu")

net.Receive("bodygroupy_skiny", function(len, ply)


	local skin_id = net.ReadInt(8)

	ply:SetSkin(skin_id)
	
end)

net.Receive("bodygroupy_grupy", function(len, ply)


	local data = net.ReadTable()
	data[1] = math.Round(data[1])
	data[2] = math.Round(data[2])
	ply:SetBodygroup(data[1], data[2])
	
end)

hook.Add("PlayerSay", "otworzenie", function(ply,text,team)
	if(text=="!test")
	then
	net.Start("otwarciemenu")
	net.Send(ply)
	return ""
	end
end)