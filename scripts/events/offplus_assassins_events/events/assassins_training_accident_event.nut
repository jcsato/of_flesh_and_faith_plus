assassins_training_accident_event <- inherit("scripts/events/event",
{
	m =
	{
	}

	function create()
	{
		m.ID		= "event.assassins_training_accident";
		m.Title		= "During camp...";
		m.Cooldown	= 35.0 * World.getTime().SecondsPerDay;

		m.Screens.push({
							ID			= "A"
							Text		= "[img]gfx/ui/events/event_34.png[/img]{While there is much mystique surrounding the assassins of the South, ultimately what separates them from other men is rigorous training. There is no convenient drug to combat boredom while lying in ambush for hours, no special talent that makes a man able to blend into the dark - these are learned skills, honed over weeks, months, and years of hard practice.\n\nIt comes as little surprise, then, to hear that some of the men have been training a little too hard and hurt themselves in the process. One man fell from a tight rope dozens of times while trying to improve his footwork, another hasn't slept in two days attempting to better pierce the veil of the night, a third's efforts to learn arrow catching went horribly wrong. You order them to take a break and focus on recovering.}"
							Image		= ""
							List		= [ ]
							Characters	= [ ]
							Options		= [
											{
												Text = "All the training in the world won't help if you can't swing your weapon."
												function getResult(_event) { return 0; }
											}
										]
							function start(_event)
							{
								local brothers = World.getPlayerRoster().getAll();
								local speciality_candidates = [];
								foreach( bro in brothers ) {
									if (bro.getSkills().hasSkill("effects.assassin_speciality_01") || bro.getSkills().hasSkill("effects.assassin_speciality_02") || bro.getSkills().hasSkill("effects.assassin_speciality_03") || bro.getSkills().hasSkill("effects.assassin_speciality_04") || bro.getSkills().hasSkill("effects.assassin_speciality_05"))
										speciality_candidates.push(bro);
								}

								local injuredCount = 0;
								foreach( i, bro in speciality_candidates) {
									if ((injuredCount < 1 && i == speciality_candidates.len() - 1) || Math.rand(1, 100) <= 25 - (bro.getLevel() - 6)) {
										injuredCount++;
										local effect = new("scripts/skills/effects_world/exhausted_effect");
										bro.getSkills().add(effect);
										List.push({ id = 10, icon = effect.getIcon(), text = bro.getName() + " is exhausted" });
									}

									if ((injuredCount < 1 && i == speciality_candidates.len() - 1) || Math.rand(1, 100) <= 20 - (bro.getLevel() - 6)) {
										injuredCount++;
										local injury = bro.addInjury(Const.Injury.Accident1);
										List.push({ id = 10, icon = injury.getIcon(), text = bro.getName() + " suffers " + injury.getNameOnly() });
									}
								}
							}
					   });
	}

	function onUpdateScore()
	{
		if (!Const.DLC.Desert || !Const.DLC.Paladins)
			return;

		if (World.Assets.getOrigin().getID() != "scenario.southern_assassins")
			return;

		local brothers = World.getPlayerRoster().getAll();
		local speciality_candidates = [];
		foreach( bro in brothers ) {
			if (bro.getSkills().hasSkill("effects.assassin_speciality_01") || bro.getSkills().hasSkill("effects.assassin_speciality_02") || bro.getSkills().hasSkill("effects.assassin_speciality_03") || bro.getSkills().hasSkill("effects.assassin_speciality_04") || bro.getSkills().hasSkill("effects.assassin_speciality_05"))
				speciality_candidates.push(bro);
		}

		if (speciality_candidates.len() < 3)
			return;

		m.Score = Math.min(2 * speciality_candidates.len(), 18);
	}

	function onPrepare() { }

	function onPrepareVariables(_vars) { }

	function onClear() { }
})