::mods_hookExactClass("scenarios/world/paladins_scenario", function(ps) {
	::mods_override(ps, "isValid", function() {
		return false;
	});
});

for (local i = ::Const.TipOfTheDay.len() - 1; i >= 0; --i) {
	if (::Const.TipOfTheDay[i] == "With the 'Oathtakers' origin, instead of ambitions you'll pick oaths that grant special boons and burdens.") {
		::Const.TipOfTheDay[i] = "With the 'Oathtakers' origin, you'll pick oaths from a book that grant special boons and burdens for your men."
		break;
	}
}
