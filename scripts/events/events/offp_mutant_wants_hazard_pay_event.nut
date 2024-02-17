offp_mutant_wants_hazard_pay_event <- inherit("scripts/events/event", {
	m = {
		Mutant	= null
	}

	function create() {
		m.ID		= "event.offp_mutant_wants_hazard_pay";
		m.Title		= "In camp...";
		m.Cooldown	= 40.0 * World.getTime().SecondsPerDay;

		m.Screens.push({
			ID			= "A"
			Text		= "[img]gfx/ui/events/event_64.png[/img]{%mutant% steps into your tent and crosses his arms, his many mutations causing him to cut a figure as intimidating as it is comical. The look on his face suggests this isn't just a social visit.%SPEECH_ON%I want more.%SPEECH_OFF%You raise an eyebrow.%SPEECH_ON%Oh, come off it, captain. You know what I mean and you know I've earned it twofold. Look at me. I'm barely human anymore. No one could ask of another man what the company has asked of me, but I've done it. I've taken every one of those damned mutations, fought through the fever and the pains I never even knew the body could make, and I'm still here. Now it's the company's turn to do right by me. We both know you can't afford to lose me at this point.%SPEECH_OFF%The man, unfortunately, has a point. If he left, if would be a severe setback to the company's research, not to mention it's battle strength. You ask the man how much.%SPEECH_ON%1,000 crowns of hazard pay now, and 10 more a day going forward.%SPEECH_OFF%}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "We can't afford to lose you. Very well."
					function getResult(_event) { return "B"; }
				},
				{
					Text = "That's not happening."
					function getResult(_event) { return "C"; }
				}
			]

			function start(_event) {
				Characters.push(_event.m.Mutant.getImagePath());
			}
		});

		m.Screens.push({
			ID			= "B"
			Text		= "[img]gfx/ui/events/event_64.png[/img]{You sigh and acquiesce, tossing the man a hefty pouch of gold.%SPEECH_ON%That's a lot of crowns. What exactly are you planning on even doing with it?%SPEECH_OFF%The man shrugs.%SPEECH_ON%Was thinking I might see myself to a whorehouse. You'd be surprised how much they cost when you're, well, like this.%SPEECH_OFF%He spreads his arms and motions to his bizarre assemblage.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "Fair enough."
					function getResult(_event) { return 0; }
				}
			]

			function start(_event) {
				Characters.push(_event.m.Mutant.getImagePath());

				World.Assets.addMoney(-1000);
				List.push({ id = 10, icon = "ui/icons/asset_money.png", text = "You spend [color=" + Const.UI.Color.NegativeEventValue + "]1000[/color] Crowns" });

				_event.m.Mutant.getBaseProperties().DailyWage += 10;
				_event.m.Mutant.getSkills().update();

				List.push( { id = 10, icon = "ui/icons/asset_daily_money.png", text = _event.m.Mutant.getName() + " is now paid " + _event.m.Mutant.getDailyCost() + " crowns a day" } );
			}
		});

		m.Screens.push({
			ID			= "C"
			Text		= "[img]gfx/ui/events/event_64.png[/img]{The man's a valuable part of the company, but you can't exactly cave to his demands; if the other men followed the precedent it sets, you'd be bankrupt in no time.\n\nYou tell %mutant% he'll receive more pay when his experience demands it, not when he does. He wordlessly fumes and stomps out. You check in later and discover his tent empty, the mutated mercenary nowhere to be found.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "Damn."
					function getResult(_event) { return 0; }
				}
			]

			function start(_event) {
				Characters.push(_event.m.Mutant.getImagePath());

				List.push( { id = 13, icon = "ui/icons/kills.png", text = _event.m.Mutant.getName() + " leaves the " + World.Assets.getName() } );

				_event.m.Mutant.getItems().transferToStash(World.Assets.getStash());
				_event.m.Mutant.getSkills().onDeath(Const.FatalityType.None);

				World.getPlayerRoster().remove(_event.m.Mutant);
			}
		});
	}

	function onUpdateScore() {
		if (!Const.DLC.Paladins)
			return;

		if (World.Assets.getOrigin().getID() != "scenario.anatomists")
			return;

		if (World.Assets.getMoney() < 1500)
			return;

		local brothers = World.getPlayerRoster().getAll();
		local mutantCandidates = [];

		foreach (bro in brothers) {
			if (bro.getFlags().getAsInt("ActiveMutations") > 5)
				mutantCandidates.push(bro);
		}

		if (mutantCandidates.len() == 0)
			return;

		m.Mutant = mutantCandidates[Math.rand(0, mutantCandidates.len() - 1)];
		m.Score = Math.max(0, m.Mutant.getFlags().getAsInt("ActiveMutations") - 3);
	}

	function onPrepare() { }

	function onPrepareVariables(_vars) {
		_vars.push([ "mutant", m.Mutant.getName() ]);
	}

	function onClear() {
		m.Mutant	= null;
	}
});
