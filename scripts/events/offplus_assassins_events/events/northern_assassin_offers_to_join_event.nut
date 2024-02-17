northern_assassin_offers_to_join_event <- inherit("scripts/events/event", {
	m = {
		Dude = null
	}

	function create() {
		m.ID		= "event.northern_assassin_offers_to_join";
		m.Title		= "During camp...";
		m.Cooldown	= 9999.0 * World.getTime().SecondsPerDay;

		m.Screens.push({
			ID			= "A"
			Text		= "[img]gfx/ui/events/event_55.png[/img]{You once again find yourself taking inventory. There truly is no task that can compare, nothing so sacred and calming and shielded from the madness of leading a group of assassins and assassins-to-be around through the supposedly civilized world. Just as you begin to truly commit to the task, however, your reverie is interrupted and you become aware of a presence.\n\nYou spin around and find yourself not 3 paces from a cloaked man, staring at you from the shadows. His face is pale-skinned and cold-eyed under his hood. He may be a northerner, but you know with certainty that this man is an assassin. Come to kill you? Threaten you? Revenge for an old job? A challenge from some new northern guild? Thoughts race through your head, but the man holds out his hands in peace before you can draw your sword. He speaks in a raspy, almost sibilant voice.%SPEECH_ON%Stay your blade, 'mercenary', I mean you no harm. In truth, I'm impressed - few men can notice my presence so quickly. You know what I am, and as you can see, I'm exceptional at what I do. I know what you are, too, and I know you could make use of my skills.%SPEECH_OFF%You take your hand off your sword, pretending to relax but prepared to pull a hidden dagger if needed. He sees though the gesture and grins, as you suspected he might. You tell him to get to the point.%SPEECH_ON%I come with an offer. 3000 crowns, a daily wage, and no questions asked. Give me that, and I'll fight for you as long as you require.%SPEECH_OFF%}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "Very well. %hirecost% crowns it is."
					function getResult(_event) { return "B"; }
				},
				{
					Text = "No deal."
					function getResult(_event) { return "C"; }
				}
			]

			function start(_event) { }
		});

		m.Screens.push({
			ID			= "B"
			Text		= "[img]gfx/ui/events/event_55.png[/img]{Well, he certainly seems skilled, and you have to admit you're curious to see just how good these northern assassins are. You toss the man a sack of crowns and emphasize that he should avoid skulking around camp in the future unless he wants to find a dagger in his back, or worse, get himself on inventory duty. He laughs, and the sound sends a chill down your spine.%SPEECH_ON%I'll keep that in mind, captain.%SPEECH_OFF%}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "Welcome to the %companyname%."
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
				local roster = World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([ "assassin_background" ]);

				_event.m.Dude.getBackground().m.RawDescription = "{%name% is an enigma. An assassin from the north, the man's past and goals are a mystery. A dagger appears in his hand out of nowhere and he flashes his teeth, using the point of the weapon as a toothpick. A benign gesture, somehow made terrifying by the cold, glassy look in the man's eyes. Whatever your doubts about %name%'s intentions, you certainly have no complaints regarding his skill.}";
				_event.m.Dude.getBackground().buildDescription(true);

				if (_event.m.Dude.getItems().getItemAtSlot(Const.ItemSlot.Mainhand) != null)
					_event.m.Dude.getItems().getItemAtSlot(Const.ItemSlot.Mainhand).removeSelf();

				if (_event.m.Dude.getItems().getItemAtSlot(Const.ItemSlot.Offhand) != null)
					_event.m.Dude.getItems().getItemAtSlot(Const.ItemSlot.Offhand).removeSelf();

				if (_event.m.Dude.getItems().getItemAtSlot(Const.ItemSlot.Head) != null)
					_event.m.Dude.getItems().getItemAtSlot(Const.ItemSlot.Head).removeSelf();

				if (_event.m.Dude.getItems().getItemAtSlot(Const.ItemSlot.Body) != null)
					_event.m.Dude.getItems().getItemAtSlot(Const.ItemSlot.Body).removeSelf();

				_event.m.Dude.getItems().equip(new("scripts/items/weapons/rondel_dagger"));
				_event.m.Dude.getItems().equip(new("scripts/items/armor/reinforced_leather_tunic"));

				Characters.push(_event.m.Dude.getImagePath());
				World.Assets.addMoney(-3000);
				List = [ { id = 10, icon = "ui/icons/asset_money.png", text = "You lose [color=" + Const.UI.Color.NegativeEventValue + "]3000[/color] Crowns" } ];
			}
		});

		m.Screens.push({
			ID			= "C"
			Text		= "[img]gfx/ui/events/event_55.png[/img]{You shake your head and tell the man you'll have to decline. He eyes you for an uncomfortably long moment, just long enough for you to wonder if he'll attack you, how he'll strike and from what angle, then he gives a slow nod.%SPEECH_ON%Very well, mercenary.%SPEECH_OFF%With that, he steps back, and within startlingly few paces he's melded into the terrain. You return to counting inventory, but the feeling that you're being watched stays with you for hours.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "I think we have quite enough assassins around here already, thanks."
					function getResult(_event) { return 0; }
				}
			]
			function start(_event) { }
		});
	}

	function onUpdateScore() {
		if (!Const.DLC.Desert || !Const.DLC.Paladins)
			return;

		if (World.Assets.getOrigin().getID() != "scenario.southern_assassins")
			return;

		if (World.getPlayerRoster().getSize() >= World.Assets.getBrothersMax())
			return;

		local currentTile = World.State.getPlayer().getTile();
		if (currentTile.SquareCoords.Y < World.getMapSize().Y * 0.2)
			return;

		if (World.Assets.getMoney() < 3700)
			return;

		m.Score = 6;
	}

	function onPrepare() { }

	function onPrepareVariables(_vars) {
		_vars.push([ "hirecost", "3000" ]);
	}

	function onClear() {
		m.Dude = null;
	}
});
