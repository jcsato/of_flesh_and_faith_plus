::mods_registerMod("of_flesh_and_faith_plus", 4.0.6, "Of Flesh and Faith+");

::mods_queue("of_flesh_and_faith_plus", null, function() {
	::mods_registerCSS("screens/world/oath_management_screen.css");
	::mods_registerJS("screens/world/oath_management_screen.js");
	::mods_registerCSS("screens/world/assassin_respec_screen.css");
	::mods_registerJS("screens/world/assassin_respec_screen.js");

	::mods_registerJS("offp_shim.js");

	::include("script_hooks/!offp_constants");
	::include("script_hooks/!offp_helpers");
	::include("script_hooks/offp_add_assassin_respec_screen");
	::include("script_hooks/offp_add_oath_management_screen");
	::include("script_hooks/offp_anatomists");
	::include("script_hooks/offp_assassin_retirement");
	::include("script_hooks/offp_assassin_skills");
	::include("script_hooks/offp_disable_og_oathtakers");
	::include("script_hooks/offp_explorers_ambitions");
	::include("script_hooks/offp_explorers_locations");
	::include("script_hooks/offp_legendary_events");
	::include("script_hooks/offp_oath_effects");
	::include("script_hooks/offp_oathtakers_ambitions");
	::include("script_hooks/offp_oathtakers_events");
	::include("script_hooks/offp_retinue");
	::include("script_hooks/offp_runechosen_events");
	::include("script_hooks/offp_runeknight_deaths");
});
