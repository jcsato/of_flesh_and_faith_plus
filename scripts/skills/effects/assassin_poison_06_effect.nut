assassin_poison_06_effect <- inherit("scripts/skills/skill", {
	m = {
		TargetTile = null
	}

	function create() {
		m.ID			= "effects.assassin_poison_06";
		m.Name			= "Dragon Spit";
		m.Description	= "A dull powder, stored in a special horn, has been worked into the surfaces of this character's weapons. Upon contact with blood, it ignites, quickly immolating the unfortunate target.";
		m.Icon			= "skills/status_effect_plus_50.png";
		m.IconMini		= "";
		m.Type			= Const.SkillType.StatusEffect | Const.SkillType.Perk;
		m.Order			= Const.SkillOrder.Any - 3;
		m.SoundOnUse	= [ "sounds/combat/poison_applied_01.wav", "sounds/combat/poison_applied_02.wav" ];
	}

	function getTooltip() {
		local threshold = ::OFFP.Helpers.getPoisonHitpointThreshold(getContainer().getActor());
		local thresholdString = threshold > 0 ? "does at least [color=" + Const.UI.Color.NegativeValue + "]" + threshold + "[/color] damage to hitpoints, or hits a target that is already bleeding," : "hits"
		local ret = [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/special.png", text = "Every weapon attack that " + thresholdString + " sets the target's tile ablaze for 1 turn" }
			{ id = 13, type = "hint", icon = "ui/icons/special.png", text = "Unlocks the next row of perks" }
		];

		return ret;
	}

	// Sad state of affairs. So onTargetHit is called in onScheduledTargetHit, after onDamageReceived. onDamageReceived
	// (can) call actor.kill, which calls die() or removeFromMap(), both defined in the engine code. These methods put
	// the actor's tile into some kind of invalid state where calling `getTile().Type` will crash the game (the crash
	// occurs in the engine code). So instead, we store the tile in onBeforeTargetHit, which is also called in
	// onScheduledTargetHit but before onDamageReceived, when it's still in a valid state. Then we can re-use it later.
	// Note that onBeforeTargetHit isn't called by certain skills that call onTargetHit directly (hook, repel,
	// split shield, knock back), but those skills logically wouldn't cause bleeds anyway so we can ignore them
	function onBeforeTargetHit(_caller, _targetEntity, _hitInfo) {
		m.TargetTile = _targetEntity.getTile();
	}

	function onTargetHit(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor) {
		// e.g. hook, repel, etc. - skip the below checks so they don't log
		if (_skill != null && ::OFFP.Assassins.PoisonExcludedSkills.find(_skill.getID()) != null)
			return;

		if (_targetEntity.getCurrentProperties().IsImmuneToBleeding || _targetEntity.getCurrentProperties().IsImmuneToFire)
			return;

		// Do spawn fire if < threshold but target died (so only return early if we shouldn't apply and target is still alive)
		if (_damageInflictedHitpoints < ::OFFP.Helpers.getPoisonHitpointThreshold(getContainer().getActor()) && !_targetEntity.getSkills().hasSkill("effects.bleeding") && _targetEntity.getHitpoints() > 0)
			return;

		// Don't re-trigger if the target is already on fire, both for balance and annoyance
		// onBeforeTargetHit isn't called by hook, knock back, split shield, or repel (so m.TargetTile won't be set)
		// but none of those should trigger fire anyway
		if (m.TargetTile != null && m.TargetTile.Properties.Effect != null && m.TargetTile.Properties.Effect.Type == "fire")
			return;

		if (!_targetEntity.isHiddenToPlayer())
			Tactical.EventLog.log(Const.UI.getColorizedEntityName(_targetEntity) + " is set ablaze!");

		if (m.TargetTile != null) {
			// Don't immediately trigger damage, for balance and annoyance reasons, if the target is already on fire
			// Do still call spawnFireOnTile to refresh timeouts, however
			local applyImmediately = !(m.TargetTile.Properties.Effect != null && m.TargetTile.Properties.Effect.Type == "fire");
			Tactical.State.spawnFireOnTile(m.TargetTile, getContainer().getActor().isPlayerControlled(), applyImmediately);
		}

		m.TargetTile = null;
	}
});
