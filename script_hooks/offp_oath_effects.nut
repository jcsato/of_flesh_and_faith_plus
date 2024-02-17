::mods_hookExactClass("skills/actives/recover_skill", function(rs) {
	local getTooltip = ::mods_getMember(rs, "getTooltip");
	local onUse = ::mods_getMember(rs, "onUse");

	::mods_override(rs, "getTooltip", function() {
		local ret = getTooltip();

		if (getContainer().getActor().getSkills().hasSkill("effects.oath_of_endurance_completed")) {
			ret.pop();
			ret.push({ id = 7, type = "text", icon = "ui/icons/special.png", text = "Current Fatigue is reduced by [color=" + Const.UI.Color.PositiveValue + "]66%[/color]" });
		}

		return ret;
	});

	::mods_override(rs, "onUse", function(_user, _targetTile) {
		if (_user.getSkills().hasSkill("effects.oath_of_endurance_completed")) {
			_user.setFatigue(_user.getFatigue() / 3);

			if (!_user.isHiddenToPlayer())
				_user.playSound(Const.Sound.ActorEvent.Fatigue, Const.Sound.Volume.Actor * _user.getSoundVolume(Const.Sound.ActorEvent.Fatigue));

			return true;
		} else {
			onUse(_user, _targetTile);
		}
	});
});

::mods_hookExactClass("skills/actives/knock_back", function(kb) {
	local getTooltip = ::mods_getMember(kb, "getTooltip");
	local onUse = ::mods_getMember(kb, "onUse");

	::mods_override(kb, "getTooltip", function() {
		local ret = getTooltip();

		if (getContainer().getActor().getSkills().hasSkill("effects.oath_of_fortification_completed"))
			ret.push({ id = 7, type = "text", icon = "ui/icons/special.png", text = "Has a [color=" + Const.UI.Color.PositiveValue + "]" + ::OFFP.Oathtakers.Boons.FortificationStunChance + "%[/color] chance to stun on a hit" });

		return ret;
	});

	::mods_override(kb, "onUse", function(_user, _targetTile) {
		local use = onUse(_user, _targetTile);

		if (use && _user.getSkills().hasSkill("effects.oath_of_fortification_completed")) {
			local targetEntity = _targetTile.getEntity();

			if ((Math.rand(1, 100) <= ::OFFP.Oathtakers.Boons.FortificationStunChance) && !targetEntity.getCurrentProperties().IsImmuneToStun && !targetEntity.getSkills().hasSkill("effects.stunned")) {
				targetEntity.getSkills().add(new("scripts/skills/effects/stunned_effect"));

				if(!_user.isHiddenToPlayer() && targetEntity.getTile().IsVisibleForPlayer)
					Tactical.EventLog.log(Const.UI.getColorizedEntityName(_user) + " has stunned " + Const.UI.getColorizedEntityName(targetEntity) + " for one turn");
			}
		}
	});
});

