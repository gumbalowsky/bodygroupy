surface.CreateFont("sm", {
	font = "Roboto",
	size = 18,
	antialias = true,
	weight = 800
})

surface.CreateFont("md", {
	font = "Roboto",
	size = 24,
	antialias = true,
	weight = 800
})


function aktywnySkin()

	return LocalPlayer():GetSkin()

end
--funkcja na wektor
function InverseLerp( pos, p1, p2 )

	local range = 0
	range = p2-p1

	if range == 0 then return 1 end

	return ((pos - p1)/range)

end
--Nadaj bodygroupe, skin i model ostatnio zapisany
function nadajzpliku()

local model = LocalPlayer():GetModel()
	modele = {}
	modele = util.JSONToTable(file.Read("bodygroupy.txt", "DATA"))
		if(!modele[model]) then zapiszdopliku() end
			local skin = modele[model]["skin"]
				for k, v in pairs(LocalPlayer():GetBodyGroups()) do
					local vid = v.id+1
					local id = modele[model][vid]
					net.Start("bodygroupy_grupy")
					net.WriteTable( { vid, id } )
					net.SendToServer()
				end
			net.Start("bodygroupy_skiny")
			net.WriteInt(skin, 8)
			net.SendToServer()

	net.Start("bodygroupy_model")
	net.WriteTable(modele["ostatni"])
	net.SendToServer()
end
--Zapis wszystkiego do pliku clientside
function zapiszdopliku()
	modele = {}
	modele = util.JSONToTable(file.Read("bodygroupy.txt", "DATA"))
	local model = LocalPlayer():GetModel()
	local skin = LocalPlayer():GetSkin()
	local curgroups = LocalPlayer():GetBodyGroups()
	modele[model] = {
		skin = skin,
		bg = curgroups,
	}
	modele["ostatni"] = { model }
		for k,v in pairs(curgroups) do
			local id = LocalPlayer():GetBodygroup(v.id)
			modele[model][v.id+1] = id
		end
	file.Write("bodygroupy.txt", util.TableToJSON(modele))
end


function otworz()

	if not file.Exists("bodygroupy.txt", "DATA") then
		file.Append("bodygroupy.txt")
		file.Write("bodygroupy.txt", util.TableToJSON({}))
		print("Stworzono brakujący plik bodygroupy.txt")
	end




