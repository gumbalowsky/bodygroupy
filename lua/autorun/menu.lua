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

function InverseLerp( pos, p1, p2 )

	local range = 0
	range = p2-p1

	if range == 0 then return 1 end

	return ((pos - p1)/range)

end

function otworz()
local frame = vgui.Create("DFrame")
	frame:SetSize( ScrW()*.75, ScrH()*.85 )
	frame:Center()
	frame:SetTitle("")
	frame:SetVisible( true )
	frame:SetDraggable( false )
	frame:ShowCloseButton( true )
	frame:MakePopup()
	frame.Paint = function( self, w, h )
	draw.RoundedBox( 2, 0, 0, w, h, Color( 0, 43, 13, 200 ) )
	end
	local frameprzecinek = vgui.Create("DFrame", frame)
	frameprzecinek:SetSize( 3, frame:GetTall() )
	frameprzecinek:SetPos(frame:GetWide()*(1/3)-15,0)
	frameprzecinek:SetVisible( true )
	frameprzecinek:SetDraggable( false )
	frameprzecinek.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 255, 13, 200 ) )
	end
	local frameprzecinek2 = vgui.Create("DFrame", frame)
	frameprzecinek2:SetSize( frame:GetWide() , 3 )
	frameprzecinek2:SetPos(0,0)
	frameprzecinek2:SetVisible( true )
	frameprzecinek2:SetDraggable( false )
	frameprzecinek2.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 255, 13, 200 ) )
	end
	local frameprzecinek3 = vgui.Create("DFrame", frame)
	frameprzecinek3:SetSize( 3, frame:GetTall() )
	frameprzecinek3:SetPos(0,0)
	frameprzecinek3:SetVisible( true )
	frameprzecinek3:SetDraggable( false )
	frameprzecinek3.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 255, 13, 200 ) )
	end
	
	local firestone = vgui.Create( "DImage", frame )
			firestone:SetPos( frame:GetWide()-125, frame:GetTall()-125 )
			firestone:SetSize( 120, 120 )
			firestone:SetImage( "firestone/logo.png" )
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

	local curgroups = LocalPlayer():GetBodyGroups()

	for k,v in pairs( curgroups ) do
		local ent = pmodel.Entity
		local cur_bgid = LocalPlayer():GetBodygroup( v.id )
		ent:SetBodygroup( v.id, cur_bgid )
	end

	cpan = vgui.Create("DPanel", frame)
	cpan:SetSize( cpan:GetParent():GetWide()*(1/1.5)-4, cpan:GetParent():GetTall() - 44 )
	cpan:SetPos( 4+4+cpan:GetParent():GetWide()*(1/3)-8, 32)
	cpan.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 43, 13, 0 ) ) 
	end


	local skins = {}
	for i=0,LocalPlayer():SkinCount()-1 do
			table.insert( skins, i )
	end
	if skins != {} then
	local bgtytul = cpan:Add("DLabel")
	bgtytul:SetText("Ubranie")
	bgtytul:SetFont("md")
	bgtytul:SetPos(cpan:GetWide()*(1/2.5), 0)
	bgtytul:SizeToContents()
	bgtytul:SetWide( cpan:GetWide() )
	bgtytul:SetExpensiveShadow(1,Color(0,0,0))
	for k,i in ipairs(skins) do
	local btn = vgui.Create("DButton", cpan)
	btn:SetSize( 50, 28 )
	btn:SetText( tostring(i) )
	btn:SetPos(i*60, 30)
	btn:SetFont("sm")
	btn:SetTextColor( Color( 255, 255, 255 ) )
	btn.skinNumber = i
	btn.Paint = function(self, w, h)
	if(aktywnySkin()==i)
	then
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
					surface.PlaySound("buttons/button24.wav")
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
	
	
		if(bgroupy != {}) then
		local b = 0
		for bnam, bvar in pairs(bgroupy) do		
		b = b+1
		local bglabel = cpan:Add("DLabel")
			bglabel:SetFont("sm")
			bglabel:SetText(string.upper(bnam))
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
							surface.PlaySound("buttons/button24.wav")
						end
					end
		end
		
		end
		end
	
	
end

net.Receive( "otwarciemenu", function()
otworz()
end)