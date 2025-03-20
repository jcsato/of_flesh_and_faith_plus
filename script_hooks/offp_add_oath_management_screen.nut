::mods_hookExactClass("states/world_state", function(ws) {
	local onInitUI = ws.onInitUI;
	local onDestroyUI = ws.onDestroyUI;

	ws.showOathManagementScreen <- function() {
		if (!m.OathManagementScreen.isVisible() && !m.OathManagementScreen.isAnimating()) {
			m.OathManagementScreen.show();
			m.CharacterScreen.hide();
			Cursor.setCursor(Const.UI.Cursor.Hand);

			m.MenuStack.push(function() {
				World.getCamera().zoomTo(m.CustomZoom, 4.0);			
				m.OathManagementScreen.hide();
				m.CharacterScreen.show();
			}, function() {
				return !m.OathManagementScreen.isAnimating();
			});
		}
	}

	ws.hideOathManagementScreen <- function() {
		m.MenuStack.pop();
	}

	ws.onInitUI = function() {
		onInitUI();

		m.OathManagementScreen <- new("scripts/ui/screens/world/oath_management_screen");
		World.showOathManagementScreen <- showOathManagementScreen.bindenv(this);
		m.OathManagementScreen.setOnClosePressedListener(hideOathManagementScreen.bindenv(this));
	}

	ws.onDestroyUI = function() {
		onDestroyUI();

		m.OathManagementScreen.destroy();
		m.OathManagementScreen = null;
	}
});

// The below three hooks use the same highly-circuitous architecture vanilla tooltips do:
//
//  tooltip_events module:
//    Add a tooltip data processor that calls another class's `getTooltip()` method
//    Call the above data processor from an "onQuery" method that passes data in
//
//  tooltip module:
//   Add an "onQueryListener" member and a corresponding setter
//   Add an "onQuery" method that calls the listener
//
//  tooltip_events screen:
//   Call the above listener setter, passing in the "onQuery" method from tooltip_events
//
// Lastly, because I'm adding a net new tooltip, in my JS shim I update
//  `TooltipModule.prototype.notifyBackendQueryTooltipData` for the new tooltip type and have it trigger the listener.
//
// The main reason I use this same architecture (aside from consistency with vanilla) is to ease hooking for other
//  mods. One could simply load after this mod and hook just tooltip_events.general_queryOathTooltipData and things
//  would "just work" without needing hook or understand any of the other UI module hooking happening.
//
// Note that because tooltip, tooltip_events, and tooltip_screen are all "base" classes (i.e. they don't inherit from
//  any other classes), `hookExactClass` will not work on them properly and `hookClass` must be used instead.
::mods_hookClass("ui/screens/tooltip/modules/tooltip", function(t) {
	::mods_addField(t, "tooltip", "OnQueryOathTooltipDataListener", null);

	::mods_addMember(t, "tooltip", "setOnQueryOathTooltipDataListener", function(_listener) {
		m.OnQueryOathTooltipDataListener = _listener;
	});

	::mods_addMember(t, "tooltip", "onQueryOathTooltipData", function(_data) {
		if (m.OnQueryOathTooltipDataListener != null)
			return m.OnQueryOathTooltipDataListener(_data[0], _data[1]);

		return null;
	});

	local clearEventListener = ::mods_getMember(t, "clearEventListener");

	::mods_override(t, "clearEventListener", function() {
		clearEventListener();

		m.OnQueryOathTooltipDataListener = null;
	});
});

::mods_hookClass("ui/screens/tooltip/tooltip_events", function(te) {
	::mods_addMember(te, "tooltip_events", "onQueryOathTooltipData", function(_oathId, _entityId = null) {
		// return TooltipEvents.general_queryOathTooltipData(_oathId, _entityId);
		local teret =  TooltipEvents.general_queryOathTooltipData(_oathId, _entityId);
		return teret;
	});

	// The `general_queryStatusEffectTooltipData` that exists in vanilla will only work for skills already present
	//  in a given entity's skillContainer. On the Oath Management screen, however, I want to get tooltips for skills
	//  that are not yet on a bro (sometimes). That's what necessitates this whole rigamarole in the first place;
	//  otherwise I would just use the existing method.
	//
	// The other requirement is that sometimes skills _should_ have an associated entity - namely, when an oath is
	//  active or ready to complete, I want the player to be able to mouse over an oath and see the bro's progress.
	//  This necessitates additional work in the oath effects themselves to support a "containerless" version of
	//  `getTooltip()` - which is also why this is a specific solution for oaths and not more generic for all skills.
	//
	::mods_addMember(te, "tooltip_events", "general_queryOathTooltipData", function(_oathId, _entityId = null) {

		local entity = Tactical.getEntityByID(_entityId);
		if (entity != null) {
			local statusEffect = entity.getSkills().getSkillByID(_oathId);

			if (statusEffect != null)
				return statusEffect.getTooltip();
		} else {
			local oathFileName = split(_oathId, ".")[1] + "_effect";

			return ::OFFP.Helpers.getManagementScreenTooltip(new("scripts/skills/effects/" + oathFileName));
		}
	});
});

::mods_hookClass("ui/screens/tooltip/tooltip_screen", function(ts) {
	::Tooltip.setOnQueryOathTooltipDataListener(::TooltipEvents.onQueryOathTooltipData);
});
