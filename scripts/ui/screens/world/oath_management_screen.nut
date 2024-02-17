oath_management_screen <- {
	m = {
		JSHandle = null,
		Visible = null,
		Animating = null,
		OnConnectedListener = null,
		OnDisconnectedListener = null,
		OnClosePressedListener = null
	}

	function isVisible() {
		return m.Visible != null && m.Visible == true;
	}

	function isAnimating() {
		if (m.Animating != null)
			return m.Animating == true;
		else
			return false;
	}

	function setOnConnectedListener( _listener ) {
		m.OnConnectedListener = _listener;
	}

	function setOnDisconnectedListener( _listener ) {
		m.OnDisconnectedListener = _listener;
	}

	function setOnClosePressedListener( _listener ) {
		m.OnClosePressedListener = _listener;
	}

	function clearEventListener() {
		m.OnConnectedListener = null;
		m.OnDisconnectedListener = null;
		m.OnClosePressedListener = null;
	}

	function create() {
		m.Visible = false;
		m.Animating = false;
		m.JSHandle = UI.connect("OathManagementScreen", this);
	}

	function destroy() {
		clearEventListener();
		m.JSHandle = UI.disconnect(m.JSHandle);
	}

	function show( _withSlideAnimation = false ) {
		if (m.JSHandle != null) {
			Tooltip.hide();
			m.JSHandle.asyncCall("show", queryRosterInformation());
		}
	}

	function hide( _withSlideAnimation = false ) {
		if (m.JSHandle != null) {
			Tooltip.hide();
			m.JSHandle.asyncCall("hide", _withSlideAnimation);
		}
	}

	function onScreenConnected() {
		if (m.OnConnectedListener != null)
			m.OnConnectedListener();
	}

	function onScreenDisconnected() {
		if (m.OnDisconnectedListener != null)
			m.OnDisconnectedListener();
	}

	function onScreenShown() {
		m.Visible = true;
		m.Animating = false;
	}

	function onScreenHidden() {
		m.Visible = false;
		m.Animating = false;
	}

	function onScreenAnimating() {
		m.Animating = true;
	}

	function onClose() {
		if (m.OnClosePressedListener != null)
			m.OnClosePressedListener();
	}

	function queryRosterInformation() {
		local brothers = World.getPlayerRoster().getAll();
		local roster = [];

		foreach (bro in brothers) {
			local entity = getUIEntityForBro(bro);

			if (entity != null)
				roster.push(entity);
		}

		roster.sort(onOathCompare);

		return {
			Title		= "Book of Oaths"
			SubTitle	= "Have your men quest to uphold Young Anselm's Oaths"
			Roster		= roster
		};
	}

	function onAccepted(_data) {
		local oathID = _data[0];
		local entityID = _data[1]
		local brothers = World.getPlayerRoster().getAll();
		local bro = null;

		foreach (brother in brothers) {
			if (brother.getID() == entityID) {
				bro = brother;
				break;
			}
		}

		local oathFileName = split(oathID, ".")[1] + "_effect";
		local oath = new("scripts/skills/effects/" + oathFileName);
		bro.getSkills().add(oath);

		if (oathID == "effects.oath_of_honor_active")
			bro.getSkills().add(new("scripts/skills/special/oath_of_honor_warning"));

		// Re-parse oaths so existing bro entry gets updated icons, override normal list exclusion
		local entity = getUIEntityForBro(bro, true);

		::OFFP.Helpers.resetOathFlags(oathID, bro.getFlags());

		return { Entity	= entity };
	}

	function onCompleted(_data) {
		local oathID = _data[0];
		local entityID = _data[1];
		local brothers = World.getPlayerRoster().getAll();
		local bro = null;

		foreach (brother in brothers) {
			if (brother.getID() == entityID) {
				bro = brother;
				break;
			}
		}

		bro.getSkills().removeByID(oathID);

		if (oathID == "effects.oath_of_honor_active")
			bro.getSkills().removeByID("special.oath_of_honor_warning");

		local oathFileName = split(oathID, ".")[1];
		oathFileName = oathFileName.slice(0, oathFileName.len() - 7) + "_completed_effect";
		local oath = new("scripts/skills/effects/" + oathFileName);
		bro.getSkills().add(oath);

		local entity = getUIEntityForBro(bro);

		::OFFP.Helpers.resetOathFlags(oathID, bro.getFlags());
		World.Statistics.getFlags().set(::OFFP.Flags.LastOathCompletedTime, Time.getVirtualTimeF());

		return { Entity	= entity };
	}

	function getUIEntityForBro(bro, forceShow = false) {
		local background = bro.getBackground();
		local entity = {
			ID					= bro.getID()
			Name				= bro.getName()
			Level				= bro.getLevel()
			ImagePath			= bro.getImagePath()
			ImageOffsetX		= bro.getImageOffsetX()
			ImageOffsetY		= bro.getImageOffsetY()
			BackgroundImagePath = background.getIconColored()
			BackgroundText		= background.getDescription()
			OathsAvailable		= []
			OathsToComplete		= []
			Effects				= []
		};

		local oaths = parseSkillsForOaths(bro.getSkills(), bro.getFlags());

		if (!forceShow && (oaths.Completed.len() >= 3 || (oaths.Active.len() >= 1 && oaths.ReadyToComplete.len() == 0)))
			return null;

		local oathList = clone ::OFFP.Oathtakers.OathsInitial;

		if (World.Statistics.getFlags().get(::OFFP.Oathtakers.Flags.ChivalryUnlocked))
			oathList.extend(::OFFP.Oathtakers.OathsChivalry);
		if (World.Statistics.getFlags().get(::OFFP.Oathtakers.Flags.CombatUnlocked))
			oathList.extend(::OFFP.Oathtakers.OathsCombat);
		if (World.Statistics.getFlags().get(::OFFP.Oathtakers.Flags.FleshUnlocked))
			oathList.extend(::OFFP.Oathtakers.OathsFlesh);
		if (World.Statistics.getFlags().get(::OFFP.Oathtakers.Flags.GloryUnlocked))
			oathList.extend(::OFFP.Oathtakers.OathsGlory);
		if (World.Statistics.getFlags().get(::OFFP.Oathtakers.Flags.NemesesUnlocked))
			oathList.extend(::OFFP.Oathtakers.OathsNemeses);

		if (bro.getFlags().get("IsOathbreaker"))
			oathList.extend(::OFFP.Oathtakers.OathsSpecialOathbreaker);

		foreach (oathName in oathList) {
			local activeID = ::OFFP.Helpers.oathNameToActiveID(oathName);
			local completedID = ::OFFP.Helpers.oathNameToCompletedID(oathName);

			foreach (oathID in oaths.Completed) {
				if (completedID == oathID) {
					entity.Effects.push({ id = completedID, icon = ::OFFP.Helpers.getIconForOath(completedID) });
					break;
				}
			}

			foreach (oathID in oaths.Active) {
				if (activeID == oathID) {
					entity.Effects.push({ id = activeID, icon = ::OFFP.Helpers.getIconForOath(activeID) });
					break;
				}
			}

			if (oaths.Active.len() < 1 && !bro.getSkills().hasSkill(activeID) && !bro.getSkills().hasSkill(completedID))
				entity.OathsAvailable.push(oathToUIObject(oathName, bro.getID()));

			if (!bro.getSkills().hasSkill(completedID)) {
				// My kingdom for a .includes
				// oaths.ReadyToComplete.find(oathID) != 0, maybe?
				foreach (oathID in oaths.ReadyToComplete) {
					if (activeID == oathID) {
						entity.OathsToComplete.push(oathToUIObject(oathName, bro.getID()));
						break;
					}
				}
			}
		}

		return entity;
	}

	function parseSkillsForOaths(skills, flags) {
		local oaths = {
			Active			= []
			Completed		= []
			ReadyToComplete	= []
		};

		foreach (skill in skills.m.Skills) {
			switch (skill.getID()) {
				case "effects.oath_of_distinction_active":
				case "effects.oath_of_dominion_active":
				case "effects.oath_of_endurance_active":
				case "effects.oath_of_fortification_active":
				case "effects.oath_of_honor_active":
				case "effects.oath_of_tithing_active":
				case "effects.oath_of_loyalty_active":
				case "effects.oath_of_proving_active":
				case "effects.oath_of_righteousness_active":
				case "effects.oath_of_sacrifice_active":
				case "effects.oath_of_valor_active":
				case "effects.oath_of_vengeance_active":
				case "effects.oath_of_wrath_active":
				case "effects.oath_of_redemption_active":
					if (::OFFP.Helpers.oathReadyToComplete(skill.getID(), flags)) {
						oaths.ReadyToComplete.push(skill.getID());
					}

					oaths.Active.push(skill.getID());
					break;

				case "effects.oath_of_distinction_completed":
				case "effects.oath_of_dominion_completed":
				case "effects.oath_of_endurance_completed":
				case "effects.oath_of_fortification_completed":
				case "effects.oath_of_honor_completed":
				case "effects.oath_of_tithing_completed":
				case "effects.oath_of_loyalty_completed":
				case "effects.oath_of_proving_completed":
				case "effects.oath_of_righteousness_completed":
				case "effects.oath_of_sacrifice_completed":
				case "effects.oath_of_valor_completed":
				case "effects.oath_of_vengeance_completed":
				case "effects.oath_of_wrath_completed":
				case "effects.oath_of_redemption_completed":
					oaths.Completed.push(skill.getID());
					break;
			}
		}

		return oaths;
	}

	function oathToUIObject(oathName, entityID) {
		local activeID = ::OFFP.Helpers.oathNameToActiveID(oathName);
		local completedID = ::OFFP.Helpers.oathNameToCompletedID(oathName);

		return {
			ID = activeID,
			entityId = entityID,
			icon = ::OFFP.Helpers.getIconForOath(activeID),
			name = ::OFFP.Helpers.getProperNameForOath(oathName),
			tooltipID = activeID,
			completedTooltipID = completedID
		};
	}

	function onOathCompare(_entity1, _entity2) {
		if (_entity1.OathsToComplete.len() > _entity2.OathsToComplete.len())
			return -1;
		else if (_entity1.OathsToComplete.len() < _entity2.OathsToComplete.len())
			return 1;
		else {
			if (_entity1.OathsAvailable.len() < _entity2.OathsAvailable.len())
				return -1;
			else if (_entity1.OathsAvailable.len() > _entity2.OathsAvailable.len())
				return 1;
		}

		return 0;
	}
};