--glowne okno i dodatki
local frame = vgui.Create("DFrame")
	frame:SetSize( ScrW()*.75, ScrH()*.85 )
	frame:Center()
	frame:SetTitle("")
	frame:SetVisible( true )
	frame:SetDraggable( false )
	frame:ShowCloseButton( false )
	frame:MakePopup()
		frame.Paint = function( self, w, h )
			draw.RoundedBox( 2, 0, 0, w, h, Color( 0, 43, 13, 200 ) )
		end
	--pionowa 1/3 dlugosci od model
	local frameprzecinek = vgui.Create("DFrame", frame)
	frameprzecinek:SetSize( 3, frame:GetTall() )
	frameprzecinek:SetPos(frame:GetWide()*(1/3)-15,0)
	frameprzecinek:SetVisible( true )
	frameprzecinek:SetDraggable( false )
		frameprzecinek.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 255, 13, 200 ) )
		end
	--pozioma gorna
	local frameprzecinek2 = vgui.Create("DFrame", frame)
	frameprzecinek2:SetSize( frame:GetWide() , 3 )
	frameprzecinek2:SetPos(0,0)
	frameprzecinek2:SetVisible( true )
	frameprzecinek2:SetDraggable( false )
		frameprzecinek2.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 255, 13, 200 ) )
		end
	--pionowa lewa
	local frameprzecinek3 = vgui.Create("DFrame", frame)
	frameprzecinek3:SetSize( 3, frame:GetTall() )
	frameprzecinek3:SetPos(0,0)
	frameprzecinek3:SetVisible( true )
	frameprzecinek3:SetDraggable( false )
		frameprzecinek3.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 255, 13, 200 ) )
		end
	--pozioma dolna
	local frameprzecinek4 = vgui.Create("DFrame", frame)
	frameprzecinek4:SetSize( frame:GetWide()*(1/3)-15, 3 )
	frameprzecinek4:SetPos(0, frame:GetTall()-3)
	frameprzecinek4:SetVisible( true )
	frameprzecinek4:SetDraggable( false )
		frameprzecinek4.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 255, 13, 200 ) )
		end
	--logo
	local firestone = vgui.Create( "DImage", frame )
	firestone:SetPos( frame:GetWide()-125, frame:GetTall()-125 )
	firestone:SetSize( 120, 120 )
	firestone:SetImage( "firestone/logo.png" )
	--model
	local pmodel = vgui.Create("DModelPanel", frame)
	pmodel:SetSize( pmodel:GetParent():GetWide()*(1/3) - 8, pmodel:GetParent():GetTall() - 40 )
	pmodel:SetPos( 4, 1 )
	pmodel:SetModel( LocalPlayer():GetModel() )
	pmodel:SetLookAt( Vector(0,0,72/2) )
	pmodel:SetCamPos( Vector(64,0,72/2))
	pmodel.Entity:SetEyeTarget( pmodel.Entity:GetPos() + Vector(200,0,64) )
	pmodel.Entity:SetSkin( LocalPlayer():GetSkin() )
	pmodel.rot = 110
	pmodel.fov = 45
	pmodel:SetFOV( pmodel.fov )
	pmodel.dragging = false
	pmodel.dragging2 = false
	pmodel.ux = 0
	pmodel.uy = 0
	pmodel.spinmul = 0.9
	pmodel.zoommul = 0.09
	pmodel.xmod = 0
	pmodel.ymod = 0
	--przycisk close
	local zamknij = vgui.Create("DButton", frame)
	zamknij:SetSize(frame:GetWide()*0.2, frame:GetTall()*0.05)
	zamknij:SetPos(frame:GetWide()*(1/16), frame:GetTall()*(1/16))
	zamknij:SetText("Aplikuj")
	zamknij:SetFont("md")
	zamknij:SetTextColor( Color( 20, 240, 116 ) )
		zamknij.Paint = function( self, w, h )
			draw.RoundedBox( 2, 0, 0, w, h, Color( 0, 43, 13, 110) )
			surface.SetDrawColor( Color( 20, 240, 116, 255 ) )
			surface.DrawOutlinedRect( 0, 0, frame:GetWide()*0.2, frame:GetTall()*0.05 )
		end
	
	zamknij.OnCursorEntered = function()
		zamknij:SetTextColor( Color( 255,255,255 ) )
	end
	zamknij.OnCursorExited = function()
		zamknij:SetTextColor( Color( 20, 240, 116 ) )
	end
	--Funkcja przycisku
	function zamknij:DoClick()
		zapiszdopliku()
		surface.PlaySound("buttons/button24.wav")
		frame:Close()
	end

	
	--poruszanie modelem
	function pmodel:LayoutEntity( ent )

		local newrot = self.rot
		local newfov = self:GetFOV()

		if self.dragging == true then
			newrot = self.rot + (gui.MouseX() - self.ux)*self.spinmul
			newfov = self.fov + (self.uy - gui.MouseY()) * self.zoommul
			if newfov < 20 then newfov = 20 end
			if newfov > 50 then newfov = 50 end
		end

		local newxmod, newymod = self.xmod, self.ymod

		if self.dragging2 == true then
			newxmod = self.xmod + (self.ux - gui.MouseX())*0.02
			newymod = self.ymod + (self.uy - gui.MouseY())*0.02
		end

		newxmod = math.Clamp( newxmod, -16, 16 )
		newymod = math.Clamp( newymod, -16, 16 )

		ent:SetAngles( Angle(0,0,0) )
		self:SetFOV( newfov )


		local height = 100/2
		local frac = InverseLerp( newfov, 75, 20 )
		height = Lerp( frac, 72/2, 64 )

		local norm = (self:GetCamPos() - Vector(0,0,64))
		norm:Normalize()
		local lookAng = norm:Angle()

		self:SetLookAt( Vector(0,0,height-(2*frac) ) - Vector( 0, 0, newymod*2*(1-frac) ) - lookAng:Right()*newxmod*2*(1-frac) )
		self:SetCamPos( Vector( 64*math.sin( newrot * (math.pi/180)), 64*math.cos( newrot * (math.pi/180)), height + 4*(1-frac)) - Vector( 0, 0, newymod*2*(1-frac) ) - lookAng:Right()*newxmod*2*(1-frac) )

	end

	function pmodel:OnMousePressed( k )
		self.ux = gui.MouseX()
		self.uy = gui.MouseY()
		self.dragging = (k == MOUSE_LEFT) or false 
		self.dragging2 = (k == MOUSE_RIGHT) or false 
	end

	function pmodel:OnMouseReleased( k )
		if self.dragging == true then
			self.rot = self.rot + (gui.MouseX() - self.ux)*self.spinmul
			self.fov = self.fov + (self.uy - gui.MouseY()) * self.zoommul
			self.fov = math.Clamp( self.fov, 20, 75 )
		end

		if self.dragging2 == true then
			self.xmod = self.xmod + (self.ux - gui.MouseX())*0.02
			self.ymod = self.ymod + (self.uy - gui.MouseY())*0.02

			self.xmod = math.Clamp( self.xmod, -16, 16 )
			self.ymod = math.Clamp( self.ymod, -16, 16 )
		end

		self.dragging = false 
		self.dragging2 = false
	end

	function pmodel:OnCursorExited()
		if self.dragging == true or self.dragging2 == true then
			self:OnMouseReleased()
		end
	end
	--nadaj bodygroup pmodel
	local curgroups = LocalPlayer():GetBodyGroups()

	for k,v in pairs( curgroups ) do
		local ent = pmodel.Entity
		local cur_bgid = LocalPlayer():GetBodygroup( v.id )
		ent:SetBodygroup( v.id, cur_bgid )
	end
	
	cpan = vgui.Create("DScrollPanel", frame)
	cpan:SetSize( cpan:GetParent():GetWide()*(1/1.5)-4, cpan:GetParent():GetTall() - 44 )
	cpan:SetPos( 4+4+cpan:GetParent():GetWide()*(1/3)-8, 32)
	--poziomy scroll
	horyzont = vgui.Create("DHorizontalScroller", cpan)
	horyzont:SetSize(cpan:GetWide(), 30)
	horyzont:SetPos(0, 28)
	horyzont:SetOverlap( -10 )
	horyzont.btnLeft:SetPos(0,100)
	--niewidzialny scroll bar pion
	local sbar = cpan:GetVBar()
		function sbar:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, 6, h, Color( 0, 0, 0, 0) )
		end
		function sbar.btnUp:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 100, 0, 0 ) )
		end
		function sbar.btnDown:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 100, 0, 0 ) )
		end
		function sbar.btnGrip:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, 6, h, Color( 100, 200, 0, 0) )
		end
		cpan.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 43, 13, 0 ) ) 
		end

