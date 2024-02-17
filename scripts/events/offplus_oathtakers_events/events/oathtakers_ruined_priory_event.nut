oathtakers_ruined_priory_event <- inherit("scripts/events/event", {
	m = {
		Oathtaker	= null
	}

	function create() {
		m.ID		= "event.oathtakers_ruined_priory";
		m.Title		= "Along the way...";
		m.Cooldown	= 9999.0 * World.getTime().SecondsPerDay;

		m.Screens.push({
			ID			= "A"
			Text		= "[img]gfx/ui/events/event_40.png[/img]{You come across a ruined priory. The roof of the building has cratered inwards and the walls are in varying degrees of collapse. An old man in a simple brown habit wanders out from the side of the ruin.%SPEECH_ON%Ah, what's this? A company of sellswords? ...No, you're Oathtakers. Now there's something you don't see every day.%SPEECH_OFF%Surprised, you ask the man how he knew you were followers of Young Anselm. He strokes his chin with a gleam in his eye.%SPEECH_ON%Oh, the men of the Oaths aren't hard to spot when you know what to look for. Though, I daresay you lot look more cutthroat vagabonds than you do Anselm's finest. The order must have fallen on hard times for its men to appear so disordered. Why, I bet even I know some of the Oaths better than you disheveled fellows!%SPEECH_OFF%The prior's challenge elicits a gasp from the men, but from the smile on his face you understand it wasn't an insult. He wants to test your knowledge.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "So be it. No priest knows the Oaths better than we do!"
					function getResult(_event) { return _event.getOutcome(); }
				},
				{
					Text = "Sorry, but we won't fall for your goading. Good day, prior."
					function getResult(_event) { return 0; }
				}
			]

			function start(_event) { }
		});

		m.Screens.push({
			ID			= "Encouragement"
			Text		= "[img]gfx/ui/events/event_40.png[/img]{You cross your arms and tell the monk you'll take his challenge. He muses for a moment, then speaks.%SPEECH_ON%The Oath of Auspice says, 'And trust no man who claims to be holy, for holiness is the privilege of the old gods and no other.' Is that correct?%SPEECH_OFF%%oathtaker% pipes up.%SPEECH_ON%Aye! Young Anselm means to warn us of predators in our midst, men who claim the old gods' words for themselves! 'Tis why we must keep vigil over monasteries and temples, for even a well meaning shepherd can still lead his flock astray with arrogance.%SPEECH_OFF%The men nod in approval, but the prior offers a rebuttal.%SPEECH_ON%True enough, true enough. But tell me this, then. The Oath of Fervor says 'Heed closely the wisdom of men with divine purpose, for their commune is with the old gods, and none can offer truer council than they.' So which is it? Are we clergy mere charlatans who steal the old gods' authority for our own, or conduits to direct their voices to the ears of the needy?%SPEECH_OFF%The men shuffle awkwardly in silence, unsure how to respond to this apparent contradiction. The monk laughs.%SPEECH_ON%It seems you still have much to learn! But take heart, we all must start somewhere. What this highlights is not a contradiction in the Oaths, but in man himself. Just as an arrogant monk can deceive, so too can an earnest child speak wisdom. What Anselm teaches is neither endorsement nor admonishment of the priesthood, but an evaluation of the individual. That is why the order finds its company so often in temple halls - so the Oathtakers learn to discern honeyed words from wise ones, regardless of who speaks them.%SPEECH_OFF%The men are visibly heartened by this newfound clarity and thank the prior for his wisdom. He waves you on with a smile and tells you to go in peace.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "An unlikely teacher, to be sure."
					function getResult(_event) { return 0; }
				}
			]

			function start(_event) {
				Characters.push(_event.m.Oathtaker.getImagePath());

				local brothers = World.getPlayerRoster().getAll();

				foreach (bro in brothers) {
					bro.improveMood(1.0, "Was taught something new about the Oaths");

					if (bro.getMoodState() > Const.MoodState.Neutral)
						List.push({ id = 11, icon = Const.MoodStateIcon[bro.getMoodState()], text = bro.getName() + Const.MoodStateEvent[bro.getMoodState()] });
				}
			}
		});

		m.Screens.push({
			ID			= "Treasures"
			Text		= "[img]gfx/ui/events/event_40.png[/img]{You tell the monk your men can pass whatever test he has. He ponders a moment.%SPEECH_ON%The Oath of Righteousness calls on men to address the evil of unlife, and to set aside worldly matters in pursuit of its correction. Yet the Oath of Vengeance harkens to the more pressing dangers of the greenskin menace. After all, it was orcs and goblins, not undead, that broke our lands those many years ago. So why doesn't every Oathtaker follow the Oath of Vengeance and eschew the pursuit of lesser threats?%SPEECH_OFF%The men whisper amongst themselves until %oathtaker% steps up and speaks with confidence.%SPEECH_ON%'Tis a false choice! The Oath of Righteousness is a light to illuminate the crypt and the necropolis, while the Oath of Vengeance is a guide through wild and warcamp. Too often is the threat of the orc masked by the horrors of undeath, or the profanity of the necromancer given purchase because the fear of pillaging goblins. The pursuit of one Oath stumbles without the other, and so we must heed them with equal focus.%SPEECH_OFF%The priest smiles warmly.%SPEECH_ON%A fine answer, lad. I'm glad to see the order hasn't lost its way.%SPEECH_OFF%He disappears into the ruin and returns a moment later carrying a valuable looking tome.%SPEECH_ON%Here, from the vault. I have no need of it, and I would be honored if Anselm's faithful put it to good use.%SPEECH_OFF%You thank the man graciously and have his gift put in inventory.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "Good job, %oathtaker%."
					function getResult(_event) { return 0; }
				}
			]

			function start(_event) {
				Characters.push(_event.m.Oathtaker.getImagePath());

				local item = new("scripts/items/loot/ornate_tome_item");

				World.Assets.getStash().add(item);
				List.push( { id = 10, icon = "ui/items/" + item.getIcon(), text = "You gain " + Const.Strings.getArticle(item.getName()) + item.getName() } );

				local brothers = World.getPlayerRoster().getAll();

				foreach (bro in brothers) {
					bro.improveMood(0.5, "Inspired by " + _event.m.Oathtaker.getNameOnly() + "'s knowledge of the Oaths");
				}
			}
		});

		m.Screens.push({
			ID			= "Relic"
			Text		= "[img]gfx/ui/events/event_17.png[/img]{You tell him with confidence that the %companyname% can answer any dilemma he presents. He studies you for a moment, then the men, then the humor drains from his face and he speaks.%SPEECH_ON%Very well. Recite to me the Oath of the Final Path.%SPEECH_OFF%This challenge elicits another gasp from the men, for those few that even know of the Oath know that it is forbidden to transcribe it, and only a select few are given the honor of hearing it. %oathtaker% is undaunted, however, and confidently speaks up.%SPEECH_ON%The words are unimportant, for the Final Path is not some mere message. It is a leyline, a route to greatness and betterment. Young Anselm saw it first, and he knew that we lesser men could not follow it on our own. That is why the Oaths exist, that we might one day be as worthy as he and see that same path our founder did. The Oath of the Final Path cannot be recited like other Oaths - it IS the other Oaths, in concert as one.%SPEECH_OFF%The monk grows quiet, staring at the ruin wistfully for a time. Eventually, he speaks.%SPEECH_ON%I once knew an Oathtaker by the name of Siegward the Bold. He was a warrior of no small renown in the order, and he came here, to this very priory, upon hearing of an Unhold terrorizing the faithful. He slew the creature, but neither he nor the building survived the battle. I witnessed his passing. His only regret was that he never did learn the Oath of the Final Path.%SPEECH_OFF%The prior fetches a bundle wrapped in fine silk from inside the building and hands it to you. You open it to reveal one of the finest swords you've ever seen. He continues.%SPEECH_ON%I am heartened that the order now has wise men such as thee to guide it, and that none need suffer the anguish Siegward did. This was his blade. I think he'd want you to have it.%SPEECH_OFF%You thank him and tell the company to move out.}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "We won't let this boon go to waste."
					function getResult(_event) { return 0; }
				}
			]

			function start(_event) {
				Characters.push(_event.m.Oathtaker.getImagePath());

				local item = new("scripts/items/weapons/named/named_sword");

				item.setName("Siegward the Bold's Sword");
				World.Assets.getStash().makeEmptySlots(1);
				World.Assets.getStash().add(item);
				List.push( { id = 10, icon = "ui/items/" + item.getIcon(), text = "You gain " + Const.Strings.getArticle(item.getName()) + item.getName() } );

				local brothers = World.getPlayerRoster().getAll();

				foreach (bro in brothers) {
					bro.improveMood(1.0, "Inspired by " + _event.m.Oathtaker.getNameOnly() + "'s knowledge of the Oaths");
				}
			}
		});
	}

	function onUpdateScore() {
		if (!Const.DLC.Paladins)
			return;

		if (World.Assets.getOrigin().getID() != "scenario.oathtakers")
			return;

		local brothers = World.getPlayerRoster().getAll();
		local bestOathtaker = null;
		local mostOathsCompleted = 0;

		foreach (bro in brothers) {
			if (bro.getBackground().getID() == "background.paladin" || bro.getBackground().getID() == "background.oathbreaker") {
				local completed = ::OFFP.Helpers.getNumOathsCompletedForBro(bro);

				if (completed > mostOathsCompleted) {
					mostOathsCompleted = completed;
					bestOathtaker = bro;
				}
			}
		}

		if (bestOathtaker == null)
			return;

		m.Oathtaker = bestOathtaker;
		m.Score = 2 + mostOathsCompleted;
	}

	function onPrepare() { }

	function onPrepareVariables(_vars) {
		_vars.push([ "oathtaker", m.Oathtaker.getName() ]);
	}

	function onClear() {
		m.Oathtaker	= null;
	}

	function getOutcome() {
		local brothers = World.getPlayerRoster().getAll();
		local numOathmasters = 0, numOathtakers = 0, numOathfollowers = 0;

		foreach (bro in brothers) {
			if (bro.getBackground().getID() == "background.paladin" || bro.getBackground().getID() == "background.oathbreaker") {
				local oathsCompleted = ::OFFP.Helpers.getNumOathsCompletedForBro(bro);

				if (oathsCompleted > 2)
					numOathmasters++;
				else if (oathsCompleted > 1)
					numOathtakers++;
				else if (oathsCompleted > 0)
					numOathfollowers++;
			}
		}

		if (numOathmasters >= 1)
			return "Relic";

		if (numOathtakers >= 2)
			return "Treasures";

		return "Encouragement";
	}
});
