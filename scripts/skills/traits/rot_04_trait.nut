rot_04_trait <- inherit("scripts/skills/traits/character_trait",
{
	m =
	{
	}

	function create()
	{
		character_trait.create();

		m.ID			= "trait.rot_04";
		m.Name			= "Mindrot";
		m.Icon			= "ui/traits/trait_icon_plus_04.png";
		m.Description	= "The Rot has spead to this character's brain, causing forgetfulness and a degradation in hand-eye coordination.";

		m.Order			= Const.SkillOrder.Trait - 1;

		m.Excluded = [];
	}

	function getTooltip()
	{
		local ret =
		[
			{ id = 1, type = "title", text = getName() }
			{ id = 2, type = "description", text = getDescription() }
			{ id = 11, type = "text", icon = "ui/icons/melee_skill.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-5%[/color] Melee Skill" }
			{ id = 12, type = "text", icon = "ui/icons/ranged_skill.png", text = "[color=" + Const.UI.Color.NegativeValue + "]-5%[/color] Ranged Skill" }
		];

		return ret;
	}

	function onAdded() {
		getContainer().getActor().getFlags().increment("CursedExplorersRotsActive");
	}

	function onRemoved() {
		getContainer().getActor().getFlags().increment("CursedExplorersRotsActive", -1);
	}

	function onUpdate(_properties)
	{
		_properties.MeleeSkillMult	*= 0.95;
		_properties.RangedSkillMult	*= 0.95;
	}
})