::mods_hookExactClass("entity/tactical/player", function(p) {
	local getHiringCost = ::mods_getMember(p, "getHiringCost");
	local setMoraleState = ::mods_getMember(p, "setMoraleState");
	local checkMorale = ::mods_getMember(p, "checkMorale");
	local addInjury = ::mods_getMember(p, "addInjury");
	local addXP = ::mods_getMember(p, "addXP");

	// Note that modifying only getHiringCost doesn't modify Tryout prices - this is intentional
	::mods_override(p, "getHiringCost", function() {
		local hiringCost = getHiringCost();

		if (getBackground().getID() == "background.paladin") {
			local brothers = World.getPlayerRoster().getAll();
			local numTithers = 0;

			foreach (bro in brothers) {
				if (bro.getSkills().hasSkill("effects.oath_of_tithing_completed"))
					numTithers++;
			}

			// If the Oathtaker is somehow already hireable for less than 1000, don't raise their cost
			if (hiringCost < ::OFFP.Oathtakers.Boons.TithingRecruitMinimum)
				return hiringCost;

			return Math.max(hiringCost - 1000 * numTithers, ::OFFP.Oathtakers.Boons.TithingRecruitMinimum);
		}

		return hiringCost;
	});

	::mods_override(p, "setMoraleState", function(_m) {
		if (_m == Const.MoraleState.Confident && m.Skills.hasSkill("effects.oath_of_valor_active"))
			return;

		if(_m == Const.MoraleState.Fleeing && m.Skills.hasSkill("effects.oath_of_valor_completed"))
			return;

		if ((_m == Const.MoraleState.Confident || _m == Const.MoraleState.Steady) && m.Skills.hasSkill("effects.oath_of_redemption_active"))
			return;

		setMoraleState(_m);
	});

	::mods_override(p, "checkMorale", function(_change, _difficulty, _type = Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false) {
		if (_change < 0 && m.MoraleState == Const.MoraleState.Breaking && m.Skills.hasSkill("effects.oath_of_valor_completed"))
			return false;

		if (_change > 0 && m.MoraleState == Const.MoraleState.Steady && m.Skills.hasSkill("effects.oath_of_valor_active"))
			return false;

		if (_change > 0 && m.MoraleState == Const.MoraleState.Wavering && m.Skills.hasSkill("effects.oath_of_redemption_active"))
			return false;

		return checkMorale(_change, _difficulty, _type, _showIconBeforeMoraleIcon, _noNewLine);
	});

	::mods_override(p, "addInjury", function(_injuries, _maxThreshold = 1.0, _isOutOfCombat = true) {
		local injury = addInjury(_injuries, _maxThreshold, _isOutOfCombat);

		if (injury != null && m.Skills.hasSkill("effects.oath_of_sacrifice_active"))
			getFlags().increment(::OFFP.Oathtakers.Flags.Sacrifice);

		return injury;
	});

	::mods_override(p, "addXP", function(_xp, _scale = true) {
		local previousXP = m.XP;

		addXP(_xp, _scale);

		if (m.Skills.hasSkill("effects.oath_of_proving_active"))
			getFlags().increment(::OFFP.Oathtakers.Flags.Proving, (m.XP - previousXP));
	});
});

::mods_hookExactClass("skills/backgrounds/paladin_background", function(bg) {
	local onUpdate = ::mods_getMember(bg, "onUpdate");

	::mods_override(bg, "onUpdate", function(_properties) {
		onUpdate(_properties);

		local brothers = World.getPlayerRoster().getAll();
		local wageTitheMult = 1.0;

		foreach (bro in brothers) {
			if (bro.getSkills().hasSkill("effects.oath_of_tithing_completed"))
				wageTitheMult *= 0.9;
		}

		_properties.DailyWageMult *= wageTitheMult;
	});
});

::mods_hookBaseClass("skills/skill", function(s) {
	while (!("isUsable" in s)) s = s[s.SuperName];
	local isUsable = s.isUsable;

	s.isUsable = function() {
		local usable = isUsable();

		return usable && !(m.Container.getActor().getSkills().hasSkill("effects.oath_of_honor_active") && ((m.IsWeaponSkill && m.IsRanged) || (m.IsOffensiveToolSkill)));
	}

	while (!("getDefaultTooltip" in s)) s = s[s.SuperName];
	local getDefaultTooltip = s.getDefaultTooltip;

	s.getDefaultTooltip = function() {
		local ret = getDefaultTooltip();

		if (m.Container.getActor().getSkills().hasSkill("effects.oath_of_honor_active") && ((m.IsWeaponSkill && m.IsRanged) || (m.IsOffensiveToolSkill)))
			ret.push( { id = 9, type = "hint", icon = "ui/tooltips/warning.png", text = "[color=" + Const.UI.Color.NegativeValue + "]Can not be used because this character has taken an oath precluding the use of ranged weapons or tools[/color]" } );

		return ret;
	}

	while (!("getDefaultUtilityTooltip" in s)) s = s[s.SuperName];
	local getDefaultUtilityTooltip = s.getDefaultUtilityTooltip;

	s.getDefaultUtilityTooltip = function() {
		local ret = getDefaultUtilityTooltip();

		if (m.Container.getActor().getSkills().hasSkill("effects.oath_of_honor_active") && ((m.IsWeaponSkill && m.IsRanged) || (m.IsOffensiveToolSkill)))
			ret.push( { id = 9, type = "hint", icon = "ui/tooltips/warning.png", text = "[color=" + Const.UI.Color.NegativeValue + "]Can not be used because this character has taken an oath precluding the use of ranged weapons or tools[/color]" } );

		return ret;
	}
});

