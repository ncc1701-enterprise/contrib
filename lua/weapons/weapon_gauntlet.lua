
SWEP.PrintName          = "Infinity Gauntlet"
SWEP.Author				= ""
SWEP.Contact			= ""
SWEP.Category 			= "Other"
SWEP.Instructions		= "*snap*"
SWEP.Slot               = 0
SWEP.SlotPos            = 0
SWEP.DrawAmmo           = false
SWEP.DrawCrosshair      = true

SWEP.ViewModel              = "models/swamp/v_infinitygauntlet.mdl"
SWEP.WorldModel             = "models/swamp/v_infinitygauntlet.mdl"
//SWEP.ViewModelFOV           = 60

SWEP.Spawnable				= true
SWEP.AdminOnly				= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= false
SWEP.Secondary.Ammo         = "none"

function FizzlePlayer(self,target,attacker)
	if Safe(target) then return end
	if SERVER then
		if (target:InVehicle()) then target:ExitVehicle() end
		local dmginfo = DamageInfo()
		dmginfo:SetDamage(100)
		dmginfo:SetDamageType(DMG_DISSOLVE)
		dmginfo:SetAttacker(attacker)
		dmginfo:SetDamageForce(Vector(0,0,1))
		dmginfo:SetInflictor(self)
		target:TakeDamageInfo(dmginfo)
		attacker:EmitSound("gauntlet/snap.wav", 100)
		timer.Simple(0,function() if IsValid(self) then self:Remove() end end)
	end
end

function SWEP:PrimaryAttack()
	local eyetrace = self.Owner:GetEyeTrace()
	
	if eyetrace.Hit then
		if (eyetrace.Entity:IsPlayer() and eyetrace.Entity:Alive()) then
			FizzlePlayer(self,eyetrace.Entity,self.Owner)
		else
			local target = {nil,50}
			for k,v in pairs(player.GetAll()) do
				if (v:Alive() and v ~= self.Owner) then
					local dis = math.sqrt(self.Owner:GetEyeTrace().HitPos:DistToSqr(v:LocalToWorld(v:OBBCenter())))
					if (dis < target[2]) then
						target = {v,dis}
					end
				end
			end
			if (target[2] < 50) then
				FizzlePlayer(self,target[1],self.Owner)
			end
		end
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Deploy()
	self:SetHoldType("fist")
end

function SWEP:DrawHUD()
	surface.DrawCircle(ScrW() / 2, ScrH() / 2, 2, Color(0,0,0,25))
	surface.DrawCircle(ScrW() / 2, ScrH() / 2, 1, Color(255, 255, 255,10)) 		
end

function SWEP:CreateWorldModel()
   if not IsValid(self.WModel) then
      self.WModel = ClientsideModel(self.WorldModel,RENDERGROUP_OPAQUE)
      self.WModel:SetNoDraw(true)
      self.WModel:SetBodygroup(1,1)
   end
   return self.WModel
end

function SWEP:DrawWorldModel()
	local wm = self:CreateWorldModel()
	
	local bone = self.Owner:LookupBone("ValveBiped.Bip01_L_Hand") or 0
	local opos = self:GetPos()
	local oang = self:GetAngles()
	local bp,ba = self.Owner:GetBonePosition(bone)
	if (bp) then opos = bp end
	if (ba) then oang = ba end
	
	wm:SetModelScale(3.5)
	
	opos = opos + oang:Right()*-18
	opos = opos + oang:Forward()*-19
	opos = opos + oang:Up()*3.5
	oang:RotateAroundAxis(oang:Right(),210)
	oang:RotateAroundAxis(oang:Forward(),-50)
	oang:RotateAroundAxis(oang:Up(),210)
	
	wm:SetRenderOrigin(opos)
	wm:SetRenderAngles(oang)
	wm:DrawModel()
end

function SWEP:OnRemove()
	if self.WModel then self.WModel:Remove() end
end
