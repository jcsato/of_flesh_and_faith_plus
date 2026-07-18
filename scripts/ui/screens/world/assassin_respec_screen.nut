assassin_respec_screen <- {
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

	function setOnConnectedListener(_listener) {
		m.OnConnectedListener = _listener;
	}

	function setOnDisconnectedListener(_listener) {
		m.OnDisconnectedListener = _listener;
	}

	function setOnClosePressedListener(_listener) {
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
		m.JSHandle = UI.connect("AssassinRespecScreen", this);
	}

	function destroy() {
		clearEventListener();
		m.JSHandle = UI.disconnect(m.JSHandle);
	}

	function show(_withSlideAnimation = false) {
		if (m.JSHandle != null) {
			Tooltip.hide();
			m.JSHandle.asyncCall("show", queryRosterInformation());
		}
	}

	function hide(_withSlideAnimation = false) {
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

		brothers.sort(onAssassinCompare);

		foreach (bro in brothers) {
			local entity = getUIEntityForBro(bro);

			if (entity != null)
				roster.push(entity);
		}

		return {
			Title		= "Combat Specialty Retraining"
			SubTitle	= "Retrain an assassin in the ways of a new combat specialty"
			Roster		= roster
		};
	}

	function onRespecChosen(_data) {
		local respecID = _data[0];
		local entityID = _data[1]
		local brothers = World.getPlayerRoster().getAll();
		local bro = null;

		foreach (brother in brothers) {
			if (brother.getID() == entityID) {
				bro = brother;
				break;
			}
		}

		// All bros who can be respec'd should have this flag false (or not present) - this guard just protects against
		// UI bugs
		if (!bro.getFlags().get(::OFFP.Assassins.Flags.HasUsedRespec)) {
			foreach (specialty in ::OFFP.Assassins.SpecialtyEffects) {
				local ID = "effects." + specialty.slice(0, specialty.len() - 7);
				bro.getSkills().removeByID(ID);
			}
			local specialtyFileName = split(respecID, ".")[1] + "_effect";
			local specialty = new("scripts/skills/effects/" + specialtyFileName);

			bro.getSkills().add(specialty);

			bro.getFlags().set(::OFFP.Assassins.Flags.HasUsedRespec, true);
			local sounds = [ "sounds/new_round_01.wav", "sounds/new_round_02.wav", "sounds/new_round_03.wav" ];
			Sound.play(sounds[Math.rand(0, sounds.len() - 1)]);
		}

		// Just send the whole roster back to repopulate the whole list
		return queryRosterInformation();
	}

	function getUIEntityForBro(bro, forceShow = false) {
		if (bro.getFlags().get(::OFFP.Assassins.Flags.HasUsedRespec))
			return null;

		local skills = bro.getSkills();
		if (!skills.hasSkill("effects.way_of_the_gilder") && !skills.hasSkill("effects.way_of_the_owl") && !skills.hasSkill("effects.way_of_the_scorpion") && !skills.hasSkill("effects.way_of_the_shadow") && !skills.hasSkill("effects.way_of_the_spider") && !skills.hasSkill("effects.way_of_the_wolf"))
			return null;

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
			RespecsAvailable	= []
			Effects				= []
		};

		local specialties = [];
		foreach (specialty in ::OFFP.Assassins.SpecialtyEffects) {
			local ID = "effects." + specialty.slice(0, specialty.len() - 7);
			if (skills.hasSkill(ID))
				entity.Effects.push({ id = ID, icon = ::OFFP.Helpers.getIconForSpecialty(ID)});
			else
				specialties.push(ID);
		}

		if (entity.Effects.len() < 1)
			return null;

		foreach (specialtyID in specialties)
			entity.RespecsAvailable.push(specialtyIDToUIObject(specialtyID, bro.getID()));

		return entity;
	}

	function specialtyIDToUIObject(specialtyID, entityID) {
		return {
			ID			= specialtyID,
			entityID	= entityID,
			icon		= ::OFFP.Helpers.getIconForSpecialty(specialtyID)
			name		= ::OFFP.Helpers.getProperNameForSpecialtyID(specialtyID)
			tooltipID	= specialtyID
		}
	}

	function onAssassinCompare(_entity1, _entity2) {
		if (_entity1.getLevel() > _entity2.getLevel())
			return -1;
		else if (_entity1.getLevel() < _entity2.getLevel())
			return 1;

		return 0;
	}
};
