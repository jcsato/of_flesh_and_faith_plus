::OFFP.Helpers <- {
	getIconForOath = function(oathID) {
		local icon = "";

		switch (oathID) {
			case "effects.oath_of_distinction_active":
				icon = "ui/traits/trait_icon_88.png";
				break;

			case "effects.oath_of_dominion_active":
				icon = "ui/traits/trait_icon_79.png";
				break;

			case "effects.oath_of_endurance_active":
				icon = "ui/traits/trait_icon_84.png";
				break;

			case "effects.oath_of_fortification_active":
				icon = "ui/traits/trait_icon_86.png";
				break;

			case "effects.oath_of_honor_active":
				icon = "ui/traits/trait_icon_82.png";
				break;

			case "effects.oath_of_tithing_active":
				icon = "ui/traits/trait_icon_81.png";
				break;

			case "effects.oath_of_loyalty_active":
				icon = "ui/traits/trait_icon_85.png";
				break;

			case "effects.oath_of_proving_active":
				icon = "skills/status_effect_plus_38.png";
				break;

			case "effects.oath_of_righteousness_active":
				icon = "ui/traits/trait_icon_78.png";
				break;

			case "effects.oath_of_sacrifice_active":
				icon = "ui/traits/trait_icon_87.png";
				break;

			case "effects.oath_of_valor_active":
				icon = "ui/traits/trait_icon_83.png";
				break;

			case "effects.oath_of_vengeance_active":
				icon = "ui/traits/trait_icon_77.png";
				break;

			case "effects.oath_of_wrath_active":
				icon = "ui/traits/trait_icon_80.png";
				break;

			case "effects.oath_of_redemption_active":
				icon = "skills/status_effect_plus_40.png";
				break;

			case "effects.oath_of_distinction_completed":
				icon = "skills/status_effect_plus_27.png";
				break;

			case "effects.oath_of_dominion_completed":
				icon = "skills/status_effect_plus_28.png";
				break;

			case "effects.oath_of_endurance_completed":
				icon = "skills/status_effect_plus_29.png";
				break;

			case "effects.oath_of_fortification_completed":
				icon = "skills/status_effect_plus_30.png";
				break;

			case "effects.oath_of_honor_completed":
				icon = "skills/status_effect_plus_31.png";
				break;

			case "effects.oath_of_tithing_completed":
				icon = "skills/status_effect_plus_32.png";
				break;

			case "effects.oath_of_loyalty_completed":
				icon = "skills/status_effect_plus_26.png";
				break;

			case "effects.oath_of_proving_completed":
				icon = "skills/status_effect_plus_39.png";
				break;

			case "effects.oath_of_righteousness_completed":
				icon = "skills/status_effect_plus_33.png";
				break;

			case "effects.oath_of_sacrifice_completed":
				icon = "skills/status_effect_plus_34.png";
				break;

			case "effects.oath_of_valor_completed":
				icon = "skills/status_effect_plus_35.png";
				break;

			case "effects.oath_of_vengeance_completed":
				icon = "skills/status_effect_plus_36.png";
				break;

			case "effects.oath_of_wrath_completed":
				icon = "skills/status_effect_plus_37.png";
				break;

			case "effects.oath_of_redemption_completed":
				icon = "skills/status_effect_plus_41.png";
				break;
		}

		return icon;
	}
	getProperNameForOath = function(oathName) {
		local oathAsArray = split(oathName, "_")
		// apply() modifies in place vs map(), which returns a new array (apparently). Also Squirrel has lambdas, who knew
		return oathAsArray.map(@(word) word.slice(0, 1).toupper() + word.slice(1)).reduce(@(word1, word2) word1 + " " + word2);
	}
	oathIDToName = function(oathID) {
		local oathName = "";
		local completed = false;

		if (oathID.find("_completed") != null)
			completed = true;

		oathName = split(oathID, '.')[1];

		if (completed)
			return oathName.slice(0, oathName.len() - 10);
		else
			return oathName.slice(0, oathName.len() - 7);
	}
	oathNameToActiveID = function(oathName) {
		return "effects." + oathName + "_active";
	}
	oathNameToCompletedID = function(oathName) {
		return "effects." + oathName + "_completed";
	}
	oathReadyToComplete = function(oathID, flags) {
		local ready = false;

		switch (oathID) {
			case "effects.oath_of_distinction_active":
				ready = flags.getAsInt(::OFFP.Oathtakers.Flags.Distinction) >= ::OFFP.Oathtakers.Quests.DistinctionSlain;
				break;

			case "effects.oath_of_dominion_active":
				if (Const.DLC.Unhold) {
					local conditionOneFulfilled = flags.getAsInt(::OFFP.Oathtakers.Flags.DominionLindwurms) >= ::OFFP.Oathtakers.Quests.DominionLindwurmsSlain;
					local conditionTwoFulfilled = flags.getAsInt(::OFFP.Oathtakers.Flags.DominionUnholds) >= ::OFFP.Oathtakers.Quests.DominionUnholdsSlain;
					local conditionThreeFulfilled = flags.getAsInt(::OFFP.Oathtakers.Flags.DominionHexen) >= ::OFFP.Oathtakers.Quests.DominionHexenSlain;
					ready = conditionOneFulfilled || conditionTwoFulfilled || conditionThreeFulfilled;
				} else {
					ready = flags.getAsInt(::OFFP.Oathtakers.Flags.DominionLegacy) >= ::OFFP.Oathtakers.Quests.DominionNumSlain;
				}

				break;

			case "effects.oath_of_endurance_active":
				ready = flags.getAsInt(::OFFP.Oathtakers.Flags.Endurance) >= ::OFFP.Oathtakers.Quests.EnduranceConsecutiveBattles;
				break;

			case "effects.oath_of_fortification_active":
				ready = flags.getAsInt(::OFFP.Oathtakers.Flags.Fortification) >= ::OFFP.Oathtakers.Quests.FortificationAttacksNegated;
				break;

			case "effects.oath_of_honor_active":
				ready = flags.getAsInt(::OFFP.Oathtakers.Flags.Honor) >= ::OFFP.Oathtakers.Quests.HonorRetreatsAllowed;
				break;

			case "effects.oath_of_tithing_active":
				ready = flags.getAsInt(::OFFP.Oathtakers.Flags.Tithing) >= ::OFFP.Oathtakers.Quests.TithingCrownsLevied;
				break;

			case "effects.oath_of_loyalty_active":
				ready = flags.getAsInt(::OFFP.Oathtakers.Flags.Loyalty) >= ::OFFP.Oathtakers.Quests.LoyaltyContractsCompleted;
				break;

			case "effects.oath_of_proving_active":
				ready = flags.getAsInt(::OFFP.Oathtakers.Flags.Proving) >= ::OFFP.Oathtakers.Quests.ProvingXPGained;
				break;

			case "effects.oath_of_righteousness_active":
				local conditionOneFulfilled = flags.getAsInt(::OFFP.Oathtakers.Flags.Righteousness) >= ::OFFP.Oathtakers.Quests.RighteousnessUndeadSlain;
				local conditionTwoFulfilled = flags.getAsInt(::OFFP.Oathtakers.Flags.RighteousnessLeaders) >= ::OFFP.Oathtakers.Quests.RighteousnessLeadersSlain;
				ready = conditionOneFulfilled && conditionTwoFulfilled;
				break;

			case "effects.oath_of_sacrifice_active":
				ready = flags.getAsInt(::OFFP.Oathtakers.Flags.Sacrifice) >= ::OFFP.Oathtakers.Quests.SacrificeInjuriesSustained;
				break;

			case "effects.oath_of_valor_active":
				ready = flags.getAsInt(::OFFP.Oathtakers.Flags.Valor) >= ::OFFP.Oathtakers.Quests.ValorOutnumberedVictories;
				break;

			case "effects.oath_of_vengeance_active":
				local conditionOneFulfilled = flags.getAsInt(::OFFP.Oathtakers.Flags.Vengeance) >= ::OFFP.Oathtakers.Quests.VengeanceCompanyGreenskinsSlain;
				local conditionTwoFulfilled = flags.getAsInt(::OFFP.Oathtakers.Flags.VengeanceLeaders) >= ::OFFP.Oathtakers.Quests.VengeanceLeadersSlain;
				ready = conditionOneFulfilled && conditionTwoFulfilled;
				break;

			case "effects.oath_of_wrath_active":
				local conditionOneFulfilled = flags.getAsInt(::OFFP.Oathtakers.Flags.WrathLeaders) >= ::OFFP.Oathtakers.Quests.WrathLeadersSlain;
				local conditionTwoFulfilled = flags.getAsInt(::OFFP.Oathtakers.Flags.WrathLocations) >= ::OFFP.Oathtakers.Quests.WrathLocationsDestroyed;
				ready = conditionOneFulfilled && conditionTwoFulfilled;
				break;

			case "effects.oath_of_redemption_active":
				ready = flags.getAsInt(::OFFP.Oathtakers.Flags.Redemption) >= ::OFFP.Oathtakers.Quests.RedemptionFoesSlain;
				break;
		}

		return ready;
	}
	resetOathFlags = function(oathID, flags) {
		switch (oathID) {
			case "effects.oath_of_distinction_active":
				flags.set(::OFFP.Oathtakers.Flags.Distinction, 0);
				break;

			case "effects.oath_of_dominion_active":
				if (Const.DLC.Unhold) {
					flags.set(::OFFP.Oathtakers.Flags.DominionLindwurms, 0);
					flags.set(::OFFP.Oathtakers.Flags.DominionUnholds, 0);
					flags.set(::OFFP.Oathtakers.Flags.DominionHexen, 0);
				} else {
					flags.set(::OFFP.Oathtakers.Flags.DominionLegacy, 0);
				}

				break;

			case "effects.oath_of_endurance_active":
				flags.set(::OFFP.Oathtakers.Flags.Endurance, 0);
				break;

			case "effects.oath_of_fortification_active":
				flags.set(::OFFP.Oathtakers.Flags.Fortification, 0);
				break;

			case "effects.oath_of_honor_active":
				flags.set(::OFFP.Oathtakers.Flags.Honor, 0);
				break;

			case "effects.oath_of_tithing_active":
				flags.set(::OFFP.Oathtakers.Flags.Tithing, 0);
				break;

			case "effects.oath_of_loyalty_active":
				flags.set(::OFFP.Oathtakers.Flags.Loyalty, 0);
				break;

			case "effects.oath_of_proving_active":
				flags.set(::OFFP.Oathtakers.Flags.Proving, 0);
				break;

			case "effects.oath_of_righteousness_active":
				flags.set(::OFFP.Oathtakers.Flags.Righteousness, 0);
				flags.set(::OFFP.Oathtakers.Flags.RighteousnessLeaders, 0);
				break;

			case "effects.oath_of_sacrifice_active":
				flags.set(::OFFP.Oathtakers.Flags.Sacrifice, 0);
				break;

			case "effects.oath_of_valor_active":
				flags.set(::OFFP.Oathtakers.Flags.Valor, 0);
				break;

			case "effects.oath_of_vengeance_active":
				flags.set(::OFFP.Oathtakers.Flags.Vengeance, 0);
				flags.set(::OFFP.Oathtakers.Flags.VengeanceLeaders, 0);
				break;

			case "effects.oath_of_wrath_active":
				flags.set(::OFFP.Oathtakers.Flags.WrathLeaders, 0);
				flags.set(::OFFP.Oathtakers.Flags.WrathLocations, 0);
				break;

			case "effects.oath_of_redemption_active":
				flags.set(::OFFP.Oathtakers.Flags.Redemption, 0);
				break;
		}
	}
	getNumOathsUnlocked = function() {
		local oathsUnlocked = 0;

		if (World.Statistics.getFlags().get(::OFFP.Oathtakers.Flags.ChivalryUnlocked))
			oathsUnlocked++;
		if (World.Statistics.getFlags().get(::OFFP.Oathtakers.Flags.CombatUnlocked))
			oathsUnlocked++;
		if (World.Statistics.getFlags().get(::OFFP.Oathtakers.Flags.FleshUnlocked))
			oathsUnlocked++;
		if (World.Statistics.getFlags().get(::OFFP.Oathtakers.Flags.GloryUnlocked))
			oathsUnlocked++;
		if (World.Statistics.getFlags().get(::OFFP.Oathtakers.Flags.NemesesUnlocked))
			oathsUnlocked++;

		return oathsUnlocked;
	}
	getNumOathsCompleted = function() {
		local brothers = World.getPlayerRoster().getAll();
		local totalOathsCompleted = 0;

		foreach (bro in brothers)
			totalOathsCompleted += ::OFFP.Helpers.getNumOathsCompletedForBro(bro);

		return totalOathsCompleted;
	}
	getNumOathsCompletedForBro = function(bro) {
		local oathsCompleted = 0;

		foreach (oathName in ::OFFP.Oathtakers.OathNames) {
			if (bro.getSkills().hasSkill(::OFFP.Helpers.oathNameToCompletedID(oathName)))
				oathsCompleted++;
		}

		return oathsCompleted;
	}
	hasSkull = function(roster, stash) {
		local haveSkull = false;

		foreach (bro in roster) {
			local item = bro.getItems().getItemAtSlot(Const.ItemSlot.Accessory);

			if (item != null && (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02"))
				haveSkull = true;
		}

		if (!haveSkull) {
			foreach (item in stash) {
				if (item != null && (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02")) {
					haveSkull = true;
					break;
				}
			}
		}

		return haveSkull;
	}
	getManagementScreenTooltip = function(skill) {
		local ret = skill.getTooltip();

		if (skill.getID().find("_completed") != null)
			ret.apply(@(tooltip) tooltip.type == "description" ? { id = 2, type = "description", text = "Upholding this Oath will grant the following effects:" } : tooltip);

		return ret;
	}
}
