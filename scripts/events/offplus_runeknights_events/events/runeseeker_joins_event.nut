runeseeker_joins_event <- inherit("scripts/events/event",
{
	m =
	{
		Dude = null
	}

	function create()
	{
		m.ID		= "event.runeseeker_joins";
		m.Title		= "Along the way...";
		m.Cooldown	= 35.0 * World.getTime().SecondsPerDay;

		m.Screens.push({
							ID			= "A"
							Text		= "%terrainImage%{A lone man approaches you from the wilderness. You look him up in down. He hulks like a beast, adorned in furs and tribal symbols, yet seems tiny and featureless against the expanse of the northern wastes. He stops several paces away and speaks in a voice that sounds like it's never been used.%SPEECH_ON%Old Ironhand's chosen?%SPEECH_OFF%You nod, subtly motioning for the men to make ready for a fight. Even among the northmen, those who know Ironhand's name bear few intentions towards his followers other than murder. He shows no hostility, however, instead lowering his head slightly.%SPEECH_ON%I seek the end. It is proper to seek alongside a rune carver, should I fall in obscurity. Will you have me?%SPEECH_OFF% | Barbarians are a dangerous folk, even to their own kind. This holds doubly true for those who besmirch the ancestors in favor of their own glory, as Old Ironhand's followers are oft accused of. As such, you're not quite sure what to expect when a northman stops you on the road, but as you reach for your sword he surprises you with a parley.%SPEECH_ON%You follow the rune god. He spoke of you, and said that if I died in your company you would do me the honor of granting the rune rite. Are such omens true? Will you allow me to fight with you?%SPEECH_OFF%}"
							Image		= ""
							List		= [ ]
							Characters	= [ ]
							Options		= [
											{
												Text = "Very well. Let us visit our deaths upon Ironhand's foes together."
												function getResult(_event) {
													World.getPlayerRoster().add(_event.m.Dude);
													World.getTemporaryRoster().clear();
													_event.m.Dude.onHired();
													_event.m.Dude = null;
													return 0;
												}
											},
											{
												Text = "You must seek your death on your own."
												function getResult(_event) { return 0; }
											}
										]
							function start(_event) {
								local roster = World.getTemporaryRoster();
								_event.m.Dude = roster.create("scripts/entity/tactical/player");
								_event.m.Dude.setStartValuesEx([ "barbarian_background" ]);

								Characters.push(_event.m.Dude.getImagePath());
							}
						});
	}

	function onUpdateScore()
	{
		if (!Const.DLC.Wildmen || !Const.DLC.Paladins)
			return;

		if(World.Assets.getOrigin().getID() != "scenario.runeknights")
			return;

		if(World.getPlayerRoster().getSize() >= World.Assets.getBrothersMax())
			return;

		local currentTile = World.State.getPlayer().getTile();
		if (currentTile.SquareCoords.Y < World.getMapSize().Y * 0.7)
			return;

		m.Score = 5;
	}

	function onPrepare() { }

	function onPrepareVariables(_vars) { }

	function onClear() {
		m.Dude = null;
	}
})