oathbreaker_background <- inherit("scripts/skills/backgrounds/character_background", {
	m = { }

	function create() {
		character_background.create();

		m.ID			= "background.oathbreaker";
		m.Name			= "Oathbreaker";
		m.Icon			= "ui/backgrounds/background_plus_01.png";

		m.BackgroundDescription	= "Oathbreakers have turned their backs on Young Anselm's order. Though capable warriors, they lack the fire of their more faithful counterparts.";
		m.GoodEnding			= "%name% the Oathtaker stayed with the %companyname%, wielding Young Anselm's skull to proselytize knightly virtues unto the world. Most see him as something of an annoyance, but there is also some charm in a man who believes fully in matters of honor and pride and doing good. Last you heard, he singlehandedly saved a lord's princess from a gang of alley thieves. In celebration, he was wed to the damsel, though rumors abound that she is unhappy in bed, proclaiming that the Oathtaker insists on Young Anselm's skull watching from the corner. Whatever's going on, you're happy that the man is still doing his thing to the fullest.";
		m.BadEnding				= "Once an Oathtaker to the bone, %name% grew disenchanted with his fellow believers and one night had a dream that they were, in fact, the true heretics. He slew every Oathtaker in reach and then fled out, eventually joining the Oathbringers of all people. Last that was heard of him, he reclaimed Young Anselm's skull and smashed it with a hammer. Enraged, his new Oathbringer brothers promptly slew him down. %name%'s corpse was found stabbed over a hundred times, ashy skull fragments powdering a bloodied, madly grinning face."

		m.HiringCost		= 130;
		m.DailyCost			= 18;

		m.Titles			= [ "the Apostate", "the Skeptic", "the Blackguard", "the Oathbreaker", "the Once-Bound", "the Recalcitrant" ];
		m.Excluded			= [ "trait.ailing", "trait.asthmatic", "trait.bleeder", "trait.clubfooted", "trait.clumsy", "trait.craven", "trait.dastard", "trait.drunkard", "trait.fainthearted", "trait.fragile", "trait.hesitant", "trait.insecure", "trait.loyal", "trait.paranoid", "trait.tiny" ];
		m.ExcludedTalents	= [ Const.Attributes.Hitpoints, Const.Attributes.Bravery ];

		m.Bodies			= Const.Bodies.Muscular;
		m.Faces				= Const.Faces.AllMale;
		m.Hairs				= Const.Hair.AllMale;
		m.HairColors		= Const.HairColors.Young;
		m.Beards			= Const.Beards.All;
		m.BeardChance		= 70;

		m.Level				= Math.rand(1, 2);

		m.IsCombatBackground = true;
	}

	function getTooltip() {
		return [
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
		];
	}

	function onBuildDescription() {
		return "{}";
	}

	function onSetAppearance() {
		local actor = getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");

		if (Math.rand(1, 100) <= 25) {
			tattoo_body.setBrush("scar_02_" + actor.getSprite("body").getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (Math.rand(1, 100) <= 30) {
			tattoo_head.setBrush("scar_02_head");
			tattoo_head.Visible = true;
		}
	}

	function updateAppearance() {
		local actor = getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush) {
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
		}
	}

	function onChangeAttributes() {
		local c = {
			Hitpoints		= [ 10	,	8	]	// 60-68
			Bravery			= [ 3	,	-2	]	// 33-38
			Stamina			= [ 3	,	0	]	// 93-100
			MeleeSkill		= [ 10	,	8	]	// 57-65
			RangedSkill		= [ 0	,	0	]	// 32-42
			MeleeDefense	= [ 4	,	4	]	// 4-8
			RangedDefense	= [ -5	,	-2	]	// -5-3
			Initiative		= [ 10	,	9	]	// 110-119
		};

		return c;
	}

	function onAddEquipment() {
		local items = getContainer().getActor().getItems();
		local r;

		if (items.hasEmptySlot(Const.ItemSlot.Mainhand)) {
			local weapons = [
				"weapons/fighting_axe"
				"weapons/winged_mace"
				"weapons/military_pick"
				"weapons/warhammer"
				"weapons/flail"
				"weapons/flail"
				"weapons/pike"
				"weapons/pike"
				"weapons/billhook"
				"weapons/billhook"
				"weapons/longaxe"
				"weapons/longaxe"
				"weapons/greataxe"
			];

			if (Const.DLC.Unhold) {
				weapons.extend([
					"weapons/three_headed_flail"
					"weapons/polehammer"
					"weapons/two_handed_flail"
					"weapons/two_handed_flanged_mace"
				]);
			}

			if (Const.DLC.Wildmen) {
				weapons.extend([
					"weapons/bardiche"
				]);
			}

			items.equip(new("scripts/items/" + weapons[Math.rand(0, weapons.len() - 1)]));
		}

		if (items.hasEmptySlot(Const.ItemSlot.Offhand) && Math.rand(1, 100) <= 75) {
			local shields = [
				"shields/wooden_shield"
				"shields/wooden_shield"
				"shields/heater_shield"
				"shields/kite_shield"
			];

			items.equip(new("scripts/items/" + shields[Math.rand(0, shields.len() - 1)]));
		}

		r = Math.rand(0, 4);

		if(r < 2)
			items.equip(new("scripts/items/armor/adorned_mail_shirt"));
		else if(r < 4)
			items.equip(new("scripts/items/armor/adorned_warriors_armor"));
		else if(r == 4)
			items.equip(new("scripts/items/armor/adorned_heavy_mail_hauberk"));

		r = Math.rand(0, 4);

		if(r < 2)
			items.equip(new("scripts/items/helmets/heavy_mail_coif"));
		else if(r < 4)
			items.equip(new("scripts/items/helmets/adorned_closed_flat_top_with_mail"));
		else if(r == 4)
			items.equip(new("scripts/items/helmets/adorned_full_helm"));
	}
});
