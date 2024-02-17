oathtaker_brings_oaths_event <- inherit("scripts/events/event", {
	m = {
		Dude		= null
		OathGroup	= ""
	}

	function create() {
		m.ID		= "event.oathtaker_brings_oaths";
		m.Title		= "During camp...";
		m.IsSpecial = true;

		m.Screens.push({
			ID			= "OathsUnlock"
			Text		= ""
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [ ]

			function start(_event) {
				local oathName = "";
				local oathUnlockFlag = "";
				local roster = World.getTemporaryRoster();

				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([ "paladin_background" ]);
				_event.scaleBroForOaths(_event.m.Dude);

				if (_event.m.OathGroup == "Chivalry") {
					Text = "[img]gfx/ui/events/event_180.png[/img]{A man strides into camp escorted by %randombrother%, his head held high. In his hand he clutches a leather-bound folio. He comes up to you and opens it to reveal a sheaf of remarkably pristine papers.%SPEECH_ON%'Tis an unusual chimera you have here, captain, to marry oathtaking and sellswording so. I've heard tell of your company from laity and villain alike, however, and their words suggest you answer well to both callings.%SPEECH_OFF%He beholds at the camp and men with a searching look, then gestures at the folio and smiles.%SPEECH_ON%I'm heartened that my eyes perceive the same. I've come on behalf of the order to deliver these Oaths, that your men might know creeds of virtue to match their skill. I quest to uphold them myself, but the words are ingrained in my heart and I've no need of the papers to hear Young Anselm's issuance.%SPEECH_OFF%Among the documents, your eye is caught in particular by two that detail honor and courage in combat. You transfer them all to the Book of Oaths and return to address the man.}";
					oathName = ::OFFP.Oathtakers.OathsChivalry[Math.rand(0, ::OFFP.Oathtakers.OathsChivalry.len() - 1)];
					oathUnlockFlag = ::OFFP.Oathtakers.Flags.ChivalryUnlocked;
				} else if (_event.m.OathGroup == "Combat") {
					Text = "[img]gfx/ui/events/event_180.png[/img]{%randombrother% steps into your tent.%SPEECH_ON%There's an Oathtaker here to see you, sir. Says he has something you'll want to see.%SPEECH_OFF%You set aside your quill and enter the camp to find a tall man clad in armor with his hands tented over the hilt of a weapon. He speaks up as you approach.%SPEECH_ON%Greetings, captain. I am " + _event.m.Dude.getName() + ", chosen warden of the Oaths of combat. It was shrewd to steer a band of Oathtakers towards mercenary work. In my own pursuit of the Oaths I've found myself in many a sellswording band, and the work offers ample opportunity to prove one's worth in battle.%SPEECH_OFF%He produces a parcel from his pack and hands it over. You open it. Inside is a collection of papers and holy scripts, some aged and dogeared, others stained with flecks of blood.%SPEECH_ON%I confer to your company these Oaths. Myself and the rest of the order have deemed your lot worthy of their keeping. It is a privilege, but also a gift - any of your men would do well to dedicate themselves to the first Oathtaker's treatises on combat.%SPEECH_OFF%You delicately place them into the Book of Oaths and thank the man.}";
					oathName = ::OFFP.Oathtakers.OathsCombat[Math.rand(0, ::OFFP.Oathtakers.OathsCombat.len() - 1)];
					oathUnlockFlag = ::OFFP.Oathtakers.Flags.CombatUnlocked;
				} else if (_event.m.OathGroup == "Flesh") {
					Text = "[img]gfx/ui/events/event_180.png[/img]{A curious visitor has made their way into camp. What was surely once a hail and hearty Oathtaker now stands doubled over before you, winded and bruised, leaning on his weapon for support. When he speaks, however, his voice is strong and even toned.%SPEECH_ON%Good tidings, captain. I come bearing gifts from the order.%SPEECH_OFF%He shakily proffers a collection of loose papers and scrolls.%SPEECH_ON%The Oaths pertaining to the flesh. Truly a worthy set of aspirations for any Oathtaker to follow, and a keen reminder that though the body be bruised and battered, the quest goes on. While my own trials continue, it is time for your company to benefit from Young Anselm's wisdom.%SPEECH_OFF%You question how much wisdom there can truly be in a codex built on self-torture, but you accept them out of concern it would harm the man to require further use of his limbs. You collect them into the Book of Oaths, making note that a handful of the scripts might do more good than harm if followed, then turn back to your beleaguered visitor. }";
					oathName = ::OFFP.Oathtakers.OathsFlesh[Math.rand(0, ::OFFP.Oathtakers.OathsFlesh.len() - 1)];
					oathUnlockFlag = ::OFFP.Oathtakers.Flags.FleshUnlocked;
				} else if (_event.m.OathGroup == "Glory") {
					Text = "[img]gfx/ui/events/event_180.png[/img]{Before you in camp stands perhaps the least subtle man you've ever seen. Clad in gleaming, polished armor, plastered all over with miscellaneous trophies and sigils, and clutching a stack of Young Anselm's writings, you have a feeling you could see the man and recognize him as an Oathtaker from a mile away.%SPEECH_ON%Ho there, captain! The order bid me relinquish these Oaths to your safeguard, in recognition of your accomplishments thus far.%SPEECH_OFF%He absentmindedly polishes a buckle as he hands you the texts.%SPEECH_ON%After all, was it not our own founder who said, \'and let every man be given lease to prove his own worth?\' My own questing can continue without need to hoard his writings to my own.%SPEECH_OFF%You add them to the Book of Oaths and return your attention back to the man, who appears to be adjusting some medal to make it more obvious.}";
					oathName = ::OFFP.Oathtakers.OathsGlory[Math.rand(0, ::OFFP.Oathtakers.OathsGlory.len() - 1)];
					oathUnlockFlag = ::OFFP.Oathtakers.Flags.GloryUnlocked;
				} else if (_event.m.OathGroup == "Nemeses") {
					Text = "[img]gfx/ui/events/event_180.png[/img]{%randombrother% comes jogging up to you in camp.%SPEECH_ON%Cap, we've got a visitor. Think you ought to come.%SPEECH_OFF%Your guest turns out to be an Oathtaker. He scowls at the men, and the camp, and even the sky with an unnerving intensity. The dirt caked on his boots and garb betray familiarity with the road, and the various trophies that adorning him betray a penchant for battle against more exotic foes than most would dare face. The terseness of his manner, in turn, betrays little care for the niceties of civilized society.%SPEECH_ON%Captain. Finally. The order bid me confer to you these Oaths, that you and your company might take up arms in our great crusade as well.%SPEECH_OFF%He hands you a bundle of scrolls, blackened by age and stained by blood and sweat and tears and all the fluids men tend to shed in moments of fear and battle.%SPEECH_ON%I myself have been devoted to the undoing of those that would undo us, a task I must return to forthwith, for ever in the recesses of the world does evil spawn.%SPEECH_OFF%You thank the man and add the papers to the Book of Oaths.}";
					oathName = ::OFFP.Oathtakers.OathsNemeses[Math.rand(0, ::OFFP.Oathtakers.OathsNemeses.len() - 1)];
					oathUnlockFlag = ::OFFP.Oathtakers.Flags.NemesesUnlocked;
				}

				::OFFP.Helpers.resetOathFlags(::OFFP.Helpers.oathNameToActiveID(oathName), _event.m.Dude.getFlags());
				_event.m.Dude.getSkills().add(new("scripts/skills/effects/" + oathName + "_active_effect"));

				if (oathName == "oath_of_sacrifice")
					_event.m.Dude.addInjury(Const.Injury.PiercingBody);
				else if (oathName == "oath_of_endurance")
					_event.m.Dude.getSkills().add(new("scripts/skills/effects_world/exhausted_effect"));

				Characters.push(_event.m.Dude.getImagePath());

				// Unlock oaths
				World.Statistics.getFlags().set(oathUnlockFlag, true);
				List.push({ id = 10, icon = "ui/icons/special.png", text = "The Book of Oaths has been expanded" });

				local roster = World.getPlayerRoster();

				foreach (bro in roster.getAll()) {
					if (bro.getBackground().getID() == "background.paladin") {
						bro.improveMood(0.75, "The company has recovered more oaths to follow");

						if (bro.getMoodState() > Const.MoodState.Neutral)
							List.push({ id = 11, icon = Const.MoodStateIcon[bro.getMoodState()], text = bro.getName() + Const.MoodStateEvent[bro.getMoodState()] });
					}
				}

				if (roster.getSize() < World.Assets.getBrothersMax()) {
					Options.push({
						Text = "{Join us and we shall quest together! | No Oathtaker walks this realm alone. Uphold your Oath with the company by your side! | The company would do well to have another Oathtaker in our ranks. Join us.}"
						function getResult(_event) { return "OathsJoin" }
					});
				}

				Options.push({
					Text = "{Our thanks to the order. | This boon shall not go wasted. | The Oaths shall be upheld!}"
					function getResult(_event) { return "OathsArmorReward" }
				});
			}
		});

		m.Screens.push({
			ID			= "OathsJoin"
			Text		= "[img]gfx/ui/events/event_180.png[/img]{The man ponders your offer for not very long at all, then clasps your hand in an uncomfortably firm handshake.%SPEECH_ON%Aye, as Oathtakers!%SPEECH_OFF% | The Oathtaker doesn't even stop to think before accepting.%SPEECH_ON%Aye, let us bring glory to Young Anselm's name together!%SPEECH_OFF% | He stares at you with an intensity you've grown accustomed to expect from his cult.%SPEECH_ON%So it shall be.%SPEECH_OFF%And then, much more loudly.%SPEECH_ON%And death to the Oathbringers!%SPEECH_OFF%The rest of the men cheer with him, although you suspect some more from surprise at the abruptness of his outburst than from its content. | The Oathtaker doesn't say anything, just shakes your hand and falls in with the ranks, as though it were the most natural thing he could do. | The man bellows out a hearty laugh.%SPEECH_ON%A fine notion! Very well, captain, as Oathtakers!%SPEECH_OFF% | The man bellows out a hearty laugh.%SPEECH_ON%A fine notion! Very well, captain, for Young Anselm!%SPEECH_OFF% | He strokes his chin thoughtfully for a moment.%SPEECH_ON%I can think of no better company than your own in which to pursue the Oaths and bring steel to the flesh of Oathbringer scum. Very well!%SPEECH_OFF%Well, all right.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "{For Young Anselm! | As Oathtakers! | And death to the Oathbringers!}"
					function getResult(_event) {
						World.getPlayerRoster().add(_event.m.Dude);
						World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}
				}
			]

			function start(_event) {
				Characters.push(_event.m.Dude.getImagePath());
			}
		});

		m.Screens.push({
			ID			= "OathsArmorReward"
			Text		= "[img]gfx/ui/events/event_180.png[/img]{The visitor turns to leave, but stops short.%SPEECH_ON%Oh, I almost forgot. Here, take this. The armor of %randomoathtakername%. I'm sure a member of the order as famous as him needs no introduction. May his shell serve you better than it did him.%SPEECH_OFF%You nod as if you know all about %randomoathtakername% and his exploits and take the armor. The man flashes some Oathtaker sign of solidarity with his hand and you awkwardly mimic it as he turns and leaves. | The man produces a small chest you failed to notice before. You've no idea where he hid the thing or how he lugged it on his own.%SPEECH_ON%One more thing. The order sent you proper armor. It won't do for your men to go oathtaking in whatever recreant garb you'll find in a marketplace.%SPEECH_OFF%You inspect the contents of the chest and it is, indeed, a cut above what you typically get hawked in towns. You turn to thank the man but he's already striding off, pursuing his next task. | %SPEECH_ON%The Oaths are not the only gift I come bearing. Here.%SPEECH_OFF%He grabs a heavy bundle from his pack and tosses it at you. You stagger a bit from its weight and quickly pass it off to %randombrother%.%SPEECH_ON%Proper armor, forged and sanctified under the auspice of %randomoathtakername% himself. May it serve you well.%SPEECH_OFF% | The man starts, suddenly remembering something.%SPEECH_ON%Oh! I nearly forgot. Here, one more boon, a set of armor. I'd wager you'd be hard pressed to find its like elsewhere.%SPEECH_OFF%You take it and immediately wonder how the man could have forgotten he carried such a heavy load. | %SPEECH_ON%One more thing.%SPEECH_OFF%The Oathtaker produces a heavy package and hands it to you.%SPEECH_ON%The order bade me give you this armor. An Oathtaker without a carapace to protect him from the world's evils is as naked as a sellsword without a weapon, no?%SPEECH_OFF%You have %randombrother% put the package in inventory and see the visitor off.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "{Much appreciated. | This will see good use. | Truly armor worthy of an Oathtaker!}"
					function getResult(_event) { return 0;}
				}
			]

			function start(_event) {
				local rewards = _event.getScaledRewards();

				World.Assets.getStash().makeEmptySlots(rewards.len());

				foreach (reward in rewards) {
					local item = new("scripts/items/" + reward);
					World.Assets.getStash().add(item);
					List.push( { id = 10, icon = "ui/items/" + item.getIcon(), text = "You gain " + Const.Strings.getArticle(item.getName()) + item.getName() } );
				}
			}
		});
	}

	function isValid() {
		if (!Const.DLC.Paladins)
			return false;

		if (World.Assets.getOrigin().getID() != "scenario.oathtakers")
			return false;

		if (Time.getVirtualTimeF() - World.Events.getLastBattleTime() < 5.0)
			return false;

		local lastOathCompletedTime = World.Statistics.getFlags().getAsFloat(::OFFP.Flags.LastOathCompletedTime);
		if (Time.getVirtualTimeF() - lastOathCompletedTime < 48.0)
			return false;

		local lastOathEventCheckTime = World.Statistics.getFlags().getAsFloat(::OFFP.Flags.LastOathEventCheckTime);
		if (Time.getVirtualTimeF() - lastOathEventCheckTime < 48.0)
			return false;

		World.Statistics.getFlags().set(::OFFP.Flags.LastOathEventCheckTime, Time.getVirtualTimeF());

		local oathGroups = getOathGroupsRemaining();
		local oathsCompleted = ::OFFP.Helpers.getNumOathsCompleted();

		if (oathGroups.len() == 0)
			return false;
		else if (oathGroups.len() == 1 && oathsCompleted < ::OFFP.Oathtakers.CompletionThresholds.FinalUnlock)
			return false;
		else if (oathGroups.len() == 2 && oathsCompleted < ::OFFP.Oathtakers.CompletionThresholds.FourthUnlock)
			return false;
		else if (oathGroups.len() == 3 && oathsCompleted < ::OFFP.Oathtakers.CompletionThresholds.ThirdUnlock)
			return false;
		else if (oathGroups.len() == 4 && oathsCompleted < ::OFFP.Oathtakers.CompletionThresholds.SecondUnlock)
			return false;
		else if (oathsCompleted < ::OFFP.Oathtakers.CompletionThresholds.FirstUnlock)
			return false;

		return true;
	}

	function onUpdateScore() {
		local oathGroups = getOathGroupsRemaining();

		m.OathGroup = oathGroups[Math.rand(0, oathGroups.len() - 1)];

		return;
	}

	function onPrepareVariables(_vars) {
		local randomDude = World.getTemporaryRoster().create("scripts/entity/tactical/player");
		randomDude.setStartValuesEx([ "paladin_background" ]);
		_vars.push([ "randomoathtakername", randomDude.getName() ]);
	}

	function onDetermineStartScreen() {
		return "OathsUnlock";
	}

	function onClear() {
		m.Dude = null;
		m.OathGroup = "";
	}

	function getOathGroupsRemaining() {
		local oathGroupsRemaining = [];

		if (!World.Statistics.getFlags().get(::OFFP.Oathtakers.Flags.ChivalryUnlocked))
			oathGroupsRemaining.push("Chivalry");
		if (!World.Statistics.getFlags().get(::OFFP.Oathtakers.Flags.CombatUnlocked))
			oathGroupsRemaining.push("Combat");
		if (!World.Statistics.getFlags().get(::OFFP.Oathtakers.Flags.FleshUnlocked))
			oathGroupsRemaining.push("Flesh");
		if (!World.Statistics.getFlags().get(::OFFP.Oathtakers.Flags.GloryUnlocked))
			oathGroupsRemaining.push("Glory");
		if (!World.Statistics.getFlags().get(::OFFP.Oathtakers.Flags.NemesesUnlocked))
			oathGroupsRemaining.push("Nemeses");

		return oathGroupsRemaining;
	}

	// This function assumes that (as in vanilla) Oathtakers will spawn with at least a helmet/armor/mainhand weapon
	// If used with another mod that changes Oathtaker spawn equipment such that the above is no longer true, a patch
	//  will be needed to add `if <item> != null` checks. Those have been elided here for brevity and redundancy.
	function scaleBroForOaths(dude) {
		local items = dude.getItems();
		local oathsUnlocked = ::OFFP.Helpers.getNumOathsUnlocked();

		switch (oathsUnlocked) {
			case 0:
				// Prevent player from getting free late game gear early
				items.unequip(items.getItemAtSlot(Const.ItemSlot.Head));
				items.unequip(items.getItemAtSlot(Const.ItemSlot.Body));
				items.equip(new("scripts/items/armor/adorned_mail_shirt"));

				switch (items.getItemAtSlot(Const.ItemSlot.Mainhand).getID()) {
					case "weapon.fighting_axe":
					case "weapon.warhammer":
					case "weapon.winged_mace":
					case "weapon.greataxe":
					case "weapon.greatsword":
					case "weapon.two_handed_flail":
					case "weapon.two_handed_flanged_mace":
					case "weapon.bardiche":
					case "weapon.billhook":
						items.unequip(items.getItemAtSlot(Const.ItemSlot.Mainhand));
						items.equip(new("scripts/items/weapons/arming_sword"));
						break;
				}

				dude.m.PerkPoints = 0;
				dude.m.LevelUps = 0;
				dude.m.Level = 1;
				dude.m.XP = Const.LevelXP[dude.m.Level - 1];
				break;

			case 1:
				// Again, prevent new guy's gear from being *too* good
				if (items.getItemAtSlot(Const.ItemSlot.Head).getID() == "armor.head.adorned_full_helm") {
					items.unequip(items.getItemAtSlot(Const.ItemSlot.Head));
					item.equip(new("scripts/items/helmets/heavy_mail_coif"));
				}

				if (items.getItemAtSlot(Const.ItemSlot.Body).getID() == "armor.body.adorned_heavy_mail_hauberk") {
					items.unequip(items.getItemAtSlot(Const.ItemSlot.Body));
					items.equip(new("scripts/items/armor/adorned_mail_shirt"));
				}

				switch (items.getItemAtSlot(Const.ItemSlot.Mainhand).getID()) {
					case "weapon.greataxe":
					case "weapon.greatsword":
					case "weapon.two_handed_flail":
					case "weapon.two_handed_flanged_mace":
					case "weapon.bardiche":
					case "weapon.billhook":
						items.unequip(items.getItemAtSlot(Const.ItemSlot.Mainhand));
						items.equip(new("scripts/items/weapons/arming_sword"));
						break;
				}

				if (dude.m.Level > 2) {
					dude.m.PerkPoints = 0;
					dude.m.LevelUps = 0;
					dude.m.Level = 1;
					dude.m.XP = Const.LevelXP[dude.m.Level - 1];
				}

				break;

			case 2:
				if (items.getItemAtSlot(Const.ItemSlot.Head).getID() == "armor.head.adorned_full_helm") {
					items.unequip(items.getItemAtSlot(Const.ItemSlot.Head));
					items.equip(new("scripts/items/helmets/adorned_closed_flat_top_with_mail"));
				}

				if (items.getItemAtSlot(Const.ItemSlot.Body).getID() == "armor.body.adorned_heavy_mail_hauberk") {
					items.unequip(items.getItemAtSlot(Const.ItemSlot.Body));
					items.equip(new("scripts/items/armor/adorned_warriors_armor"));
				}

				if (dude.m.Level < 2) {
					dude.m.PerkPoints = 1;
					dude.m.LevelUps = 1;
					dude.m.Level = 2;
					dude.m.XP = Const.LevelXP[dude.m.Level - 1];
				}

				break;

			case 3:
				if (items.getItemAtSlot(Const.ItemSlot.Head).getID() == "armor.head.heavy_mail_coif") {
					items.unequip(items.getItemAtSlot(Const.ItemSlot.Head));
					items.equip(new("scripts/items/helmets/adorned_closed_flat_top_with_mail"));
				}

				if (items.getItemAtSlot(Const.ItemSlot.Body).getID() == "armor.body.adorned_mail_shirt") {
					items.unequip(items.getItemAtSlot(Const.ItemSlot.Body));
					items.equip(new("scripts/items/armor/adorned_warriors_armor"));
				}

				if (dude.m.Level < 3) {
					dude.m.PerkPoints = 3;
					dude.m.LevelUps = 3;
					dude.m.Level = 4;
					dude.m.XP = Const.LevelXP[dude.m.Level - 1];
				}

				break;

			case 4:
				if (items.getItemAtSlot(Const.ItemSlot.Head).getID() != "armor.head.adorned_full_helm") {
					items.unequip(items.getItemAtSlot(Const.ItemSlot.Head));
					items.equip(new("scripts/items/helmets/adorned_full_helm"));
				}

				if (items.getItemAtSlot(Const.ItemSlot.Body).getID() != "armor.body.adorned_heavy_mail_hauberk") {
					items.unequip(items.getItemAtSlot(Const.ItemSlot.Body));
					items.equip(new("scripts/items/armor/adorned_heavy_mail_hauberk"));
				}

				switch (items.getItemAtSlot(Const.ItemSlot.Mainhand).getID()) {
					case "weapon.arming_sword":
					case "weapon.military_pick":
					case "weapon.billhook":
					case "weapon.longsword":
					case "weapon.longaxe":
					case "weapon.polehammer":
						local weapons = [
							"weapons/fighting_axe"
							"weapons/winged_mace"
							"weapons/warhammer"
							"weapons/greataxe"
							"weapons/greatsword"
						];

						if (Const.DLC.Unhold) {
							weapons.extend([
								"weapons/two_handed_flail"
								"weapons/two_handed_flanged_mace"
							]);
						}

						if (Const.DLC.Wildmen)
							weapons.extend([ "weapons/bardiche" ]);

						items.unequip(items.getItemAtSlot(Const.ItemSlot.Mainhand));
						items.unequip(items.getItemAtSlot(Const.ItemSlot.Offhand));

						items.equip(new("scripts/items/" + weapons[Math.rand(0, weapons.len() - 1)]));
						break;
				}

				dude.m.PerkPoints = 4;
				dude.m.LevelUps = 4;
				dude.m.Level = 5;
				dude.m.XP = Const.LevelXP[dude.m.Level - 1];

				break;
		}
	}

	function getScaledRewards() {
		local rewards = [];
		local oathsUnlocked = ::OFFP.Helpers.getNumOathsUnlocked();

		switch (oathsUnlocked) {
			case 0:
				rewards.push("helmets/heavy_mail_coif");
				rewards.push("armor/adorned_mail_shirt");
				break;

			case 1:
				rewards.push("armor/adorned_warriors_armor");
				break;

			case 2:
				rewards.push("helmets/adorned_closed_flat_top_with_mail");
				rewards.push("armor/adorned_warriors_armor");
				break;

			case 3:
				rewards.push("armor/adorned_heavy_mail_hauberk");
				break;

			default:
				rewards.push("helmets/adorned_full_helm");
				rewards.push("armor/adorned_heavy_mail_hauberk");
		}

		return rewards;
	}
});
