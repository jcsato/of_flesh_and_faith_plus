explorers_legendary_location_rumor_event <- inherit("scripts/events/event", {
	m = {
		Location	= null
	}

	function create() {
		m.ID		= "event.explorers_legendary_location_rumor";
		m.Title		= "Along the way...";
		m.Cooldown	= 99999.0 * World.getTime().SecondsPerDay;

		m.Screens.push({
			ID			= "A"
			Text		= "[img]gfx/ui/events/event_23.png[/img]{While the Pillager Rot has robbed you of many comforts the common man takes for granted, perhaps the most important remains within your reach - that of a full tankard of ale and the heady truth promised by its depths. As such, when you come across a tiny collection of hovels masquerading as a roadside village, the first thing you look for is a tavern, and upon sighting one, you make a beeline for it.\n\nThe interior is decidedly dingy, with a few feeble candles lighting the place and even fewer, feebler patrons scattered about, strategically sitting as far away from each other as possible. They shrink back even as they notice your entrance, clearly wanting to be left alone, except for one man who gets up and begins drunkenly stumbling towards the bar. The extent of his inebriation gives you hope that the drinks here might be worth having, but you're as unlucky as ever and he begins hollering at you before you can get the barkeep's attention.%SPEECH_ON%Oi! Oi, you! You lot are the %companyname%, those ex...explorber-types, yeah? I reckonize yer. You know I used to be an explorer meself, 'afore the Battle o' Names gimped me leg.%SPEECH_OFF%The man expertly sprawls himself across three chairs and half the bar. You've been completely cut off from the barkeep. You let a whimper escape your lips as the man begins droning on about his past exploits, imagined and real, and for a brief moment you finger the hilt of your sword and imagine how easy it would be to remove this obstacle by force and become the sot you deserve to be. But then the drunk says something that catches your interest.%SPEECH_ON%...'Twas the darndest thing, a tree with a boat 'stead o' leaves. A big 'un, too, a proper ga-hic!-galley. How does that happen? I never went in cuz' something seemed off about it, but it's dwelled in me memory e'er since. 'Twas %terrain% to the %direction%, some...some ways off.%SPEECH_OFF%With that, the man's head drops and he begins snoring even louder than %randombrother%. You decide the drink can wait for another day - it might just be another tall tale, but something tells you this drunken rumor might be worth following up on.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "We should explore to the %direction% when we can."
					function getResult(_event) { return 0; }
				}
			]

			function start(_event) { }
		});
	}

	function onUpdateScore() {
		if (!Const.DLC.Unhold || !Const.DLC.Paladins)
			return;

		if (World.Assets.getOrigin().getID() != "scenario.explorers")
			return;

		local currentTile = World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
			return;

		if (World.Assets.getBusinessReputation() < 1050)
			return;

		local towns = World.EntityManager.getSettlements();
		local nearTown = false;
		local playerTile = World.State.getPlayer().getTile();

		foreach (t in towns) {
			if (t.getTile().getDistanceTo(playerTile) <= 2) {
				nearTown = true;
				break;
			}
		}

		if (nearTown)
			return;

		local locations = World.EntityManager.getLocations();
		foreach (l in locations) {
			if (l.getTypeID() == "location.land_ship" && !l.isVisited()) {
				m.Location = l;
				break;
			}
		}

		if (m.Location == null)
			return;

		m.Score = 15;
	}

	function onPrepare() { }

	function onPrepareVariables(_vars) {
		_vars.push( [ "direction", m.Location == null || m.Location.isNull() ? "" : Const.Strings.Direction8[World.State.getPlayer().getTile().getDirection8To(m.Location.getTile())] ] );
		_vars.push( [ "terrain", m.Location != null && !m.Location.isNull() ? Const.Strings.Terrain[m.Location.getTile().Type] : "" ] );
	}

	function onClear() {
		m.Location	= null;
	}
});
