ironhand_dream_01_event <- inherit("scripts/events/event", {
	m = {
		Chosen = null
	}

	function create() {
		m.ID		= "event.ironhand_dream_01";
		m.Title		= "During camp...";
		m.Cooldown	= 99999.0 * World.getTime().SecondsPerDay;

		m.Screens.push({
			ID			= "A"
			Text		= "[img]gfx/ui/events/event_39.png[/img]{You sit in camp in front of the fire, your hands tented atop your sword, and you stare into the flames and they stare back at you. You feel yourself pulled into them, then under them, deep into the earth, under the winding roots and the bugs and the dirt until you find yourself in a vast nothing.\n\n%randombarbarianname%, your first true friend, bars the way in front of you. You fight. You win. A smile on his face, your first time carving a rune, the tears of joy and sorrow and victory clouding your vision, the sense of completeness as you took his rune into you and felt his strength course through your veins.\n\nYou look up and there is Old Ironhand, hunched over his gnarled staff and cowled, pointing a bony finger to the horizon. You turn to the direction he points and see a swirling blue light, infinitely distant, yet just out of reach. Now the Scorched Tribe stands in your way, now Hafgufa the Chosen, now the sacking of %randomtown% - every conquest, every death, every rune brings you closer to that light, yet you cannot fathom what distance remains. The only constant is Old Ironhand, his wizened body and his pointed finger, urging you to ever greater heights.\n\nYou awake slowly, deliberately, allowing the haze of the vision to fall away gradually as you return to the surface. The fire is long dead, ash in its place. %chosen% comes up to you excitedly and tells you he saw a vision from Old Ironhand himself, a sure sign that the %companyname% are his favored chosen. You smile and tell him you saw it too, and soon the whole company is speaking of dreams and good omens.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "And mine death I shall visit upon Ironhand's foes."
					function getResult(_event) { return 0; }
				}
			]

			function start(_event) {
				local brothers = World.getPlayerRoster().getAll();
				local rune_candidates = [];

				foreach (bro in brothers) {
					if (bro.getSkills().hasSkill("effects.rune_01") || bro.getSkills().hasSkill("effects.rune_02") || bro.getSkills().hasSkill("effects.rune_03") || bro.getSkills().hasSkill("effects.rune_04") || bro.getSkills().hasSkill("effects.rune_05") || bro.getSkills().hasSkill("effects.rune_06") || bro.getSkills().hasSkill("effects.rune_07")) {
						bro.getBaseProperties().Bravery += 1;
						bro.getSkills().update();

						List.push({ id = 16, icon = "ui/icons/bravery.png", text = bro.getName() + " gains [color=" + Const.UI.Color.PositiveEventValue + "]+1[/color] Resolve" });
						bro.improveMood(0.5, "Had a dream of good omen");
					}
				}

				World.Statistics.getFlags().set("RuneKnightsDreamStage", 1);
			}
		});
	}

	function onUpdateScore() {
		if (!Const.DLC.Wildmen || !Const.DLC.Paladins)
			return;

		if (World.Assets.getOrigin().getID() != "scenario.runeknights")
			return;

		if (World.Statistics.getFlags().getAsInt("RuneKnightsDreamStage") != 0)
			return;

		local brothers = World.getPlayerRoster().getAll();
		local rune_candidates = [];

		foreach (bro in brothers) {
			if (bro.getFlags().getAsInt("numActiveRunes") >= 1)
				rune_candidates.push(bro);
		}

		if (rune_candidates.len() < 3)
			return;

		m.Chosen = rune_candidates[Math.rand(0, rune_candidates.len() - 1)];
		m.Score = 5 * rune_candidates.len();
	}

	function onPrepareVariables(_vars) {
		_vars.push([ "randombarbarianname", Const.Strings.BarbarianNames[Math.rand(0, Const.Strings.BarbarianNames.len() - 1)]]);
		_vars.push([ "chosen", m.Chosen.getName() ]);
	}

	function onClear() {
		m.Chosen = null;
	}
});
