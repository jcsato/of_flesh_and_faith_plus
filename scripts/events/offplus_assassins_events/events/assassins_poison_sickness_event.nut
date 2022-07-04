assassins_poison_sickness_event <- inherit("scripts/events/event",
{
	m =
	{
	}

	function create()
	{
		m.ID		= "event.assassins_poison_sickness";
		m.Title		= "During camp...";
		m.Cooldown	= 24.0 * World.getTime().SecondsPerDay;

		m.Screens.push({
							ID			= "A"
							Text		= "[img]gfx/ui/events/event_18.png[/img]{The assassin's arts are inherently dangerous, and few moreso than poisoncraft. It doesn't come as much of a surprise, then, to find that some of the men have fallen prey to their own toxins. The usual precautions were taken and it looks like no permanent damage was done, but they'll be sick and unable to fight effectively for some time. | While you cannot deny the effectiveness of poisons in battle, you do find yourself occasionally wondering if they're not more trouble than they're worth. Lately it seems a number of the men haven't been appropriately cautious and have fallen sick, afflicted by their own poisons. It will take some time for them to recover to full combat readiness.}"
							Image		= ""
							List		= [ ]
							Characters	= [ ]
							Options		= [
											{
												Text = "An unfortunate occupational hazard."
												function getResult(_event) { return 0; }
											}
										]
							function start(_event)
							{
								local brothers = World.getPlayerRoster().getAll();
								local poison_candidates = [];
								foreach( bro in brothers ) {
									if (bro.getSkills().hasSkill("effects.assassin_poison_01") || bro.getSkills().hasSkill("effects.assassin_poison_02") || bro.getSkills().hasSkill("effects.assassin_poison_03") || bro.getSkills().hasSkill("effects.assassin_poison_04") || bro.getSkills().hasSkill("effects.assassin_poison_05"))
										poison_candidates.push(bro);
								}

								local sickCount = 0;
								foreach( i, bro in poison_candidates) {
									if ((sickCount < 1 && i == poison_candidates.len() - 1) || Math.rand(1, 100) <= 20 - (bro.getLevel() - 3)) {
										sickCount++;
										local effect = new("scripts/skills/injury/sickness_injury");
										bro.getSkills().add(effect);
										List.push({ id = 10, icon = effect.getIcon(), text = bro.getName() + " is sick" });
									}
								}
							}
					   });
	}

	function onUpdateScore()
	{
		if (!Const.DLC.Desert || !Const.DLC.Paladins)
			return;

		if(World.Assets.getOrigin().getID() != "scenario.southern_assassins")
			return;

		local brothers = World.getPlayerRoster().getAll();
		local poison_candidates = [];
		foreach( bro in brothers ) {
			if (bro.getSkills().hasSkill("effects.assassin_poison_01") || bro.getSkills().hasSkill("effects.assassin_poison_02") || bro.getSkills().hasSkill("effects.assassin_poison_03") || bro.getSkills().hasSkill("effects.assassin_poison_04") || bro.getSkills().hasSkill("effects.assassin_poison_05"))
				poison_candidates.push(bro);
		}

		if (poison_candidates.len() < 2)
			return

		m.Score = Math.min(2 * poison_candidates.len(), 15);
	}

	function onPrepare()
	{
	}

	function onPrepareVariables(_vars)
	{
	}

	function onClear()
	{
	}
})