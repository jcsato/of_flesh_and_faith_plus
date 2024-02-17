book_of_oaths <- inherit("scripts/items/item", {
	m = { }

	function create() {
		item.create();	

		m.ID				= "misc.book_of_oaths";
		m.Name				= "Book of Oaths";
		m.Description		= "A lovingly cared for folio containing the sacred Oaths of Young Anselm.";
		m.Icon				= "misc/inventory_book_of_oaths.png";
		m.SlotType			= Const.ItemSlot.None;
		m.ItemType			= Const.Items.ItemType.Usable | Const.Items.ItemType.Quest;

		m.IsAllowedInBag	= false;
		m.IsUsable			= true;

		m.Value				= 0;
	}

	function getTooltip() {
		local result = [
			{ id = 1, type = "title", text = getName() },
			{ id = 2, type = "description", text = getDescription() }
		];

		result.push({ id = 66, type = "text", text = getValueString() });

		if (getIconLarge() != null)
			result.push({ id = 3, type = "image", image = getIconLarge(), isLarge = true });
		else
			result.push({ id = 3, type = "image", image = getIcon() });

		result.push({ id = 11, type = "text", icon = "ui/icons/papers.png", text = "Oaths your men can uphold:" });

		local oathAcquisitions = clone ::OFFP.Oathtakers.OathsInitial;

		if (World.Statistics.getFlags().get(::OFFP.Oathtakers.Flags.ChivalryUnlocked))
			oathAcquisitions.extend(::OFFP.Oathtakers.OathsChivalry)
		if (World.Statistics.getFlags().get(::OFFP.Oathtakers.Flags.CombatUnlocked))
			oathAcquisitions.extend(::OFFP.Oathtakers.OathsCombat)
		if (World.Statistics.getFlags().get(::OFFP.Oathtakers.Flags.FleshUnlocked))
			oathAcquisitions.extend(::OFFP.Oathtakers.OathsFlesh)
		if (World.Statistics.getFlags().get(::OFFP.Oathtakers.Flags.GloryUnlocked))
			oathAcquisitions.extend(::OFFP.Oathtakers.OathsGlory)
		if (World.Statistics.getFlags().get(::OFFP.Oathtakers.Flags.NemesesUnlocked))
			oathAcquisitions.extend(::OFFP.Oathtakers.OathsNemeses)

		foreach (oath in oathAcquisitions) {
			result.push({ id = 15, type = "text", icon = "ui/icons/special.png", text = ::OFFP.Helpers.getProperNameForOath(oath) });
		}

		return result;
	}

	function playInventorySound(_eventType) {
		Sound.play("sounds/cloth_01.wav", Const.Sound.Volume.Inventory);
	}

	function onUse(_actor, _item = null) {
		Sound.play("sounds/cloth_01.wav", Const.Sound.Volume.Inventory);

		World.showOathManagementScreen();

		return false;
	}
})
