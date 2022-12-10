oath_of_proving_ambition <- inherit("scripts/ambitions/oaths/oath_ambition",
{
	m =
	{
	}

	function create()
	{
		oath_ambition.create();

		m.ID				= "ambition.oath_of_proving";
		m.Duration			= 99999.0 * World.getTime().SecondsPerDay;

		m.ButtonText		= "The company is only as strong as its weakest fighters.\nLet us take an Oath of Proving and demonstrate that we are all of us worthy!";
		m.TooltipText		= "Young Anselm always taught that his followers should be the shepherds to the lambs, able-bodied and full of prowess with which to protect the infirm. \"Let every man fight knowing how many depend on his victory.\"";
		m.SuccessText		= "[img]gfx/ui/events/event_180.png[/img]{There exists disparity between all men, whether by station or by birth or by talent. When the %companyname% took on the Oath of Proving, you knew this disparity would come to the forefront, with some men more fit for combat than others.\n\nDespite it all, however, each man ultimately did prove his worth, with those less talented driven to try that much harder next time and those more accustomed eager to see just how far their skills could take them. Indeed, in some small way the men have become closer, and the disparity lessened somewhat in the face of their collective success.\n\nBut enough of this self-measurement - it's time to move on to the next Oath!}";
		m.SuccessButtonText	= "{For Young Anselm! | As Oathtakers! | And death to the Oathbringers!}";

		m.OathName			= "Oath of Proving";
		m.OathBoonText		= "Your men gain [color=" + Const.UI.Color.PositiveValue + "]+10[/color] Resolve, [color=" + Const.UI.Color.PositiveValue + "]+10[/color] Initiative, and deal [color=" + Const.UI.Color.PositiveValue + "]+10%[/color] damage until their first kill each battle.";
		m.OathBurdenText	= "Your men that don't kill any foes in a battle receive [color=" + Const.UI.Color.NegativeValue + "]-100%[/color] experience until they get a kill.";
	}

	function getRenownOnSuccess()
	{
		local additionalRenown = getBonusObjectiveProgress() >= getBonusObjectiveGoal() ? Const.World.Assets.ReputationOnOathBonusObjective : 0;
		return Const.World.Assets.ReputationOnOathAmbition + additionalRenown;
	}

	function getRewardTooltip()
	{
		return "You gain extra Renown if one of your men kills " + getBonusObjectiveGoal() + " foes (" + getBonusObjectiveProgress() + "/" + getBonusObjectiveGoal() + ").";
	}

	function getBonusObjectiveProgress()
	{
		local brothers = World.getPlayerRoster().getAll();

		brothers.sort(function(_a, _b)
		{
			if(_a.getFlags().getAsInt("OathOfProvingKills") > _b.getFlags().getAsInt("OathOfProvingKills")) 
				return -1;
			else if(_a.getFlags().getAsInt("OathOfProvingKills") < _b.getFlags().getAsInt("OathOfProvingKills")) 
				return 1;
			return 0;
		});

		return brothers[0].getFlags().getAsInt("OathOfProvingKills");
	}

	function getBonusObjectiveGoal()
	{
		if(World.Assets.getCombatDifficulty() >= Const.Difficulty.Hard)
			return 20;
		else if(World.Assets.getCombatDifficulty() >= Const.Difficulty.Normal)
			return 15;
		else
			return 10;
	}

	function onUpdateScore()
	{
		if(!Const.DLC.Paladins)
			return;

        if(World.Assets.getOrigin().getID() != "scenario.paladins")
            return;

		m.Score = 1 + Math.rand(0, 5) + (m.IsDone ? 0 : 10) + m.TimesSkipped * 2;
	}

	function onStart()
	{
		local brothers = World.getPlayerRoster().getAll();

		foreach(bro in brothers)
		{
			bro.getSkills().add(new("scripts/skills/traits/oath_of_proving_trait"));
			bro.getFlags().set("OathOfProvingKills", 0);
		}
	}

	function onReward()
	{
		World.Statistics.getFlags().increment("OathsCompleted");

		local brothers = World.getPlayerRoster().getAll();

		foreach(bro in brothers)
		{
			bro.getSkills().removeByID("trait.oath_of_proving");
			bro.getFlags().set("OathOfProvingKills", 0);
			bro.getFlags().set("OathOfProvingApplyXPMult", false);
		}
	}
})
