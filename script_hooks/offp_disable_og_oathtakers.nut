::mods_hookExactClass("scenarios/world/paladins_scenario", function(ps) {
	::mods_override(ps, "isValid", function() {
		return false;
	});
});
