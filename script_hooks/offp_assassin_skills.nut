/**
 * Note that these all use hookNewObject - that's because ActionPointCost is set in `create`,
 *  so we need an actually instantiated skill before we can get the proper ActionPointCost.
 *  Doing the usual ::mods_getMember(obj, "ActionPointCost") in a hookExactClass would get you
 *  a cost of 0. FatigueCostMult isn't typically modified in `create` and so is less prone to
 *  this, but I have all skills using the same hook for consistency.
 */
::mods_hookNewObject("skills/actives/bandage_ally_skill", function(bas) {
	local onAfterUpdate			= bas.onAfterUpdate;
	local origActionPointCost	= bas.m.ActionPointCost;
	local origFatigueCostMult	= bas.m.FatigueCostMult;

	/**
	 * A note here:
	 *	onAfterUpdate is run multiple times - seemingly twice (at least with a container)
	 *	This is why we can't just say e.g. m.ActionPointCost -= x;
	 */
	bas.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		if (getContainer().hasSkill("effects.assassin_speciality_05")) {
			m.ActionPointCost = origActionPointCost - 3;
			m.FatigueCostMult = origFatigueCostMult * 0.5;
		}
	}
});

::mods_hookNewObject("skills/actives/coat_with_poison_skill", function(cwps) {
	local onAfterUpdate			= cwps.onAfterUpdate;
	local origActionPointCost	= cwps.m.ActionPointCost;
	local origFatigueCostMult	= cwps.m.FatigueCostMult;

	cwps.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		if (getContainer().hasSkill("effects.assassin_speciality_05")) {
			m.ActionPointCost = origActionPointCost - 1;
			m.FatigueCostMult = origFatigueCostMult * 0.5;
		}
	}
});

::mods_hookNewObject("skills/actives/coat_with_spider_poison_skill", function(cwsps) {
	local onAfterUpdate			= cwsps.onAfterUpdate;
	local origActionPointCost	= cwsps.m.ActionPointCost;
	local origFatigueCostMult	= cwsps.m.FatigueCostMult;

	cwsps.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		if (getContainer().hasSkill("effects.assassin_speciality_05")) {
			m.ActionPointCost = origActionPointCost - 1;
			m.FatigueCostMult = origFatigueCostMult * 0.5;
		}
	}
});

::mods_hookNewObject("skills/actives/drink_antidote_skill", function(das) {
	local onAfterUpdate			= das.onAfterUpdate;
	local origFatigueCostMult	= das.m.FatigueCostMult;

	das.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		if (getContainer().hasSkill("effects.assassin_speciality_05"))
			m.FatigueCostMult = origFatigueCostMult * 0.5;
	}
});

::mods_hookNewObject("skills/actives/throw_acid_flask", function(taf) {
	local onAfterUpdate			= taf.onAfterUpdate;
	local origActionPointCost	= taf.m.ActionPointCost;
	local origFatigueCostMult	= taf.m.FatigueCostMult;

	taf.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		if (getContainer().hasSkill("effects.assassin_speciality_05")) {
			m.ActionPointCost = origActionPointCost - 2;
			m.FatigueCostMult = origFatigueCostMult * 0.5;
		}
	}
});

::mods_hookNewObject("skills/actives/throw_daze_bomb_skill", function(tdbs) {
	local onAfterUpdate			= tdbs.onAfterUpdate;
	local origActionPointCost	= tdbs.m.ActionPointCost;
	local origFatigueCostMult	= tdbs.m.FatigueCostMult;

	tdbs.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		if (getContainer().hasSkill("effects.assassin_speciality_05")) {
			m.ActionPointCost = origActionPointCost - 2;
			m.FatigueCostMult = origFatigueCostMult * 0.5;
		}
	}
});

