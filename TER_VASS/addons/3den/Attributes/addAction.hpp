class VASS_addAction: Title
{
	h = 5.4 * ATTRIBUTE_CONTENT_H * GRID_H;
	attributeLoad = ["attributeLoad", [_this,_value]] call ATTRIBUTE_SCRIPT(VASS_addAction);
	attributeSave = ["attributeSave", [_this]] call ATTRIBUTE_SCRIPT(VASS_addAction);
	INIT_CONTROL(VASS_addAction,TER_VASS_3den)
	class Controls: Controls
	{
		class Title1: Title
		{
			text = "Add Shop";
			tooltip = "Enable access to the modified arsenal on this object.";
		};
		class enable: ctrlCheckboxBaseline
		{
			idc = IDC_VASS_ADDACTION_ENABLE;
			x = ATTRIBUTE_TITLE_W * GRID_W;
			y = 0 * ATTRIBUTE_CONTENT_H * GRID_H;
			w = ATTRIBUTE_CONTENT_H * GRID_W;
			h = ATTRIBUTE_CONTENT_H * GRID_H;
		};
		class Title2: Title
		{
			text = "addAction Title";
			tooltip = "Text shown in the scroll menu. Supports formatted text.";
			y = 1.1 * ATTRIBUTE_CONTENT_H * GRID_H;
		};
		class addTitle: ctrlEdit
		{
			idc = IDC_VASS_ADDACTION_TITLE;
			x = ATTRIBUTE_TITLE_W * GRID_W;
			y = 1.1 * ATTRIBUTE_CONTENT_H * GRID_H;
			w = ATTRIBUTE_CONTENT_W * GRID_W;
			h = ATTRIBUTE_CONTENT_H * GRID_H;
		};
		class Title3: Title
		{
			text = "Condition";
			tooltip = "Determine when the shop is accessible. Go to the addAction BIKI page for more information.";
			y = 2.2 * ATTRIBUTE_CONTENT_H * GRID_H;
		};
		class addCondition: addTitle
		{
			idc = IDC_VASS_ADDACTION_CONDITION;
			autocomplete = "scripting";
			font = "EtelkaMonospacePro";
			sizeEx = "3.41 * (1 / (getResolution select 3)) * pixelGrid * 0.5";
			y = 2.2 * ATTRIBUTE_CONTENT_H * GRID_H;
		};
		class Title4: Title
		{
			text = "Radius";
			tooltip = "Sets from how far the player can access the shop.";
			y = 3.3 * ATTRIBUTE_CONTENT_H * GRID_H;
		};
		class radius: addTitle
		{
			idc = IDC_VASS_ADDACTION_RADIUS;
			y = 3.3 * ATTRIBUTE_CONTENT_H * GRID_H;
			w = round(ATTRIBUTE_CONTENT_W / 3) * GRID_W;
		};
		class Title5: Title
		{
			text = "Priority";
			tooltip = "Higher values will place the scroll menu entry higher.";
			y = 4.4 * ATTRIBUTE_CONTENT_H * GRID_H;
		};
		class priority: radius
		{
			idc = IDC_VASS_ADDACTION_PRIORITY;
			y = 4.4 * ATTRIBUTE_CONTENT_H * GRID_H;
		};
	};
};
