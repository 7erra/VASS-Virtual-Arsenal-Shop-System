class Weapons
{
	class AddAction
	{
		title = "Weapon Shop";
		priority = 1.5;
		showWindow = 1;
		hideOnUse = 1;
		shortcut = "";
		condition = "true";
		radius = 5;
		unconscious = 0;
		selection = "";
		memoryPoint = "";
	};
	class Cargo
	{
		class Items
		{
		};
		class Weapons
		{
			class sgun_HunterShotgun_01_sawedoff_F
			{
				price = 100;
				count = 15;
			};
			class sgun_HunterShotgun_01_F: sgun_HunterShotgun_01_sawedoff_F
			{
				price = 50;
			};
		};
		class Magazines
		{
		};
		class Backpacks
		{
		};
	};
};