::mods_hookNewObject("skills/actives/throw_fire_bomb_skill", function(tfbs) {
	local onAfterUpdate			= tfbs.onAfterUpdate;
	local origActionPointCost	= tfbs.m.ActionPointCost;
	local origFatigueCostMult	= tfbs.m.FatigueCostMult;

	tfbs.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		if (getContainer().hasSkill("effects.assassin_speciality_05")) {
			m.ActionPointCost = origActionPointCost - 2;
			m.FatigueCostMult = origFatigueCostMult * 0.5;
		}
	}
});

::mods_hookNewObject("skills/actives/throw_holy_water", function(thw) {
	local onAfterUpdate			= thw.onAfterUpdate;
	local origActionPointCost	= thw.m.ActionPointCost;
	local origFatigueCostMult	= thw.m.FatigueCostMult;

	thw.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		if (getContainer().hasSkill("effects.assassin_speciality_05")) {
			m.ActionPointCost = origActionPointCost - 2;
			m.FatigueCostMult = origFatigueCostMult * 0.5;
		}
	}
});

::mods_hookNewObject("skills/actives/throw_net", function(tn) {
	local onAfterUpdate			= tn.onAfterUpdate;
	local origActionPointCost	= tn.m.ActionPointCost;
	local origFatigueCostMult	= tn.m.FatigueCostMult;

	tn.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		if (getContainer().hasSkill("effects.assassin_speciality_05")) {
			m.ActionPointCost = origActionPointCost - 1;
			m.FatigueCostMult = origFatigueCostMult * 0.5;
		}
	}
});

::mods_hookNewObject("skills/actives/throw_smoke_bomb_skill", function(tsbs) {
	local onAfterUpdate			= tsbs.onAfterUpdate;
	local origActionPointCost	= tsbs.m.ActionPointCost;
	local origFatigueCostMult	= tsbs.m.FatigueCostMult;

	tsbs.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		if (getContainer().hasSkill("effects.assassin_speciality_05")) {
			m.ActionPointCost = origActionPointCost - 2;
			m.FatigueCostMult = origFatigueCostMult * 0.5;
		}
	}
});

::mods_hookNewObject("skills/actives/release_falcon_skill", function(rfs) {
	local onAfterUpdate			= rfs.onAfterUpdate;
	local origFatigueCostMult	= rfs.m.FatigueCostMult;

	rfs.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		if (getContainer().hasSkill("effects.assassin_speciality_05"))
			m.FatigueCostMult = origFatigueCostMult * 0.5;
	}
});

::mods_hookNewObject("skills/actives/unleash_wardog", function(uw) {
	local onAfterUpdate			= uw.onAfterUpdate;
	local origFatigueCostMult	= uw.m.FatigueCostMult;

	uw.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		if (getContainer().hasSkill("effects.assassin_speciality_05"))
			m.FatigueCostMult = origFatigueCostMult * 0.5;
	}
});

::mods_hookNewObject("skills/actives/unleash_wolf", function(uw) {
	local onAfterUpdate			= uw.onAfterUpdate;
	local origFatigueCostMult	= uw.m.FatigueCostMult;

	uw.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		if (getContainer().hasSkill("effects.assassin_speciality_05"))
			m.FatigueCostMult = origFatigueCostMult * 0.5;
	}
});

::mods_hookNewObject("skills/actives/adrenaline_skill", function(as) {
	local onAfterUpdate			= as.onAfterUpdate;
	local origFatigueCostMult	= as.m.FatigueCostMult;

	::mods_override(as, "onAfterUpdate", function(_properties) {
		onAfterUpdate(_properties);

		if (getContainer().hasSkill("trait.way_of_the_wolf"))
			m.FatigueCostMult = origFatigueCostMult * 0.6;
	});
});

::mods_hookExactClass("skills/effects/smoke_effect", function(se) {
	local onUpdate	= ::mods_getMember(se, "onUpdate");

	::mods_override(se, "onUpdate", function(_properties) {
		if (getContainer().hasSkill("trait.way_of_the_shadow")) {
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
