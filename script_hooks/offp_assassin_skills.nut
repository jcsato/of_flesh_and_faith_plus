::mods_hookExactClass("skills/effects/smoke_effect", function(se) {
	local onUpdate	= ::mods_getMember(se, "onUpdate");

	::mods_override(se, "onUpdate", function(_properties) {
		if (getContainer().hasSkill("effects.way_of_the_shadow")) {
			local tile = getContainer().getActor().getTile();

			if(tile.Properties.Effect == null || tile.Properties.Effect.Type != "smoke")
				removeSelf();
			else
				_properties.RangedDefenseMult	*= 2.0;
		} else {
			onUpdate(_properties);
		}
	});
});

::mods_hookExactClass("items/misc/potion_of_oblivion_item", function(pooi) {
	local onUse = ::mods_getMember(pooi, "onUse");

	::mods_override(pooi, "onUse", function(_actor, _item = null) {
		local level = _actor.getLevel();

		local result = onUse(_actor, _item);

		if (("State" in World) && World.State != null && World.Assets.getOrigin() != null && World.Assets.getOrigin().getID() == "scenario.southern_assassins")
			World.Assets.getOrigin().onHired(_actor);

		return result;
	});
});

::mods_hookExactClass("skills/effects/poison_coat_effect", function(pce) {
	local getDescription = ::mods_getMember(pce, "getDescription");
	local onTargetHit = ::mods_getMember(pce, "onTargetHit");

	::mods_override(pce, "getDescription", function() {
		local oldDescription = getDescription();

		local threshold = ::OFFP.Helpers.getPoisonHitpointThreshold(getContainer().getActor());
		local startString = "doing at least [color=";
		local startIndex = oldDescription.find(startString);
		local length = ("doing at least [color=#8f1e1e]" + Const.Combat.PoisonEffectMinDamage + "[/color] damage to hitpoints").len();
		local resumeString = "[/color] damage to hitpoints";
		local resumeIndex = oldDescription.find(resumeString);

		local thresholdString = threshold > 0 ? (oldDescription.slice(startIndex, startString.len()) + Const.UI.Color.NegativeValue + threshold + resumeString) : "";
		return oldDescription.slice(0, startIndex) + thresholdString + oldDescription.slice(resumeIndex + resumeString.len());
	});

	::mods_override(pce, "onTargetHit", function(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor) {
		local originalMinDamage = Const.Combat.PoisonEffectMinDamage;

		Const.Combat.PoisonEffectMinDamage = ::OFFP.Helpers.getPoisonHitpointThreshold(getContainer().getActor(), _targetEntity);
		onTargetHit(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
		Const.Combat.PoisonEffectMinDamage = originalMinDamage;
	});
});

::mods_hookExactClass("skills/effects/spider_poison_coat_effect", function(spce) {
	local getDescription = ::mods_getMember(spce, "getDescription");
	local onTargetHit = ::mods_getMember(spce, "onTargetHit");

	::mods_override(spce, "getDescription", function() {
		local oldDescription = getDescription();

		local threshold = ::OFFP.Helpers.getPoisonHitpointThreshold(getContainer().getActor());
		local startString = "doing at least [color=";
		local startIndex = oldDescription.find(startString);
		local length = ("doing at least [color=#8f1e1e]" + Const.Combat.PoisonEffectMinDamage + "[/color] damage to hitpoints").len();
		local resumeString = "[/color] damage to hitpoints";
		local resumeIndex = oldDescription.find(resumeString);

		local thresholdString = threshold > 0 ? (oldDescription.slice(startIndex, startString.len()) + Const.UI.Color.NegativeValue + threshold + resumeString) : "";
		return oldDescription.slice(0, startIndex) + thresholdString + oldDescription.slice(resumeIndex + resumeString.len());
	});

	::mods_override(spce, "onTargetHit", function(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor) {
		local originalMinDamage = Const.Combat.PoisonEffectMinDamage;

		Const.Combat.PoisonEffectMinDamage = ::OFFP.Helpers.getPoisonHitpointThreshold(getContainer().getActor(), _targetEntity);
		onTargetHit(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
		Const.Combat.PoisonEffectMinDamage = originalMinDamage;
	});
});
