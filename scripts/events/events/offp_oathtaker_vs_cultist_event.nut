offp_oathtaker_vs_cultist_event <- inherit("scripts/events/event", {
	m = {
		Cultist	= null
		Oathtaker	= null
	}

	function create() {
		m.ID		= "event.offp_oathtaker_vs_cultist";
		m.Title		= "During camp...";
		m.Cooldown	= 9999.0 * World.getTime().SecondsPerDay;

		m.Screens.push({
			ID			= "A"
			Text		= "[img]gfx/ui/events/event_05.png[/img]{To your surprise, you find %cultist% and %oathtaker% engaged in discussion. While your understanding of the oathtaker's religion is shaky at best, you do understand it to be at least loosely aligned with the tenants of the old gods, whereas the cultist's almost seems to revel in its defiance of those same tenants.\n\nYou wonder if perhaps you should break this off before the men discover they have less common ground than they might think.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "This could be interesting. Let them talk."
					function getResult(_event) { return Math.rand(1, 100) <= 65 ? "B" : "C"; }
				},
				{
					Text = "Alright, back to work with you."
					function getResult(_event) { return 0; }
				}
			]

			function start(_event) {
				Characters.push(_event.m.Oathtaker.getImagePath());
				Characters.push(_event.m.Cultist.getImagePath());
			}
		});

		m.Screens.push({
			ID			= "B"
			Text		= "[img]gfx/ui/events/event_05.png[/img]{You decide to let the men hash things out without your supervision. After some time passes you come back to check on them, and just as you do %oathtaker% leaps up with a jubilant cry.%SPEECH_ON%I knew it! You speak of the Oath of Death! My brothers doubted me, but what you have said gives me all the confirmation I need! Wait for me, Young Anselm, this servant shall follow you! I must go re-examine the scriptures right away!%SPEECH_OFF%%cultist% is, for the first time you can recall, caught off guard.%SPEECH_ON%No, that's not what I was saying at al-%SPEECH_OFF%The oathtaker careens off to his tent before the cultist can finish. Seeing you, the remaining man quickly regains his composure.%SPEECH_ON%Ah, captain. I'm confident he'll come around to see that it is Davkul he has always sought to serve, not this 'Anselm' he clings to. He just needs some more time.%SPEECH_OFF%}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "Sure, you tell yourself that."
					function getResult(_event) { return 0;}
				}
			]

			function start(_event) {
				Characters.push(_event.m.Oathtaker.getImagePath());
				Characters.push(_event.m.Cultist.getImagePath());

				local trait = new("scripts/skills/traits/oath_of_death_trait");

				_event.m.Oathtaker.getSkills().add(trait);
				List.push( { id = 10, icon = trait.getIcon(), text = _event.m.Oathtaker.getName() + " has taken on an Oath of Death" } );

				_event.m.Cultist.worsenMood(0.5, "A potential convert mistook Davkul for some dead guy");
				_event.m.Oathtaker.improveMood(0.5, "Found an excuse to follow the Oath of Death");
			}
		});

		m.Screens.push({
			ID			= "C"
			Text		= "[img]gfx/ui/events/event_05.png[/img]{You decide to let the men have their conversation and go to count inventory. Within minutes you hear the sounds of shouting in camp. Groaning, you return to find the oathtaker bellowing at a confused %cultist%.%SPEECH_ON%I knew it, you swine. You wretch! You speak of the Oath of Death! I'll not suffer your heathen Oathbringer codices!%SPEECH_OFF%The cultist manages to utter,%SPEECH_ON%No, I-%SPEECH_OFF%Then the oathtaker is upon him, pummeling the man and screaming something about Young Anselm's valor. You and the rest of the company manage to pull them apart, and you try to explain to %oathtaker% that the cultist's religion is wholly separate from whatever creed the oathbringers follow. The man stares into the space in front of him, shaking.%SPEECH_ON%I...I see, captain. I apologize, I just couldn't bear the thought of someone peddling those awful men's false scriptures in camp. The horror of it!%SPEECH_OFF%}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "Keep it together, man."
					function getResult(_event) { return 0;}
				}
			]

			function start(_event) {
				Characters.push(_event.m.Oathtaker.getImagePath());
				Characters.push(_event.m.Cultist.getImagePath());

				local injury = _event.m.Cultist.addInjury(Const.Injury.Brawl);
				List.push( { id = 10, icon = injury.getIcon(), text = _event.m.Cultist.getName() + " suffers " + injury.getNameOnly() } );

				_event.m.Oathtaker.addLightInjury();
				List.push({ id = 10, icon = "ui/icons/days_wounded.png", text = _event.m.Oathtaker.getName() + " suffers light wounds" });

				_event.m.Cultist.worsenMood(1.0, "Was assaulted while trying to proselytize");
				_event.m.Oathtaker.worsenMood(1.0, "Thought someone tried to preach oathbringer beliefs to him");
			}
		});
	}

	function onUpdateScore() {
		if (!Const.DLC.Paladins)
			return;

		// Disable for OFF+ v2.x Oathtakers
		if (World.Assets.getOrigin().getID() == "scenario.oathtakers" || World.Assets.getOrigin().getID() == "scenario.cultists")
			return;

		local brothers = World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
			return;

		local cultist_candidates = [];
		local oathtaker_candidates = [];

		foreach (bro in brothers) {
			if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
				cultist_candidates.push(bro);
			else if (bro.getBackground().getID() == "background.paladin")
				oathtaker_candidates.push(bro);
		}

		if (cultist_candidates.len() == 0 || oathtaker_candidates.len() == 0)
			return;

		m.Cultist = cultist_candidates[Math.rand(0, cultist_candidates.len() - 1)];
		m.Oathtaker = oathtaker_candidates[Math.rand(0, oathtaker_candidates.len() - 1)];
		m.Score = 5;
	}

	function onPrepareVariables(_vars) {
		_vars.push([ "cultist", m.Cultist.getName() ]);
		_vars.push([ "oathtaker", m.Oathtaker.getName() ]);
	}

	function onClear() { }
});
