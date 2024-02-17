rot_05_trait <- inherit("scripts/skills/traits/character_trait", {
	m = {
		SkillCount		= 0
		LastTargetID	= 0
	}

	function create() {
		character_trait.create();

		m.ID			= "trait.rot_05";
		m.Name			= "Nerverot";
		m.Icon			= "ui/traits/trait_icon_plus_05.png";
		m.Description	= "The Rot has spread to this character's nerves. Jolts of pain shoot through their limbs at random, making it difficult to react with speed and surety.";

		m.Order			= Const.SkillOrder.Trait - 1;

		m.Excluded = [];
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/special.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-8%[/color] Chance to Hit per Rot for the next 2 attacks after landing a hit" }
		];

		return ret;
	}

	function onTargetHit(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor) {
		if (Tactical.TurnSequenceBar.getActiveEntity() == null || Tactical.TurnSequenceBar.getActiveEntity().getID() != getContainer().getActor().getID())
			return;

		if (m.SkillCount == Const.SkillCounter && m.LastTargetID == _targetEntity.getID())
			return;

		m.SkillCount = Const.SkillCounter;
		m.LastTargetID = _targetEntity.getID();

		local tag = {
			Actor = getContainer().getActor()
			Skill = this
		}

		Time.scheduleEvent(TimeUnit.Virtual, 400, onTargedHitCallback, tag);
	}

	function onTargedHitCallback(_tag) {
		local skills = _tag.Actor.getSkills();

		if (skills.hasSkill("effects.nerverot")) {
			local skill = skills.getSkillByID("effects.nerverot");

			skill.onRefresh();
			_tag.Actor.setDirty(true);
		} else {
			local numRots = 0;

			foreach (trait in ::OFFP.Explorers.RotTraits) {
				if (skills.hasSkill(trait))
					numRots++;
			};

			local skill = new("scripts/skills/effects/nerverot_effect");

			skill.setMagnitude(numRots)
			skills.add(skill);
			_tag.Skill.spawnIcon("status_effect_plus_42", _tag.Actor.getTile());
			_tag.Actor.setDirty(true);
		}
	}

	function onCombatStarted() {
		m.SkillCount = 0;
		m.LastTargetID = 0;
	}

	function onCombatFinished() {
		skill.onCombatFinished();

		m.SkillCount = 0;
		m.LastTargetID = 0;
	}
});
