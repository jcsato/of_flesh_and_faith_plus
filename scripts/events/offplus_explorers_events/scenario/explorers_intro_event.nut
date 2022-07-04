explorers_intro_event <- inherit("scripts/events/event", {
	m = {},
	function create()
	{
		m.ID = "event.explorers_scenario_intro";
		m.IsSpecial = true;
		m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_133.png[/img]{You nestle closer to the feeble campfire, trying not to remember more comfortable days long gone. You glance at %disowned%, sure the disgraced noble is doing much the same, and %wildman%, wholly unsure what runs through the wildman's mind. The three of you sit there, dour as all victims of the PIllager Rot are, until your fourth and final companion, %messenger%, comes in from the gloom. He waves a sheaf of parchment at you.%SPEECH_ON%Was all the usual hogwash, 'cept this. The expedition notes of Arnold of Stohlfeste, some noble that went on a punitive crusade into the frontier after the Battle of Many Names. Whole thing ended in failure, of course, but see on this page here where he describes a tree with human faces standing in a pool of water. Their camp was raided before he could get a closer look, and afterwards he couldn't find it again.%SPEECH_OFF%%disowned% reads the passage briefly.%SPEECH_ON%That's the third account of this thing we've seen. Maybe it is truly the fountain of youth, maybe not, but it surely exists and it surely can't be any worse than getting corralled into leper colonies or chased out of healing houses. I say we find it ourselves!%SPEECH_OFF%The others agree. Mounting an expedition into the wilderness is no mean feat, however. You'll need supplies, crowns, and most importantly fighters. You make up your mind.%SPEECH_ON%We'll form a mercenary company. Plenty'll risk getting the Rot for the promise of exploring the unknown, and for enough crowns. We'll gather warriors and supplies and conquer the whole damned wilds if that's what it takes!%SPEECH_OFF%}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "And fark the Rot!",
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
		m.Title = "Cursed Explorers";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = World.getPlayerRoster().getAll();
		_vars.push([ "wildman", brothers[0].getNameOnly() ]);
		_vars.push([ "disowned", brothers[1].getNameOnly() ]);
		_vars.push([ "messenger", brothers[2].getNameOnly() ]);
	}

	function onClear()
	{
	}

});
