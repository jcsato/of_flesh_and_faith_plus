explorers_anatomist_joins_event <- inherit("scripts/events/event",
{
	m =
	{
		Dude = null
		Name = ""
	}

	function create()
	{
		m.ID		= "event.explorers_anatomist_joins";
		m.Title		= "Along the way...";
		m.Cooldown	= 100.0 * World.getTime().SecondsPerDay;

		m.Screens.push({
							ID			= "A"
							Text		= "[img]gfx/ui/events/event_184.png[/img]{A peculiar fellow a bit up the road calls out to you and shambles in your direction. Scrolls and potions and journals practically spills out of his pockets, and one would almost think him some sort of scalpel monger, so many adorn him packs and bags. Slightly out of breath from his ambling, he addresses you directly.%SPEECH_ON%Ah, you must be the captain of the %companyname%. I have been seeking you out for some time. You are the mercenary company afflicted by the malady colloquially known as the Pillager Rot, yes?%SPEECH_OFF%You grunt a confirmation, but put a hand on your sword. You're in no mood for another lecture on how the Rot is righteous punishment for some imagined transgression - or whatever other theories the imagination puts forth. The man either doesn't notice or doesn't care.%SPEECH_ON%Excellent, excellent. My name is %anatomist%, an anatomist. Most of my colleagues are in academia, but the most hardy - like myself - are more resourceful in our studies. I myself have some experience as a barber surgeon, and if I say so myself I'm rather good with a scalpel, well any blade really, even thrown-%SPEECH_OFF%You interrupt and tell the man to cut to the chase. He awkwardly coughs.%SPEECH_ON%I wish to study you. The Rot is a dread disease because it is so poorly understood, and it is exceedingly difficult to find live specimens-er, carriers, yes, carriers, in the halls of academia. No qualified researcher has yet taken up the mantle of field work, either, and so the affliction remains firmly in the realm of superstition and fantasy. I wish to change that. If you allow me to examine you and your men, I'm prepared to offer you what care I can and even fight for you, provided of course I am given a fair wage, board, proper research space, materials...%SPEECH_OFF%You tune out the growing list of material requirements and consider the offer.}"
							Image		= ""
							List		= [ ]
							Characters	= [ ]
							Options		= [
											{
												Text = "Very well, join us."
												function getResult(_event) { return "B"; }
											},
											{
												Text = "We're not interested."
												function getResult(_event) { return 0; }
											}
										]
							function start(_event) {
								local roster = World.getTemporaryRoster();
								_event.m.Dude = roster.create("scripts/entity/tactical/player");
								_event.m.Dude.setStartValuesEx([ "anatomist_background" ]);
								_event.m.Dude.getBackground().m.RawDescription = "%name% joined you, he claims, to better study the Pillager Rot up close. The man has a tendency both to unnerve and to get on the nerves of the rest of the company, but when all's said and done you can't fault the man's bravery or his dedication to his craft. Few would risk contracting the Rot, knowing it like %name% does.";
								_event.m.Dude.getBackground().buildDescription(true);

								_event.m.Dude.getSkills().removeByID("trait.craven");
								_event.m.Dude.getSkills().removeByID("trait.fainthearted");
								local trait = new("scripts/skills/traits/fearless_trait");								
								_event.m.Dude.getSkills().add(trait);

								Characters.push(_event.m.Dude.getImagePath());
							}
						});
		m.Screens.push({
							ID			= "B"
							Text		= "[img]gfx/ui/events/event_184.png[/img]{You interrupt the man and explain that if he travels with you it's almost guaranteed he'll take on the Rot too. He looks you square in the eye.%SPEECH_ON%Field work comes with risk, that is why most avoid it - and precisely why it is so important. I'm prepared for what is to come, Captain.%SPEECH_OFF%You shrug and offer your hand to welcome him aboard. He shakes it without hesitation.}"
							Image		= ""
							List		= [ ]
							Characters	= [ ]
							Options		= [
											{
												Text = "I'm not funding a laboratory, though."
												function getResult(_event)
												{
													World.getPlayerRoster().add(_event.m.Dude);
													World.getTemporaryRoster().clear();
													_event.m.Dude.onHired();
													_event.m.Dude = null;
													return 0;
												}
											}
										]
							function start(_event)
							{
								Characters.push(_event.m.Dude.getImagePath());
							}
						});
	}

	function onUpdateScore()
	{
		if(!Const.DLC.Unhold || !Const.DLC.Paladins)
			return;

		if(World.Assets.getOrigin().getID() != "scenario.explorers")
			return;

		if(World.getPlayerRoster().getSize() >= World.Assets.getBrothersMax())
			return;

		local currentTile = World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
			return;

		if(World.Assets.getBusinessReputation() < 1050)
			return;

		m.Name = Const.Strings.CharacterNames[Math.rand(0, Const.Strings.CharacterNames.len() - 1)];
		m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables(_vars)
	{
		_vars.push([ "anatomist", m.Name ]);
	}

	function onClear()
	{
		m.Dude = null;
		m.Name = "";
	}
})