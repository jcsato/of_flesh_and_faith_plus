::mods_hookNewObject("skills/actives/bandage_ally_skill", function(bas) {
	local onAfterUpdate		= bas.onAfterUpdate;
	local originalAPCost	= bas.m.ActionPointCost;

	bas.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		/**
		 * A note here:
		 *	onAfterUpdate is run multiple times - seemingly twice (at least with a container)
		 *	This is why we can't just say m.ActionPointCost -= 1; all our AP will be reduced
		 *  by 2 instead of 1. Curiously, FatigueCostMult seems to be updated separately on
		 *  the last call. This is why we don't bother just checking if we've already applied
		 *  the -AP and early exiting; we *want* it to run multiple times to pick up the
		 *  update to m.FatigueCostMult.
		 */
		if (getContainer().getActor().getSkills().hasSkill("effects.assassin_speciality_05")) {
			m.ActionPointCost = originalAPCost - 1;
			m.FatigueCostMult *= 0.5;
		}
	}
});

::mods_hookNewObject("skills/actives/coat_with_poison_skill", function(cwps) {
	local onAfterUpdate		= cwps.onAfterUpdate;
	local originalAPCost	= cwps.m.ActionPointCost;

	cwps.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		if (getContainer().getActor().getSkills().hasSkill("effects.assassin_speciality_05")) {
			m.ActionPointCost = originalAPCost - 1;
			m.FatigueCostMult *= 0.5;
		}
	}
});

::mods_hookNewObject("skills/actives/coat_with_spider_poison_skill", function(cwsps) {
	local onAfterUpdate		= cwsps.onAfterUpdate;
	local originalAPCost	= cwsps.m.ActionPointCost;

	cwsps.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		if (getContainer().getActor().getSkills().hasSkill("effects.assassin_speciality_05")) {
			m.ActionPointCost = originalAPCost - 1;
			m.FatigueCostMult *= 0.5;
		}
	}
});

::mods_hookNewObject("skills/actives/drink_antidote_skill", function(das) {
	local onAfterUpdate		= das.onAfterUpdate;
	local originalAPCost	= das.m.ActionPointCost;

	das.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		if (getContainer().getActor().getSkills().hasSkill("effects.assassin_speciality_05")) {
			m.ActionPointCost = originalAPCost - 1;
			m.FatigueCostMult *= 0.5;
		}
	}
});

::mods_hookNewObject("skills/actives/throw_acid_flask", function(taf) {
	local onAfterUpdate		= taf.onAfterUpdate;
	local originalAPCost	= taf.m.ActionPointCost;

	taf.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		if (getContainer().getActor().getSkills().hasSkill("effects.assassin_speciality_05")) {
			m.ActionPointCost = originalAPCost - 1;
			m.FatigueCostMult *= 0.5;
		}
	}
});

::mods_hookNewObject("skills/actives/throw_daze_bomb_skill", function(tdbs) {
	local onAfterUpdate		= tdbs.onAfterUpdate;
	local originalAPCost	= tdbs.m.ActionPointCost;

	tdbs.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		if (getContainer().getActor().getSkills().hasSkill("effects.assassin_speciality_05")) {
			m.ActionPointCost = originalAPCost - 1;
			m.FatigueCostMult *= 0.5;
		}
	}
});

::mods_hookNewObject("skills/actives/throw_fire_bomb_skill", function(tfbs) {
	local onAfterUpdate		= tfbs.onAfterUpdate;
	local originalAPCost	= tfbs.m.ActionPointCost;

	tfbs.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		if (getContainer().getActor().getSkills().hasSkill("effects.assassin_speciality_05")) {
			m.ActionPointCost = originalAPCost - 1;
			m.FatigueCostMult *= 0.5;
		}
	}
});

::mods_hookNewObject("skills/actives/throw_holy_water", function(thw) {
	local onAfterUpdate		= thw.onAfterUpdate;
	local originalAPCost	= thw.m.ActionPointCost;

	thw.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		if (getContainer().getActor().getSkills().hasSkill("effects.assassin_speciality_05")) {
			m.ActionPointCost = originalAPCost - 1;
			m.FatigueCostMult *= 0.5;
		}
	}
});

::mods_hookNewObject("skills/actives/throw_net", function(tn) {
	local onAfterUpdate		= tn.onAfterUpdate;
	local originalAPCost	= tn.m.ActionPointCost;

	tn.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		if (getContainer().getActor().getSkills().hasSkill("effects.assassin_speciality_05")) {
			m.ActionPointCost = originalAPCost - 1;
			m.FatigueCostMult *= 0.5;
		}
	}
});

::mods_hookNewObject("skills/actives/throw_smoke_bomb_skill", function(tsbs) {
	local onAfterUpdate		= tsbs.onAfterUpdate;
	local originalAPCost	= tsbs.m.ActionPointCost;

	tsbs.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		if (getContainer().getActor().getSkills().hasSkill("effects.assassin_speciality_05")) {
			m.ActionPointCost = originalAPCost - 1;
			m.FatigueCostMult *= 0.5;
		}
	}
});

::mods_hookNewObject("skills/actives/release_falcon_skill", function(rfs) {
	local onAfterUpdate		= rfs.onAfterUpdate;
	local originalAPCost	= rfs.m.ActionPointCost;

	rfs.onAfterUpdate = function (_properties) {
		onAfterUpdate(_properties);

		if (getContainer().getActor().getSkills().hasSkill("effects.assassin_speciality_05")) {
			m.ActionPointCost = originalAPCost - 1;
			m.FatigueCostMult *= 0.5;
		}
	}
});

::mods_hookExactClass("skills/actives/adrenaline_skill", function(as) {
	local onAfterUpdate = ::mods_getMember(as, "onAfterUpdate");

	/**
	 * For whatever reason, the above note doesn't seem to apply here: no matter what, m.FatigueCostMult
	 *  seems to get adjusted twice - I suspect this has to do with it coming from a perk, rather than a
	 *  piece of equipment. A concession had to be made here, although I suspect if other mods wanted to
	 *  change the same thing they could by loading after this and manually adjusting their own checks.
	 */
	::mods_override(as, "onAfterUpdate", function(_properties) {
		onAfterUpdate(_properties);

		if (getContainer().getActor().getSkills().hasSkill("trait.way_of_the_wolf"))
			m.FatigueCostMult = Math.maxf(m.FatigueCostMult * 0.6, 0.6);
	});
});
