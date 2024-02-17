ironhand_dream_03_event <- inherit("scripts/events/event", {
	m = {
		Chosen = null
	}

	function create() {
		m.ID		= "event.ironhand_dream_03";
		m.Title		= "During camp...";
		m.Cooldown	= 99999.0 * World.getTime().SecondsPerDay;

		m.Screens.push({
			ID			= "A"
			Text		= "[img]gfx/ui/events/event_39.png[/img]{You're unable to sleep. After tossing and turning for a time you admit defeat and get up, only to find that outside your tent is not the camp, but a desolate heath bathed in dusk. Plumes of smoke rise on the horizon, and all around you see the enemies of man. Shadowy creatures running from knoll to knoll on all fours, rabid hunger in their eyes. Orc war parties blighting the lands upon which they walk while goblins stalk the sidelines. Gross approximations of men rise from the ground, bone and rotting flesh and mindless drive. Old Ironhand sits down on a stoop beside you.%SPEECH_ON%Mine enemies and mine folly. Each held such promise, each delivered such disappointment.%SPEECH_OFF%He sweeps a bony arm across the heath.%SPEECH_ON%Once I thought that beasts could inherit mine will, so singular and savage are they. Yet granting them purpose was only hunger, hunger and fear. The many-legs cowered and ran, the tree-men shut their ears, and the giants thought their own schemes more important.\n\nThe green-man could hath taken on the burden, but he lacked fortitude of mind. Not a creature of fear, no, but of complete selfishness. He hath no ambition beyond what he sees in the world hither, no concept of the greater plan.%SPEECH_OFF%Ironhand begins to tremble with anger.%SPEECH_ON%And worst, the dead-but-living. Once I thought them the truest strength, a death everlasting, yet I found only betrayal and treason in the old bones, loyalty to one who hath long lost right!%SPEECH_OFF%He turns to you suddenly, his un-pupiled eyes flashing from white to red to white, his beard swaying, his body wracked with anger.%SPEECH_ON%Tis only thee, mine chosen, that inherits mine will! Tis only thee that understands the purpose of life, the power of death! Tis only thee that can serve the greater plan! Go now! Visit thine death upon mine foes, and in thine death make them see the wrath of Ironhand!%SPEECH_OFF%You awaken with a start. You find a number of the men had similar visions, a newfound rage for the old god's enemies burning within them.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "And mine death I shall visit upon Ironhand's foes!"
					function getResult(_event) { return 0; }
				}
			]

			function start(_event) {
				local brothers = World.getPlayerRoster().getAll();
				local rune_candidates = [];

				foreach (bro in brothers) {
					if (bro.getSkills().hasSkill("effects.rune_01") || bro.getSkills().hasSkill("effects.rune_02") || bro.getSkills().hasSkill("effects.rune_03") || bro.getSkills().hasSkill("effects.rune_04") || bro.getSkills().hasSkill("effects.rune_05") || bro.getSkills().hasSkill("effects.rune_06") || bro.getSkills().hasSkill("effects.rune_07"))
						rune_candidates.push(bro);
				}

				foreach (bro in rune_candidates) {
					local fear_removed = false;

					if (bro.getSkills().hasSkill("trait.fear_undead")) {
						bro.getSkills().removeByID("trait.fear_undead");
						List.push( { id = 10, icon = trait.getIcon(), text = bro.getName() + " no longer fears the undead" } );
						fear_removed = true;
					} else if (bro.getSkills().hasSkill("trait.fear_greenskins")) {
						bro.getSkills().removeByID("trait.fear_greenskins");
						List.push( { id = 10, icon = trait.getIcon(), text = bro.getName() + " no longer fears greenskins" } );
						fear_removed = true;
					} else if (bro.getSkills().hasSkill("trait.fear_beasts")) {
						bro.getSkills().removeByID("trait.fear_beasts");
						List.push( { id = 10, icon = trait.getIcon(), text = bro.getName() + " no longer fears beasts" } );
						fear_removed = true;
					}

					if (!fear_removed && !(bro.getSkills().hasSkill("trait.hate_undead") && bro.getSkills().hasSkill("trait.hate_greenskins") && bro.getSkills().hasSkill("trait.hate_beasts"))) {
						local hate_traits = [ "hate_undead", "hate_greenskins", "hate_beasts" ];
						local r = Math.rand(0, hate_traits.len() - 1);
						local hate_applied = false;

						while (!hate_applied) {
							if (!bro.getSkills().hasSkill("trait." + hate_traits[r])) {
								local trait = new("scripts/skills/traits/" + hate_traits[r] + "_trait");
								bro.getSkills().add(trait);
								local enemy_name = "the undead";
								if (r == 1)
									enemy_name = "greenskins";
								else if (r == 2)
									enemy_name = "beasts";

								List.push( { id = 10, icon = trait.getIcon(), text = bro.getName() + " now hates " + enemy_name } );
								hate_applied = true;
							}
						}
					}
				}

				World.Statistics.getFlags().set("RuneKnightsDreamStage", 3);
			}
		});
	}

	function onUpdateScore() {
		if (!Const.DLC.Wildmen || !Const.DLC.Paladins)
			return;

		if (World.Assets.getOrigin().getID() != "scenario.runeknights")
			return;

		if (World.Statistics.getFlags().getAsInt("RuneKnightsDreamStage") != 2)
			return;

		local brothers = World.getPlayerRoster().getAll();
		local rune_candidates = [], veteran_rune_candidates = [], elite_rune_candidates = [];

		foreach (bro in brothers) {
			if (bro.getFlags().getAsInt("numActiveRunes") >= 5)
				elite_rune_candidates.push(bro);
			else if (bro.getFlags().getAsInt("numActiveRunes") >= 3)
				veteran_rune_candidates.push(bro);
			else if (bro.getFlags().getAsInt("numActiveRunes") >= 1)
				rune_candidates.push(bro);
		}

		local candidates_sum = elite_rune_candidates.len() + veteran_rune_candidates.len() + rune_candidates.len();
		if (elite_rune_candidates.len() < 1 && candidates_sum < 7)
			return;

		m.Score = 4 * candidates_sum;
	}

	function onPrepare() { }

	function onPrepareVariables(_vars) { }

	function onClear() { }
});
