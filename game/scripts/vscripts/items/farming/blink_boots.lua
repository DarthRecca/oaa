LinkLuaModifier( "modifier_blink_boots_oaa", "items/farming/blink_boots.lua", LUA_MODIFIER_MOTION_NONE ) -- Check if the target was damaged and set cooldown
LinkLuaModifier( "modifier_intrinsic_multiplexer", "modifiers/modifier_intrinsic_multiplexer.lua", LUA_MODIFIER_MOTION_NONE )

item_blink_boots_oaa = class(ItemBaseClass)

function item_blink_boots_oaa:GetIntrinsicModifierName()
	return "modifier_blink_boots_oaa"
end

function item_blink_boots_oaa:GetIntrinsicModifierName()
  return "modifier_intrinsic_multiplexer"
end

function item_blink_boots_oaa:OnSpellStart()
	local caster = self:GetCaster()
	local origin_point = caster:GetAbsOrigin()
	local target_point = self:GetCursorPosition()
	local distance = (target_point - origin_point):Length2D()
	local max_blink_range = self:GetSpecialValueFor("max_blink_range")

	--Dodging mechanics
	ProjectileManager:ProjectileDodge(caster)

	--Particle Management
	local blink_pfx = ParticleManager:CreateParticle(caster.blink_effect, origin_point, caster)
	ParticleManager:ReleaseParticleIndex(blink_pfx)

  --Emit Sound on activation
	caster:EmitSound("DOTA_Item.BlinkDagger.Activate")
end

-----------------------------------------------------------------------------------------------------------
--	Blink Dagger Modifier
-----------------------------------------------------------------------------------------------------------
modifier_blink_boots_oaa = class(ModifierBaseClass)

function modifier_blink_boots_oaa:IsHidden()
  return true
end

function modifier_blink_boots_oaa:IsDebuff()
  return false
end

function modifier_blink_boots_oaa:IsPurgable()
  return false
end

function modifier_blink_boots_oaa:RemoveOnDeath()
  return false
end

function modifier_blink_boots_oaa:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_blink_boots_oaa:OnCreated()
	self.bonus_movement_speed = ability:GetSpecialValueFor("bonus_movement_speed")
end

function modifier_blink_boots_oaa:GetModifierMoveSpeedBonus_Constant()
  return self.bonus_movement_speed
end

function modifier_blink_boots_oaa:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    MODIFIER_EVENT_ON_TAKEDAMAGE
  }
  return decFuncs
end

function modifier_blink_boots_oaa:OnTakeDamage( keys )
	local ability = self:GetAbility()
	local blink_damage_cooldown = ability:GetSpecialValueFor("blink_damage_cooldown")
	local parent = self:GetParent()			-- Modifier carrier
	local unit = keys.unit							-- Who took damage

	if parent == unit then
		if (keys.attacker:IsConsideredHero()) then
			if ability:GetCooldownTimeRemaining() < blink_damage_cooldown then
				ability:StartCooldown(blink_damage_cooldown)
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------
--Upgrades

item_blink_boots_1 = class(item_blink_boots_oaa)
item_blink_boots_2 = class(item_blink_boots_oaa)
item_blink_boots_3 = class(item_blink_boots_oaa)
item_blink_boots_4 = class(item_blink_boots_oaa)
item_blink_boots_5 = class(item_blink_boots_oaa)
