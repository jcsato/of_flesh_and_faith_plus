rune_07_effect <- inherit("scripts/skills/skill", {
	m = {
		HitpointRegen	= 1
		FatigueRegen	= 5
		IsSpent			= false
	}

	function create() {
		m.ID					= "effects.rune_07";
		m.Name					= "Rune of the Berserker";
		m.Icon					= "skills/status_effect_plus_07.png";
		m.IconMini				= "status_effect_plus_07_mini";
		m.Overlay				= "status_effect_plus_07";
		m.SoundOnUse			= [ "sounds/combat/rage_01.wav", "sounds/combat/rage_02.wav" ];
		m.Type					= Const.SkillType.StatusEffect;
		m.Order					= Const.SkillOrder.Trait - 4;
		m.IsActive				= false;
		m.IsRemovedAfterBattle	= false;
		m.IsStacking			= false;
	}

	function getDescription() {
		return "\"Beware, mine chosen! The fang of the mad god is sharp indeed, but ever inward does it point. Do not think to outwit its master's machinations. Focus only on finding thine own death before they can take bloom.\"";
	}

	function getTooltip() {
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/health.png", text = "Recover [color=" + Const.UI.Color.PositiveValue + "]" + m.HitpointRegen + "[/color] Hitpoint per turn for each active rune" }
			{ id = 12, type = "text", icon = "ui/icons/special.png", text = "Once per turn, killing an opponent reduces current fatigue by [color=" + Const.UI.Color.NegativeValue + "]-" + m.FatigueRegen + "[/color]" }
			{ id = 13, type = "text", icon = "ui/icons/special.png", text = "The threshold to sustain injuries on getting hit is decreased by [color=" + Const.UI.Color.NegativeValue + "]-20%[/color]" }
		];

		return ret;
	}

	function onTargetKilled( _targetEntity, _skill ) {
		if (!m.IsSpent) {
			m.IsSpent = true;
			local actor = getContainer().getActor();
			actor.setFatigue(Math.max(0, actor.getFatigue() - m.FatigueRegen));
			actor.setDirty(true);
		}
	}

	function onTurnStart() {
		m.IsSpent = false;

		local actor = getContainer().getActor();

		local healAmount = actor.getFlags().getAsInt("numActiveRunes") * m.HitpointRegen;
		local healthMissing = actor.getHitpointsMax() - actor.getHitpoints();
		local healthAdded = Math.min(healthMissing, healAmount);

		if (healthAdded <= 0)
			return;

		actor.setHitpoints(actor.getHitpoints() + healthAdded);
		actor.setDirty(true);

		if (!actor.isHiddenToPlayer()) {
			Tactical.spawnIconEffect("status_effect_plus_07", actor.getTile(), Const.Tactical.Settings.SkillIconOffsetX, Const.Tactical.Settings.SkillIconOffsetY, Const.Tactical.Settings.SkillIconScale, Const.Tactical.Settings.SkillIconFadeInDuration, Const.Tactical.Settings.SkillIconStayDuration, Const.Tactical.Settings.SkillIconFadeOutDuration, Const.Tactical.Settings.SkillIconMovement);
			Sound.play("sounds/enemies/unhold_regenerate_01.wav", Const.Sound.Volume.RacialEffect * 1.25, actor.getPos());
			Tactical.EventLog.log(Const.UI.getColorizedEntityName(actor) + " heals for " + healthAdded + " points");
		}
	}

	function onUpdate( _properties ) {
		_properties.ThresholdToReceiveInjuryMult *= 0.8;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor ) {
		if (getContainer().getActor() != null && !getContainer().getActor().getSkills().hasSkill("effects.berserker_mushrooms"))
			Sound.play(m.SoundOnUse[Math.rand(0, m.SoundOnUse.len() - 1)], Const.Sound.Volume.Actor, getContainer().getActor().getPos(), Math.rand(100, 115) * 0.01 * getContainer().getActor().getSoundPitch());
	}

	function onTargetMissed( _skill, _targetEntity ) {
		if (getContainer().getActor() != null && !getContainer().getActor().getSkills().hasSkill("effects.berserker_mushrooms"))
			Sound.play(m.SoundOnUse[Math.rand(0, m.SoundOnUse.len() - 1)], Const.Sound.Volume.Actor, getContainer().getActor().getPos(), Math.rand(100, 115) * 0.01 * getContainer().getActor().getSoundPitch());
	}

	function onCombatFinished() {
		local actor = getContainer().getActor();

		if (actor != null && !actor.isNull() && actor.isAlive()) {
			actor.setHitpoints(actor.getHitpointsMax());
			actor.setDirty(true);
		}
	}
});
