::mods_hookExactClass("entity/world/attached_location/fortified_outpost_location", function(fol) {
	local onUpdateDraftList = ::mods_getMember(fol, "onUpdateDraftList");

	::mods_override(fol, "onUpdateDraftList", function(_list) {
		onUpdateDraftList(_list);

		local index = _list.find("paladin_background");
		if (index != null) {
			_list.remove(index);
		}
	})
});

::mods_hookExactClass("entity/world/attached_location/stone_watchtower_location", function(swl) {
	local onUpdateDraftList = ::mods_getMember(swl, "onUpdateDraftList");

	::mods_override(swl, "onUpdateDraftList", function(_list) {
		onUpdateDraftList(_list);

		local index = _list.find("paladin_background");
		if (index != null) {
			_list.remove(index);
		}
	})
});

::mods_hookExactClass("entity/world/attached_location/wooden_watchtower_location", function(wwl) {
	local onUpdateDraftList = ::mods_getMember(wwl, "onUpdateDraftList");

	::mods_override(wwl, "onUpdateDraftList", function(_list) {
		onUpdateDraftList(_list);

		local index = _list.find("paladin_background");
		if (index != null) {
			_list.remove(index);
		}
	})
});
