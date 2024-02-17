oathtakers_intro_event <- inherit("scripts/events/event", {
	m = { }

	function create() {
		m.ID		= "event.oathtakers_scenario_intro";
		m.IsSpecial	= true;

		m.Screens.push({
			ID			= "A",
			Text		= "[img]gfx/ui/events/event_180.png[/img]{It's been some time since you left the Oathtakers, and you've not regretted it for a day. The Oaths were stifling and constant, you never even got to hold Young Anselm's skull, and last you heard some debacle saw an Oathbringer steal off with the lad's preeminent jaw. Needless to say, you were none too happy when you opened the door this morning and were greeted by two Oathtakers, %oathtaker1% and %oathtaker2%.\n\nInitially you thought them assassins sent to avenge some imagined apostasy you commited by leaving, but the younger of the men offers you a bag of gold before you can draw your sword.%SPEECH_ON%The order has fallen on dark times. Evil stalks every corner of the world and we two cannot stamp it out alone. The Oathtakers need more men, but these few crowns are all we have. Our talents are fit only for mercenary work, yet we've no aptitude for the dark dealings of elder's halls and noble's chambers. We need help.%SPEECH_OFF%You inspect the gold. It's a respectable sum for an individual, but meager funds with which to fund an entire sellsword company. The older of the two men then produces a leather-wrapped bundle of parchment - the so-called Book of Oaths, though its damned contents seem slimmer than you remember -  and a familiar polished skull. Young Anselm. You've lost touch with the organization, but seeing that lad's dumb dome still brings a stir in your heart.%SPEECH_ON%The few Oaths we could safeguard, and our order's most treasured relic. With their guidance and your shrewdness, surely our venture shall succeed!%SPEECH_OFF%You have only one condition: you will take the Oath of Captaincy, which means all the battling and rough roading will be done by others. The Oathtakers agree without pause, and with that, you're off.}",
			Image		= "",
			Banner		= "",
			List		= [],
			Characters	= [],
			Options		= [
				{
					Text = "For gold, glory, and Young Anselm!",
					function getResult( _event ) { return 0; }
				}
			]

			function start( _event ) {
				Banner = "ui/banners/" + World.Assets.getBanner() + "s.png";
			}
		});
	}

	function onUpdateScore() {
		return;
	}

	function onPrepare() {
		m.Title = "The Oathtakers";
	}

	function onPrepareVariables( _vars ) {
		local brothers = World.getPlayerRoster().getAll();

		_vars.push(["oathtaker1", brothers[0].getName() ]);
		_vars.push(["oathtaker2", brothers[1].getName() ]);
	}

	function onClear() { }
});
