assassins_prophet_summons_event <- inherit("scripts/events/event", {
	m = { }

	function create() {
		m.ID		= "event.assassins_prophet_summons";
		m.Title		= "During camp...";
		m.Cooldown	= 9999.0 * World.getTime().SecondsPerDay;

		m.Screens.push({
			ID			= "A"
			Text		= "{%terrainImage%It has been some time since the Old Man on the Mountain tasked you with becoming a Crownling and exiled you from the guilds. The %companyname% has since grown into a formidable band, regarded as professionals by noble and vizier alike.  While the company has faced its share of troubles, by and large mercenary work has proven to be substantially simpler and more profitable than assassinations ever did.\n\nYou ponder what course your life might have taken had this career change happened sooner, what it might have been like outside the auspice of the guilds. Your thoughts wander into progressively more treasonous territory, and you're almost thankful when %randombrother% interrupts your reverie.%SPEECH_ON%There's someone here to see you, captain. A peculiar sort, too.%SPEECH_OFF%}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "Let's see what this is about."
					function getResult(_event) { return "B"; }
				}
			]

			function start(_event) { }
		});

		m.Screens.push({
			ID			= "B"
			Text		= "{%terrainImage%You exit your tent and are greeted by a short, robed man with a deep cowl that masks his southern complexion. He speaks in an eloquent, well-mannered tongue.%SPEECH_ON%Ah, you must be the captain. My name is Firi Al-Kashim, an emissary of the great prophet %nemesis%. He has taken notice of the %companyname%'s deeds of late, and wishes to employ your services. He beckons you to seek His audience at the Oracle, when ready. It is a great honor to draw the eye of the prophet Himself. You will surely find it worth your while to attend Him. He offers this gift as a gesture of good will, and to finance your travels.%SPEECH_OFF%The man gives you a bag full of precious gemstones and promptly leaves, satisfied that he has assured your attendance. You hand the bag to %randombrother% to put in the company stash and reflect on the news. This is it, the reason you're now a Crownling. It seems the company has the reputation it needs, but is it prepared for the fight ahead? The so-called prophet won't wait forever, but you have some time if you need to finish up other contracts or train the men further.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "We'll head to the Oracle once we're ready."
					function getResult(_event) { return 0;}
				}
			]

			function start(_event) {
				local item = new("scripts/items/loot/gemstones_item");

				World.Assets.getStash().add(item);
				List.push({ id = 10, icon = "ui/items/" + item.getIcon(), text = "You gain Gemstones" });
				World.Statistics.getFlags().set("SouthernAssassinsProphetSummonsReceived", true);

				local oracle_event = World.Events.getEvent("event.location.oracle_enter");
				oracle_event.m.CooldownUntil = Time.getVirtualTimeF();

				local locations = World.EntityManager.getLocations();
				foreach (l in locations) {
					if (l.getTypeID() == "location.holy_site.oracle")
						l.setVisited(false);
				}
			}
		});
	}

	function onUpdateScore() {
		if (!Const.DLC.Paladins || !Const.DLC.Desert)
			return;

		if (World.Assets.getOrigin().getID() != "scenario.southern_assassins")
			return;

		if (World.Statistics.getFlags().get("SouthernAssassinsProphetSummonsReceived") == true)
			return;

		if (World.Assets.getBusinessReputation() < 2250)
			return;

		m.Score = 1000;
	}

	function onPrepareVariables(_vars) {
		_vars.push([ "nemesis", World.Statistics.getFlags().get("SouthernAssassinNemesisName") ]);
	}

	function onClear() { }
});
