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
