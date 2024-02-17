offp_dead_necromancer_event <- inherit("scripts/events/event", {
	m = {
		Oathtaker	= null
		NearbyTown	= null
	}

	function create() {
		m.ID		= "event.offp_dead_necromancer";
		m.Title		= "Along the way...";
		m.Cooldown	= 9999.0 * World.getTime().SecondsPerDay;

		m.Screens.push({
			ID			= "A"
			Text		= "[img]gfx/ui/events/event_180.png[/img]{You come across a small cemetery and hear the sound of voices come from within. Inside you find an elderly man in humble garb, whom you take to be the groundskeeper. He's arguing with a man wearing ornate armor decorated with all manner of symbols and sigils.%SPEECH_ON%I tell ye, sir, I can't let ye defile the dead so. I don't care if the man was the blackest villain who ever lived, in death the old gods grant him repose same as anyone else, and it ain't right to rob a body o' that. That's what the priests say, mister oathhoarder sir, and surely ye wouldn't accuse the priests o' fibbin'.%SPEECH_OFF%The armored man snaps back, getting frustrated.%SPEECH_ON%It's 'Oathtaker', and for the last time, there can be no repose for one who has dabbled in the dark sorceries. Albrecht the Wormbitten cannot be allowed to stay interred, and his ensorcelled husk must be utterly destroyed. If not, he is sure to rise once more to commit atrocities on the dead and living that shall make the necrotic arts he performed in life look like mere child's play. Surely the old gods would not ask you nor I nor any to bear such terrible weight on our consciences!%SPEECH_OFF%The groundskeeper looks a particular mix of bored, annoyed, and confused by the man's rhetoric, but his face brightens upon seeing you.%SPEECH_ON%Ah, a sellsword company? Surely worldly travelers like yerselves will have level heads on your shoulders. Perhaps ye can talk some sense into this fellow? He insists on profaning a corpse restin' here. As groundskeeper I of course can't allow such a disturbence, but even if I could, it just ain't right.%SPEECH_OFF%}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "The paladin is right. Even in death a necromancer has powers."
					function getResult(_event) { return "B"; }
				},
				{
					Text = "Leave the corpse alone."
					function getResult(_event) { return "C"; }
				}
			]

			function start(_event) {
				if (_event.m.Oathtaker != null) {
					Options.push({
						Text = "%oathtaker% the oathtaker, what do you think?"
						function getResult(_event)	{ return "Oathtaker"; }
					});
				}

				Options.push({
					Text = "Leave me out of this, I've got my hands full with the living as it is."
					function getResult(_event)	{ return 0; }
				});
			}
		});

		m.Screens.push({
			ID			= "B"
			Text		= "[img]gfx/ui/events/event_180.png[/img]{You look at the man and shrug. You've never heard of any necromancer coming back to life on his own, but that hardly seems like a good reason to put yourself on the wrong end of an oathtaker's justice.%SPEECH_ON%Sorry, old man, but necromancers aren't to be trifled with. Best to do as he says.%SPEECH_OFF%The old man begins to protest, but emboldened by your support, the oathtaker pushes past him and enters a small mausoleum. Within moments you hear the familiar sound of steel slicing through flesh and bone, and then the crackling of a torch. Deciding you've smelled enough burnt flesh for one lifetime already, you move the company out before the man gets that far. The groundskeeper glares at you darkly on the way out.%SPEECH_ON%Blackguards, all of ye. Folks is right about you sellswords.%SPEECH_OFF%}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "Better hated than dead."
					function getResult(_event) { return 0; }
				}
			]

			function start(_event) {
				World.Assets.addMoralReputation(-2);

				local brothers = World.getPlayerRoster().getAll();

				foreach (bro in brothers) {
					if (bro.getBackground().getID() == "background.gravedigger")
						bro.worsenMood(0.5, "You let a man defile an interred corpse");
				}
			}
		});

		m.Screens.push({
			ID			= "C"
			Text		= "[img]gfx/ui/events/event_180.png[/img]{You cross your arms and address the oathtaker.%SPEECH_ON%Even if this fellow was a necromancer, he's dead. I've yet to see a man that can bring himself back from that. Have you?%SPEECH_OFF%%randombrother% shakes his head slowly.%SPEECH_ON%No, cap, I ain't seen that before.%SPEECH_OFF%You turn back to the armored man and handle the hilt of your sword to make your point clear.%SPEECH_ON%There you have it. No desecrations today.%SPEECH_OFF%He glares at you with unbridled animosity, but decides fighting the whole company on his own wouldn't go his way.%SPEECH_ON%Very well, sellsword. Know, however, that your consortions with the dark arts will not go unpronounced. I'll make sure of that.%SPEECH_OFF%He stomps off, and the groundskeeper shuffles over to you.%SPEECH_ON%Thank ye kindly, sirs. I'm sure the man didn't mean wrong, even if he's a bit touched in the head. Don't mind what he said, I'll speak well of what ye've done today.%SPEECH_OFF%}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "Can't please everyone."
					function getResult(_event) { return 0; }
				}
			]

			function start(_event) {
				World.Assets.addMoralReputation(2);

				World.Assets.addBusinessReputation(-10);
				List.push({ id = 11, icon = "ui/icons/special.png", text = "The company lost renown" });

				local faction = _event.m.NearbyTown.getFactionOfType(Const.FactionType.Settlement);

				faction.addPlayerRelation(Const.World.Assets.RelationFavor, "Your company fended off a corpse defiler");
				List.push({ id = 10, icon = "ui/icons/special.png", text = "Your relation to " + faction.getName() + " has improved" });
			}
		});

		m.Screens.push({
			ID			= "Oathtaker"
			Text		= "[img]gfx/ui/events/event_180.png[/img]{%oathtaker% the oathtaker addresses the would-be corpse cleanser.%SPEECH_ON%It is not our place to preempt evil, brother, nor should we consort with the dark arts such that we can predict their malicious ways. If this villain is to rise by the will of some profane power, let him! Do not cheat yourself of the honor you shall gain by defeating him at the apex of his power.%SPEECH_OFF%That logic doesn't quite make sense to you, but the words certainly hit the mark with their intended audience, who now stands thoroughly admonished.%SPEECH_ON%You are right, of course. I was so blinded in my pursuit of righteousness that I almost robbed myself of it! Thank you for mending my way. Very well! I shall watch over this place in preparation for the battle to come. Please, take this. I see now I have no need of it.%SPEECH_OFF%The man hands over a small bottle of clear liquid and promptly stalks off, familiarizing himself with his newfound arena. The groundskeeper turns to you.%SPEECH_ON%Well I can't say he's the company I would have chosen, but if trouble does show up better it finds him than me.%SPEECH_OFF%}"
			Image		= ""
			List		= [ ]
			Characters	= [ ]
			Options		= [
				{
					Text = "Glad we could help."
					function getResult(_event) { return 0; }
				}
			]

			function start(_event) {
				local item = new("scripts/items/tools/holy_water_item");

				World.Assets.getStash().add(item);
				List.push( { id = 10, icon = "ui/items/" + item.getIcon(), text = "You gain " + item.getName() } );

				local brothers = World.getPlayerRoster().getAll();

				foreach (bro in brothers) {
					if (bro.getID() != _event.m.Oathtaker.getID() && bro.getBackground().getID() == "background.paladin")
						bro.improveMood(0.5, "Inspired by " + _event.m.Oathtaker.getNameOnly());
				}
			}
		});
	}

	function onUpdateScore() {
		if (!Const.DLC.Paladins)
			return;

		local towns = World.EntityManager.getSettlements();
		local nearTown = false;
		local town = null;
		local playerTile = World.State.getPlayer().getTile();

		foreach(t in towns) {
			if (t.isSouthern() || t.isMilitary())
				continue;

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer()) {
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
			return;

		local brothers = World.getPlayerRoster().getAll();
		local oathtakerCandidates = [];

		foreach (bro in brothers) {
			if (bro.getBackground().getID() == "background.paladin")
				oathtakerCandidates.push(bro);
		}

		if (oathtakerCandidates.len() == 0)
			return;

		m.NearbyTown = town;
		m.Oathtaker = oathtakerCandidates[Math.rand(0, oathtakerCandidates.len() - 1)];
		m.Score = 4;
	}

	function onPrepare() { }

	function onPrepareVariables(_vars) {
		_vars.push([ "oathtaker", m.Oathtaker.getNameOnly() ]);
	}

	function onClear() {
		m.Oathtaker	= null;
	}
});
