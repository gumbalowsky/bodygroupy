util.AddNetworkString("bodygroupy_skiny")
util.AddNetworkString("bodygroupy_grupy")
util.AddNetworkString("bodygroupy_model")
util.AddNetworkString("otwarciemenu")
util.AddNetworkString("daj")
--skin
	net.Receive("bodygroupy_skiny", function(len, ply)
		local skin_id = net.ReadInt(8)
		ply:SetSkin(skin_id)
	end)
--model
	net.Receive("bodygroupy_model", function(len, ply)
		local model = net.ReadTable()
		ply:SetModel(model[1])
	end)
--bodygroupy
	net.Receive("bodygroupy_grupy", function(len, ply)
		local bodygroupy = net.ReadTable()
		[1] = math.Round(bodygroupy[1])
		bodygroupy[2] = math.Round(bodygroupy[2])
		ply:SetBodygroup(bodygroupy[1], bodygroupy[2])
	end)
--testowe playersay
hook.Add("PlayerSay", "otworzenie", function(ply,text,team)
	if(text=="!test") then
		net.Start("otwarciemenu")
		net.Send(ply)
		return ""
	end
	
	if(text=="!daj") then
		net.Start("daj")
		net.Send(ply)
		return ""
	end
end)