--Szukaj skinow i wypisz, nadaj
	local skins = {}
	for i=0,LocalPlayer():SkinCount()-1 do
			table.insert( skins, i )
	end
		if skins != {} then
			local bgtytul = cpan:Add("DLabel")
			bgtytul:SetText("Skin")
			bgtytul:SetFont("md")
			bgtytul:SetPos(cpan:GetWide()*(1/2.5), 0)
			bgtytul:SizeToContents()
			bgtytul:SetWide( cpan:GetWide() )
			bgtytul:SetExpensiveShadow(1,Color(0,0,0))
				for k,i in ipairs(skins) do
					local btn = vgui.Create("DButton", cpan)
					horyzont:AddPanel(btn)
					btn:SetSize( 50, 28 )
					btn:SetText( tostring(i) )
					btn:SetPos(i*60, 30)
					btn:SetFont("sm")
					btn:SetTextColor( Color( 255, 255, 255 ) )
					btn.skinNumber = i
						btn.Paint = function(self, w, h)
							if(aktywnySkin()==i) then
								surface.SetDrawColor( 20, 240, 116, 255 )
								draw.RoundedBox( 3, 0,0 , w, h, Color( 20, 240, 116, 255 ) )
							else
								surface.SetDrawColor( 0, 43, 13, 255 )
								draw.RoundedBox( 3, 0,0 , w, h, Color( 0, 43, 13, 255 ) )
							end
				end

	
			function btn:DoClick()
					pmodel.Entity:SetSkin( self.skinNumber )
					net.Start("bodygroupy_skiny")
					net.WriteInt(self.skinNumber, 8)
					net.SendToServer()
					surface.PlaySound("buttons/lightswitch2.wav")
			end
		end
	end
	local bgroupy = {}
	local ply = LocalPlayer()
		for i = 2, #ply:GetBodyGroups() do
			local bg = ply:GetBodyGroups()[i]
				if bg then
					for k,v in pairs( bg ) do
						if k == "name" then
							bgroupy[v] = {}
								for k2, v2 in pairs( bg["submodels"] ) do
									table.insert( bgroupy[v], k2 )
								end
						end
					end	
				end
		end
	
	--szukaj bgroup wypisz i nadaj
		if(bgroupy != {}) then
			local b = 0
				for bnam, bvar in pairs(bgroupy) do		
					b = b+1
					local bglabel = cpan:Add("DLabel")
					bglabel:SetFont("sm")
					bglabel:SetText(string.upper(string.Replace(bnam, "_", " ")))
					bglabel:SizeToContents()
					bglabel:SetPos(4, 80*b)
					bglabel:SetExpensiveShadow(1,Color(0,0,0))
						for _,i in ipairs(bvar) do 
							local btn = vgui.Create("DButton", cpan)
							btn:SetSize( 50, 28 )
							btn:SetText( tostring(i)		)
							btn:SetPos(60*i, 80*b+28)
							btn:SetFont("sm")
							btn:SetTextColor( Color( 255, 255, 255 ) )
							btn.bg_name = bnam
							btn.bg_num = i
								btn.Paint = function(self, w, h)   
									surface.SetDrawColor( 12, 127, 59, 255 )
									draw.RoundedBox( 3, 0,0 , w, h, Color( 12, 127, 59, 255 ) )
								end
								btn.OnCursorEntered = function()
									btn.Paint = function(self, w, h)   
										surface.SetDrawColor( 0, 43, 13, 255 )
										draw.RoundedBox( 3, 0,0 , w, h, Color( 0, 43, 13, 255 ) )
									end
								end
								btn.OnCursorExited = function()
									btn.Paint = function(self, w, h)   
										surface.SetDrawColor( 12, 127, 59, 255 )
										draw.RoundedBox( 3, 0,0 , w, h, Color( 12, 127, 59, 255 ) )
									end
								end
				function btn:DoClick()
						local ent = pmodel.Entity
						local bgid = ent:FindBodygroupByName( self.bg_name )
							if bgid != -1 then
								ent:SetBodygroup( bgid, self.bg_num )
								net.Start("bodygroupy_grupy")
								net.WriteTable( { bgid, self.bg_num } )
								net.SendToServer()
								surface.PlaySound("buttons/lightswitch2.wav")
							end
					end
				end
		end
	end
end
--warunki do otworzenia menu
net.Receive( "otwarciemenu", function()
otworz()
end)
--nadanie BG, skin, modelu
net.Receive("daj", function()
nadajzpliku()
end)