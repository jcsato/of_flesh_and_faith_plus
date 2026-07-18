::mods_hookExactClass("states/world_state", function(ws) {
	local onInitUI = ws.onInitUI;
	local onDestroyUI = ws.onDestroyUI;

	ws.showAssassinRespecScreen <- function() {
		if (!m.AssassinRespecScreen.isVisible() && !m.AssassinRespecScreen.isAnimating()) {
			m.AssassinRespecScreen.show();
			m.CampfireScreen.hide();
			Cursor.setCursor(Const.UI.Cursor.Hand);

			m.MenuStack.push(function() {
				World.getCamera().zoomTo(m.CustomZoom, 4.0);
				m.AssassinRespecScreen.hide();
				m.CampfireScreen.show();
			}, function() {
				return !m.AssassinRespecScreen.isAnimating();
			});
		}
	}

	ws.hideAssassinRespecScreen <- function() {
		m.MenuStack.pop();
	}

	ws.onInitUI = function() {
		onInitUI();

		m.AssassinRespecScreen <- new("scripts/ui/screens/world/assassin_respec_screen");
		World.showAssassinRespecScreen <- showAssassinRespecScreen.bindenv(this);
		m.AssassinRespecScreen.setOnClosePressedListener(hideAssassinRespecScreen.bindenv(this));
	}

	ws.onDestroyUI = function() {
		onDestroyUI();

		m.AssassinRespecScreen.destroy();
		m.AssassinRespecScreen = null;
	}
});

// The below three hooks use the same highly-circuitous architecture vanilla tooltips do - see
// offp_add_oath_management_screen for more detail
//
// Note that because tooltip, tooltip_events, and tooltip_screen are all "base" classes (i.e. they don't inherit from
//  any other classes), `hookExactClass` will not work on them properly and `hookClass` must be used instead.
::mods_hookClass("ui/screens/tooltip/modules/tooltip", function(t) {
	::mods_addField(t, "tooltip", "OnQuerySpecialtyTooltipDataListener", null);

	::mods_addMember(t, "tooltip", "setOnQuerySpecialtyTooltipDataListener", function(_listener) {
		m.OnQuerySpecialtyTooltipDataListener = _listener;
	});

	::mods_addMember(t, "tooltip", "onQuerySpecialtyTooltipData", function(_data) {
		if (m.OnQuerySpecialtyTooltipDataListener != null)
			return m.OnQuerySpecialtyTooltipDataListener(_data[0], _data[1]);

		return null;
	});

	local clearEventListener = ::mods_getMember(t, "clearEventListener");

	::mods_override(t, "clearEventListener", function() {
		clearEventListener();

		m.OnQuerySpecialtyTooltipDataListener = null;
	});
});

::mods_hookClass("ui/screens/tooltip/tooltip_events", function(te) {
	::mods_addMember(te, "tooltip_events", "onQuerySpecialtyTooltipData", function(_specialtyID, _entityId = null) {
		local teret =  TooltipEvents.general_querySpecialtyTooltipData(_specialtyID, _entityId);
		return teret;
	});

	::mods_addMember(te, "tooltip_events", "general_querySpecialtyTooltipData", function(_specialtyID, _entityId = null) {
		local entity = Tactical.getEntityByID(_entityId);
		if (entity != null) {
			local statusEffect = entity.getSkills().getSkillByID(_specialtyID);

			if (statusEffect != null)
				return statusEffect.getTooltip();
		} else {
			local specialtyFileName = split(_specialtyID, ".")[1] + "_effect";

			return new("scripts/skills/effects/" + specialtyFileName).getTooltip();
		}
	});
});

::mods_hookClass("ui/screens/tooltip/tooltip_screen", function(ts) {
	::Tooltip.setOnQuerySpecialtyTooltipDataListener(::TooltipEvents.onQuerySpecialtyTooltipData);
});
