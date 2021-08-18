class VASS_AmmoBox2: TitleWide
{
	attributeLoad = "['attributeLoad',_this] call (uinamespace getvariable 'TER_VASS_AmmoBox_script');";
	attributeSave = "['attributeSave',_this] call (uinamespace getvariable 'TER_VASS_AmmoBox_script');";
	h = 5 * GRID_H;
	class Controls: Controls
	{
		class Edit: ctrlButton
		{
			text = "Edit VASS Inventory";
			onButtonClick = (findDisplay 315) createDisplay "Display3DENVASS";
			x = 5 * GRID_W;
			w = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - 5) * GRID_W;
			h = 5 * GRID_H;
		};
	};
};
