class VASS_addAction: Title
{
	h = 5.4 * ATTRIBUTE_CONTENT_H * GRID_H;
	// Format: [Enable, Title, condition, radius, priority]
	attributeLoad = "\
		_value = parseSimpleArray _value;\
		(_this controlsGroupCtrl 100) cbSetChecked (_value#0);\
		for ""_i"" from 1 to 4 do {(_this controlsGroupCtrl (100 + _i)) ctrlSetText (_value#_i);};\
	";
	attributeSave = "\
		str[\
			cbChecked (_this controlsGroupCtrl 100),\
			ctrlText (_this controlsGroupCtrl 101),\
			ctrlText (_this controlsGroupCtrl 102),\
			str parseNumber ctrlText (_this controlsGroupCtrl 103),\
			str parseNumber ctrlText (_this controlsGroupCtrl 104)\
		]\
	";
	class Controls: Controls
	{
		class Title1: Title
		{
			text = "Add Shop";
			tooltip = "Enable access to the modified arsenal on this object.";
		};
		class enable: ctrlCheckboxBaseline
		{
			idc = 100;
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
			idc = 101;
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
			idc = 102;
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
			idc = 103;
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
			idc = 104;
			y = 4.4 * ATTRIBUTE_CONTENT_H * GRID_H;
		};
	};
};
