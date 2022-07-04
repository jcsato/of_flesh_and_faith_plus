assassin_spider_poison_effect <- inherit("scripts/skills/skill",
{

	m =
	{
		DamageMin			= 5
		DamageMax			= 10
		LastRoundApplied	= 0
		TurnsLeft			= 1
	}

	function create()
	{
		m.ID					= "effects.assassin_spider_poison";
		m.Name					= "Poisoned";
		m.KilledString			= "Died from poison";
		m.Icon					= "skills/status_effect_plus_23.png";
		m.IconMini				= "status_effect_plus_23_mini";
		m.SoundOnUse			= [ "sounds/combat/poison_applied_01.wav", "sounds/combat/poison_applied_02.wav" ];
		m.Type					= Const.SkillType.StatusEffect | Const.SkillType.DamageOverTime;
		m.IsActive				= false;
		m.IsStacking			= true;
		m.IsRemovedAfterBattle	= true;
	}

	function getDescription()
	{
		return "This character has a vicious poison running through his veins and will lose [color=" + Const.UI.Color.NegativeValue + "]" + m.DamageMin + "[/color] - [color=" + Const.UI.Color.NegativeValue + "]" + m.DamageMax + "[/color] hitpoints each turn for [color=" + Const.UI.Color.NegativeValue + "]" + m.TurnsLeft + "[/color] more turn(s).";
	}

	function resetTime()
	{
		m.TurnsLeft = 1;

		if(getContainer().hasSkill("trait.ailing"))
			++m.TurnsLeft;
	}

	function applyDamage()
	{
		if(m.LastRoundApplied != Time.getRound())
		{
			m.LastRoundApplied = Time.getRound();

			spawnIcon("status_effect_plus_23", getContainer().getActor().getTile());

			if(m.SoundOnUse.len() != 0)
			{
				Sound.play(m.SoundOnUse[Math.rand(0, m.SoundOnUse.len() - 1)], Const.Sound.Volume.RacialEffect * 1.0, getContainer().getActor().getPos());
			}

			local hitInfo = clone Const.Tactical.HitInfo;
			hitInfo.DamageRegular		= Math.rand(m.DamageMin, m.DamageMax);
			hitInfo.DamageDirect		= 1.0;
			hitInfo.BodyPart			= Const.BodyPart.Body;
			hitInfo.BodyDamageMult		= 1.0;
			hitInfo.FatalityChanceMult	= 0.0;

			getContainer().getActor().onDamageReceived(getContainer().getActor(), this, hitInfo);
		}
	}

	function onAdded()
	{
		m.TurnsLeft = 1;

		if(getContainer().hasSkill("trait.ailing"))
			++m.TurnsLeft;
	}

	function onTurnEnd()
	{
		applyDamage();

		if(--m.TurnsLeft <= 0)
		{
			removeSelf();
		}
	}

	function onWaitTurn()
	{
		applyDamage();
	}

})
