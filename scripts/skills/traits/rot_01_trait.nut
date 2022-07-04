rot_01_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.rot_01";
		m.Name			= "Lungrot";
		m.Icon			= "ui/traits/trait_icon_plus_01.png";
		m.Description	= "The Rot has reached this character's lungs. Breathing is more difficult, and simple actions tire them easily.";

		m.Order			= Const.SkillOrder.Trait - 1;

		m.Excluded = [];
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/fatigue.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-10%[/color] Max Fatigue" }
		];

		return ret;
	}

	function onAdded()
	{
		getContainer().getActor().getFlags().increment("CursedExplorersRotsActive");
	}

	function onRemoved()
	{
		getContainer().getActor().getFlags().increment("CursedExplorersRotsActive", -1);
	}

	function onUpdate(_properties)
	{
		_properties.StaminaMult	*= 0.9;
	}
})
