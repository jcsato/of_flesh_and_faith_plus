::mods_hookExactClass("scenarios/world/anatomists_scenario", function(as) {
	local onSpawnAssets = ::mods_getMember(as, "onSpawnAssets");
	local onActorKilled = ::mods_getMember(as, "onActorKilled");
	local onBattleWon = ::mods_getMember(as, "onBattleWon");
	local onCombatFinished = ::mods_getMember(as, "onCombatFinished");

	::mods_override(as, "onSpawnAssets", function() {
		onSpawnAssets();
		World.Statistics.getFlags().set("isConquererPotionAcquired", false);
	});

	::mods_override(as, "onActorKilled", function( _actor, _killer, _combatID ) {
		onActorKilled(_actor, _killer, _combatID);

		if (_actor.getType() == Const.EntityType.SkeletonBoss)
			World.Statistics.getFlags().set("shouldDropConquererPotion", true)
	});

	::mods_override(as, "onBattleWon", function(_combatLoot) {
		onBattleWon(_combatLoot);

		if(!World.Statistics.getFlags().get("isConquererPotionAcquired") && World.Statistics.getFlags().get("shouldDropConquererPotion")) {
			World.Statistics.getFlags().set("isConquererPotionAcquired", true);
			World.Statistics.getFlags().set("isConquererPotionDiscovered", true);
			_combatLoot.add(new("scripts/items/misc/anatomist/conquerer_potion_item"));
		}
	});

	::mods_override(as, "onCombatFinished", function() {
		World.Statistics.getFlags().set("shouldDropConquererPotion", false);
		return onCombatFinished();
	});
});

::mods_hookExactClass("items/misc/anatomist/research_notes_legendary_item", function(rnli) {
	local getTooltip = ::mods_getMember(rnli, "getTooltip");

	::mods_override(rnli, "getTooltip", function() {
		local ret = getTooltip();

		if (World.Statistics.getFlags().get("isConquererPotionDiscovered"))
			ret.push({ id = 15, type = "text", icon = "ui/icons/special.png", text = "Conquerer: Soul of the Fallen"});

		return ret;
	});
});
