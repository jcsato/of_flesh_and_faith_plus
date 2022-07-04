bros_contract_rot_event <- inherit("scripts/events/event",
{

	m =
	{
	}

	function create()
	{
		m.ID		= "event.bros_contract_rot";
		m.Title		= "During camp...";
		m.IsSpecial = true;

		// Screen A
		m.Screens.push({
							ID			= "A"
							Text		= "[img]gfx/ui/events/event_18.png[/img]{You meander through camp to take stock of the men, and to your dismay find that the Rot has taken firmer hold of the %companyname%. %randombrother% is vomiting his guts out in a corner, black bile spewing onto the ground, and a number of the other men have had a truly depressing variety of new rashes, maladies, and ailments manifest. The men are understandably glum. | %randombrother% enters your tent, stifling a cough as he does.%SPEECH_ON%Sir, you should come take a look at this.%SPEECH_OFF%Around the camp men are wailing and groaning, scratching their throats and retching and generally existing in a state of newfound misery. It seems the Rot has claimed more victims. | It seems the Pillager Rot has lived up to its name once again, having picked the %companyname%'s camp as the target for its latest raid. You find the men incapacitated to varying degrees, doubled over and scratching themselves furiously and drenched in sweat, and mysterious black boils have broken out on %randombrother%'s skin. Some of the men are definitely regretting the choices that led them here, and mood in the camp is generally dour. | You find %randombrother% wheezing uncontrollably. He looks at you, attempting to form a sentence, but can't get the words out. Giving up, he points you to a nearby tent where you find several of the other men are writhing on the ground, nursing ailments and plagues that came over them in the night. Your fears are confirmed when you see blackened veins pulsate under one man's skin; the Rot has come for the %companyname% again.}"
							Image		= ""
							List		= [ ]
							Characters	= [ ]
							Options		= [
											{
												Text = "{We have to find a cure soon. | Bad news, indeed. | Fark the Rot! | All the more reason to find a cure.}"
												function getResult(_event) { return 0;}
											},
										  ]

							function start(_event)
							{
								local brothers = World.getPlayerRoster().getAll();
								foreach( bro in brothers ) {
									if (Time.getVirtualTimeF() - bro.getHireTime() <= World.getTime().SecondsPerDay * 2.0)
										continue;

									if (bro.getFlags().getAsInt("CursedExplorersRotsActive") < 5 && Math.rand(1, 100) <= (100 - bro.getFlags().getAsInt("CursedExplorersRotsActive") * 10)) {
										local rotApplied = false;
										local numRotsApplied = 0;
										local rots = [ "rot_01_trait", "rot_02_trait", "rot_03_trait", "rot_04_trait", "rot_05_trait" ];
										local rotEffect = new("scripts/skills/traits/" + rots[Math.rand(0, rots.len() - 1)]);

										while(!rotApplied) {
											if (!bro.getSkills().hasSkill(rotEffect.getID())) {
												bro.getSkills().add(rotEffect);
												List.insert(numRotsApplied++, { id = 10, icon = rotEffect.getIcon(), text = bro.getName() + " now has " + rotEffect.getName() });
												rotApplied = true;
											} else {
												rotEffect = new("scripts/skills/traits/" + rots[Math.rand(0, rots.len() - 1)]);
											}
										}
									}

									bro.worsenMood(1.0, "Suffers from the Pillager Rot");

									if (bro.getMoodState() < Const.MoodState.Neutral)
										List.push({ id = 11, icon = Const.MoodStateIcon[bro.getMoodState()], text = bro.getName() + Const.MoodStateEvent[bro.getMoodState()] });
								}

								World.Statistics.getFlags().set("CursedExplorersLastRotEvent", World.getTime().Days);
							}
					   });
	}

	function isValid()
	{
		if (!Const.DLC.Paladins || !Const.DLC.Unhold)
			return false;

		if (World.Assets.getOrigin().getID() != "scenario.explorers")
			return false;

		if (World.Statistics.getFlags().get("CursedExplorersRotCured"))
			return false;

		if (Time.getVirtualTimeF() - World.Events.getLastBattleTime() < 5.0)
			return false;

		if (World.getTime().Days > World.Statistics.getFlags().getAsInt("CursedExplorersLastRotCheckedDay"))
		{
			World.Statistics.getFlags().set("CursedExplorersLastRotCheckedDay", World.getTime().Days);

			if (Math.rand(1, 100) <= 25 * (World.getTime().Days - World.Statistics.getFlags().getAsInt("CursedExplorersLastRotEvent") - 8))
				return true;
		}

		return false;
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepareVariables(_vars)
	{
	}

	function onClear()
	{
	}
})
