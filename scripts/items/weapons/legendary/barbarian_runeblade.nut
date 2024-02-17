barbarian_runeblade <- inherit("scripts/items/weapons/weapon", {
	m = {
		DamageBoost = 5
		StunChance  = 0
	}

	function create() {
		weapon.create();

		m.ID				= "weapon.barbarian_runeblade";
		m.Name				= "Old Ironhand's Rune Blade";
		m.Description		= "A long two-handed blade that makes for a versatile weapon. The reddened metal is inscribed with runes that almost seem to glow when held by Ironhand's chosen. Some claim to hear the weapon whisper to them during battles of portent.";
		m.Categories		= "Sword, Two-Handed";
		m.IconLarge			= "weapons/melee/barbarian_runeblade_01.png";
		m.Icon				= "weapons/melee/barbarian_runeblade_01_70x70.png";
		m.SlotType			= Const.ItemSlot.Mainhand;
		m.BlockedSlotType	= Const.ItemSlot.Offhand;
		m.ItemType			= Const.Items.ItemType.Weapon | Const.Items.ItemType.MeleeWeapon | Const.Items.ItemType.TwoHanded | Const.Items.ItemType.Legendary;
		m.IsAgainstShields	= true;
		m.IsAoE				= true;

		m.AddGenericSkill	= true;
		m.ShowQuiver		= false;
		m.ShowArmamentIcon	= true;
		m.ArmamentIcon		= "icon_barbarian_runeblade_01";

		m.Value				= 1500;

		m.ShieldDamage		= 16;
		m.Condition			= 90.0;
		m.ConditionMax		= 90.0;
		m.StaminaModifier	= -14;

		m.RegularDamage		= 60;
		m.RegularDamageMax	= 80;
		m.ArmorDamageMult	= 1.0;
		m.DirectDamageMult	= 0.25;
		m.DirectDamageAdd	= 0.1;
		m.ChanceToHitHead	= 5;
	}

	function getTooltip() {
		local result = weapon.getTooltip();
		result.push({ id = 6, type = "text", icon = "ui/icons/special.png", text = "Inflicts [color=" + Const.UI.Color.PositiveValue + "]+5[/color] damage for each of the wielder's active runes" });
		result.push({ id = 7, type = "text", icon = "ui/icons/special.png", text = "Inflicts [color=" + Const.UI.Color.PositiveValue + "]+20%[/color] damage against enemy leaders and champions" });
		return result;
	}

	function onEquip() {
		weapon.onEquip();

		local skillToAdd = new("scripts/skills/actives/overhead_strike");
		skillToAdd.setStunChance(m.StunChance);
		addSkill(skillToAdd);

		addSkill(new("scripts/skills/actives/split"));
		addSkill(new("scripts/skills/actives/swing"));

		local skillToAdd = new("scripts/skills/actives/split_shield");
		skillToAdd.setFatigueCost(skillToAdd.getFatigueCostRaw() + 5);
		addSkill(skillToAdd);

		if (getContainer().getActor() != null && !getContainer().getActor().isNull())
			getContainer().getActor().getSkills().add(new("scripts/skills/items/runeblade_skill"));
	}

	function onUnequip() {
		weapon.onUnequip();

		m.RegularDamage = 60;
		m.RegularDamageMax = 80;

		if (getContainer().getActor() != null && !getContainer().getActor().isNull())
			getContainer().getActor().getSkills().removeByID("items.runeblade_skill");
	}

	function onUpdateProperties( _properties ) {
		m.RegularDamage = 60;
		m.RegularDamageMax = 80;
		local actor = getContainer().getActor();

		if (actor != null && !actor.isNull() && actor.isAlive()) {
			local numRunes = actor.getFlags().getAsInt("numActiveRunes");
			if (numRunes != null && numRunes > 0) {
				m.RegularDamage += numRunes * m.DamageBoost;
				m.RegularDamageMax += numRunes * m.DamageBoost;
			}
		}

		weapon.onUpdateProperties(_properties);
	}
});
