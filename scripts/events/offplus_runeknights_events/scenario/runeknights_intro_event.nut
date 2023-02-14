runeknights_intro_event <- inherit("scripts/events/event", {
	m = {},
	function create()
	{
		m.ID = "event.runeknights_scenario_intro";
		m.IsSpecial = true;
		m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_145.png[/img]{%deadbro% is at the base of the tree, propped up by the heavy javelin impaling him to its trunk. The shaft of the weapon loses all form where it meets flesh, its head obscured by an ocean of blood steadily pumping the warrior's life onto the ground.\n\nIt's a good wound - and quite mortal - earned by the many slain foes littering the ground around him. You're proud of the man, and tell him so. His eyes flicker. You order %death_knight% to transcribe a rune for him. The eyes close and do not open. As the last vestiges of life escape from his fleshen vessel, you motion for the men to collect the bodies and build a pyre.\n\nThe corpse smoke fills yours eyes, then your lungs, then finally your mind, and there he is. Ironhand's cloaked, wizened form is hunched in front of you, as frail and as unbreakable as ever. He points a bony finger and speaks in his fathomless tongue.%SPEECH_ON%I hath need of thine skills elsewhere, mine chosen. The green-men plot beyond the passes, the dead stir in their graves below, and now the dead-but-living skulk in the shadows of civilization itself. Waste not thineself hither - hie you to visit thine death upon mine foes.%SPEECH_OFF%The vision fades and you see the pyre, now a smoldering pile of ash and bone. You've heard tell of sellswords, men who are paid to fight and roam the world - an ideal profession from which to mete out the old god's judgement further afield than these northern wastes. You give the edict to the men and tell them to gather their supplies.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "And mine death I shall visit upon Ironhand's foes.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				Banner = "ui/banners/" + World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		m.Title = "Rune Chosen";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = World.getPlayerRoster().getAll();
		_vars.push([ "deadbro", Const.Strings.BarbarianNames[Math.rand(0, Const.Strings.BarbarianNames.len() - 1)] ]);
		_vars.push([ "death_knight", brothers[0].getNameOnly() ]);
	}

	function onClear()
	{
	}

});
