assassin_poisoned_01_effect <- inherit("scripts/skills/skill", {
	m =
	{
		DamageMin			= 10
		DamageMax			= 15
		LastRoundApplied	= 0
		TurnsLeft			= 2
	}

	function create() {
		m.ID					= "effects.assassin_poisoned_01";
		m.Name					= "Holy Water";
		m.KilledString			= "Purified by holy water";
		m.Icon					= "skills/status_effect_plus_18.png";
		m.IconMini				= "status_effect_plus_18_mini";
		m.SoundOnUse			= [ "sounds/combat/poison_applied_01.wav", "sounds/combat/poison_applied_02.wav" ];
		m.Type					= Const.SkillType.StatusEffect | Const.SkillType.DamageOverTime;
		m.IsActive				= false;
		m.IsStacking			= true;
		m.IsRemovedAfterBattle	= true;
	}

	function getDescription() {
		return "This character has been sprayed with holy water and will lose [color=" + Const.UI.Color.NegativeValue + "]" + m.DamageMin + "-" + m.DamageMax + "[/color] hitpoints each turn for [color=" + Const.UI.Color.NegativeValue + "]" + m.TurnsLeft + "[/color] more turn(s).";
	}

	function resetTime() {
		m.TurnsLeft = 1;

		if(getContainer().hasSkill("trait.ailing"))
			++m.TurnsLeft;
	}

	function getDamage() {
		// This function is used by AI to determine how risky it should act
		//   e.g. "if I'm about to die anyway, why would I shieldwall?"
		//   so returning the maximum possible damage here is appropriate
		return m.DamageMax;
	}

	function applyDamage() {
		if (!getContainer().getActor().getFlags().has("undead"))
			return;

		if (m.LastRoundApplied != Time.getRound()) {
			m.LastRoundApplied = Time.getRound();

			spawnIcon("status_effect_plus_18", getContainer().getActor().getTile());

			if(m.SoundOnUse.len() != 0)
				Sound.play(m.SoundOnUse[Math.rand(0, m.SoundOnUse.len() - 1)], Const.Sound.Volume.RacialEffect * 1.0, getContainer().getActor().getPos());

			local hitInfo = clone Const.Tactical.HitInfo;
			hitInfo.DamageRegular		= Math.rand(m.DamageMin, m.DamageMax);
			hitInfo.DamageDirect		= 1.0;
			hitInfo.BodyPart			= Const.BodyPart.Body;
			hitInfo.BodyDamageMult		= 1.0;
			hitInfo.FatalityChanceMult	= 0.0;

			getContainer().getActor().onDamageReceived(getContainer().getActor(), this, hitInfo);
		}
	}

	function onAdded() {
		m.TurnsLeft = 2;

		if(getContainer().hasSkill("trait.ailing"))
			++m.TurnsLeft;
	}

	function onTurnEnd() {
		applyDamage();

		if(--m.TurnsLeft <= 0)
			removeSelf();
	}

	function onWaitTurn() {
		applyDamage();
	}
})