::mods_hookExactClass("skills/special/oath_of_honor_warning", function(oohw) {
	local isHidden = ::mods_getMember(oohw, "isHidden");

	::mods_override(oohw, "isHidden", function() {
		local hidden = isHidden();

		local actor = getContainer().getActor();
		if (actor.getSkills().hasSkill("effects.oath_of_honor_active")) {
			local item = actor.getItems().getItemAtSlot(Const.ItemSlot.Mainhand);
			if (item != null && (item.isItemType(Const.Items.ItemType.RangedWeapon) || item.isItemType(Const.Items.ItemType.Tool)))
				hidden = false;

			item = actor.getItems().getItemAtSlot(Const.ItemSlot.Offhand);
			if (item != null && (item.isItemType(Const.Items.ItemType.RangedWeapon) || item.isItemType(Const.Items.ItemType.Tool)))
				hidden = false;
		}

		return hidden;
	});
});

::mods_hookClass("states/tactical_state", function(ts) {
	local gatherLoot = ts.gatherLoot;
	local onBattleEnded = ts.onBattleEnded;

	// Unfortunately, we can't just use scenarion.onBattleWon because that runs
	//  before m.CombatResultLoot is populated.
	ts.gatherLoot = function() {
		gatherLoot();

		local crownsMult = 1.0
		local totalDifference = 0;
		local items = m.CombatResultLoot.getItems();
		local brothers = World.getPlayerRoster().getAll();

		foreach (bro in brothers) {
			if (bro.getSkills().hasSkill("effects.oath_of_tithing_active") && bro.getFlags().getAsInt(::OFFP.Oathtakers.Flags.Tithing) < ::OFFP.Oathtakers.Quests.TithingCrownsLevied)
				crownsMult *= 0.9;
		}

		// To better allow other mods to hook into oath_of_tithing_active, this
		//  isn't gated on origin ID. The `crownsMult` check is just there to
		//  prevent wasted effort looping through items - it's benign if run
		//  with crownsMult == 1.0
		if (crownsMult != 1.0) {
			foreach (item in items) {
				if (item != null && item.getID() == "supplies.money") {
					local difference = item.getValue() - Math.floor(item.getValue() * crownsMult);
					item.setAmount(item.getValue() - difference);
					totalDifference += difference;
				}
			}
		}

		foreach (bro in brothers) {
			if (bro.getSkills().hasSkill("effects.oath_of_tithing_active") && bro.getFlags().getAsInt(::OFFP.Oathtakers.Flags.Tithing) < ::OFFP.Oathtakers.Quests.TithingCrownsLevied)
				bro.getFlags().increment(::OFFP.Oathtakers.Flags.Tithing, totalDifference);
		}
	}

	// This *could* also be done in location.onCombatLost and check the location faction against the quest factions.
	ts.onBattleEnded = function() {
		if (World.Assets.getOrigin() != null && World.Assets.getOrigin().getID() == "scenario.oathtakers") {
			local isVictory = Tactical.Entities.getCombatResult() == Const.Tactical.CombatResult.EnemyDestroyed || Tactical.Entities.getCombatResult() == Const.Tactical.CombatResult.EnemyRetreated;
			if (isVictory && !isScenarioMode() && m.StrategicProperties != null && m.StrategicProperties.IsAttackingLocation) {
				local locationFaction = World.Statistics.getFlags().getAsInt("LastCombatFaction");

				if (locationFaction == World.FactionManager.getFactionOfType(Const.FactionType.Bandits).getID() ||
					locationFaction == World.FactionManager.getFactionOfType(Const.FactionType.Barbarians).getID() ||
					locationFaction == World.FactionManager.getFactionOfType(Const.FactionType.OrientalBandits).getID())
				{
					local brothers = World.getPlayerRoster().getAll();

					foreach (bro in brothers) {
						if (bro.getSkills().hasSkill("effects.oath_of_wrath_active"))
							bro.getFlags().increment(::OFFP.Oathtakers.Flags.WrathLocations);
					}
				}
			}
		}

		onBattleEnded();
	}
});
