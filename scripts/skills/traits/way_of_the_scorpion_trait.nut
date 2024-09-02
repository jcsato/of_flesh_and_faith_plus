way_of_the_scorpion_trait <- inherit("scripts/skills/traits/character_trait", {
	m = {
		DamageReduction	= 20
	}

	function create() {
		character_trait.create();

		m.ID			= "trait.way_of_the_scorpion";
		m.Name			= "Way of the Scorpion";
		m.Icon			= "ui/traits/trait_icon_plus_08.png";
		m.Type			= Const.SkillType.Trait | Const.SkillType.Perk;
		m.Order			= Const.SkillOrder.VeryLast - 1;
		m.Description	= "No man is without flaw, no creature incapable of error. To best a target, then, is a matter of enduring until they make such an error - and then striking decisively. Such is the Way of the Scorpion.";

		m.Excluded		= [ ];
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 10, type = "text", icon = "ui/icons/regular_damage.png", text = "Receives only [color=" + Const.UI.Color.PositiveValue + "]" + (100 - m.DamageReduction) + "%[/color] of any damage from attackers that have a higher percentage of built up Fatigue" }
			{ id = 11, type = "text", icon = "ui/icons/fatigue.png", text = "[color=" + this.Const.UI.Color.PositiveValue + "]+2[/color] Fatigue Recovery per turn" }
			{ id = 12, type = "text", icon = "ui/icons/special.png", text = "Builds up [color=" + this.Const.UI.Color.PositiveValue + "]1[/color] less Fatigue for each tile travelled" }
		];

		return ret;
	}

	function onBeforeDamageReceived(_attacker, _skill, _hitInfo, _properties) {
		if ((_attacker != null && _attacker.getID() == getContainer().getActor().getID()) || _skill == null || !_skill.isAttack() || !_skill.isUsingHitchance())
			return;

		if (getContainer().getActor().getFatiguePct() < _attacker.getFatiguePct()) {
			spawnIcon("trait_icon_plus_08", getContainer().getActor().getTile());
			_properties.DamageReceivedTotalMult	*= (1.0 - (m.DamageReduction / 100.0));
		}
	}

	function onUpdate(_properties) {
		_properties.MovementFatigueCostAdditional	-= 1;
		_properties.FatigueRecoveryRate				+= 2;
	}
});
