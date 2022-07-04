southern_assassins_intro_event <- inherit("scripts/events/event", {
	m = {},
	function create()
	{
		m.ID = "event.southern_assassins_scenario_intro";
		m.IsSpecial = true;
		m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_165.png[/img]The Old Man on the Mountain speaks in a deep, commanding voice that contrasts starkly with his scrawny frame.%SPEECH_ON%There is a man, a heretic by the name of %nemesis%, out in the desert. He claims to be a prophet, an inheritor of the Gilder's own gleam. Such blasphemy carries a death sentence, of course, but he is clever. And cautious. Four times have the guilds made attempts on his life, four times have we failed, and four times has our failure bolstered his cause and rallied more to him, convinced of his divinity.\n\nNo more. He has a sizeable retainer of Crownlings to do his bidding. That is the chink in his armor. You are to form a band of Crownlings yourself. Gain fame such that he cannot ignore you, and seek an audience with him to sell your services. When he stands before you, strike. You mustn't bear any association with the guilds - his spies are everywhere and have a keen scent for duplicity. As of this moment, you are exiled. The guilds cannot support you for this plan to work. No half measures.%SPEECH_OFF%There's a deep weariness in his eyes, and something else you cannot identify. He returns your stare, but you can tell he's looking through you, not truly at you. He sighs.%SPEECH_ON%This is your last assignment. Complete this task, and your place in paradise is assured. Go now.%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "By the shadow of the Gilder's gleam, it shall be done.",
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
		m.Title = "Southern Assassins";
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([ "nemesis", World.Statistics.getFlags().get("SouthernAssassinNemesisName") ]);
	}

	function onClear()
	{
	}

});
