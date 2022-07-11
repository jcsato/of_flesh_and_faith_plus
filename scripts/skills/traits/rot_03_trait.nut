rot_03_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.rot_03";
		m.Name			= "Spinerot";
		m.Icon			= "ui/traits/trait_icon_plus_03.png";
		m.Description	= "The Rot has begun to affect this character's psyche. They are racked with self-doubt, and hesitation permeates their every move.";

		m.Order			= Const.SkillOrder.Trait - 1;

		m.Excluded = [];
	}

	function getDescription()
	{
		return "";
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/bravery.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-10%[/color] Resolve" }
			{ id = 12, type = "text", icon = "ui/icons/initiative.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-10%[/color] Initiative" }
		];

		return ret;
	}

	function onAdded() {
		getContainer().getActor().getFlags().increment("CursedExplorersRotsActive");
	}

	function onRemoved() {
		getContainer().getActor().getFlags().increment("CursedExplorersRotsActive", -1);
	}

	function onUpdate(_properties) {
		_properties.BraveryMult		*= 0.9;
		_properties.InitiativeMult	*= 0.9;
	}
})
