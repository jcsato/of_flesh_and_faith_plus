::mods_hookNewObject("retinue/followers/drill_sergeant_follower", function(dsf) {
	local isVisible = dsf.isVisible;

	dsf.isVisible = function()
	{
		if (World.Assets.getOrigin().getID() == "scenario.runeknights")
			return false;
		else
			return isVisible();
	};
});

::mods_hookNewObject("ui/screens/world/world_campfire_screen", function(wcs) {
	local onSlotClicked = wcs.onSlotClicked;

	wcs.onSlotClicked = function( _data ) {
		if (World.Assets.getOrigin().getID() == "scenario.southern_assassins") {
			local retinueMemberAtSlot = World.Retinue.m.Slots[_data];

			if (retinueMemberAtSlot != null && (World.Retinue.m.Slots[_data].getID() == "follower.assassin_master" || World.Retinue.m.Slots[_data].getID() == "follower.poison_master"))
				return;
		}

		onSlotClicked(_data);
	}
});
