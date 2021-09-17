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
			text = "$STR_TER_VASS_3den_Attributes_addAction_Title1_text";
			tooltip = "$STR_TER_VASS_3den_Attributes_addAction_Title1_tooltip";
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
			text = "$STR_TER_VASS_3den_Attributes_addAction_Title2_text";
			tooltip = "$STR_TER_VASS_3den_Attributes_addAction_Title2_tooltip";
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
			text = "$STR_TER_VASS_3den_Attributes_addAction_Title3_text";
			tooltip = "$STR_TER_VASS_3den_Attributes_addAction_Title3_tooltip";
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
			text = "$STR_TER_VASS_3den_Attributes_addAction_Title4_text";
			tooltip = "$STR_TER_VASS_3den_Attributes_addAction_Title4_tooltip";
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
			text = "$STR_TER_VASS_3den_Attributes_addAction_Title5_text";
			tooltip = "$STR_TER_VASS_3den_Attributes_addAction_Title5_tooltip";
			y = 4.4 * ATTRIBUTE_CONTENT_H * GRID_H;
		};
		class priority: radius
		{
			idc = IDC_VASS_ADDACTION_PRIORITY;
			y = 4.4 * ATTRIBUTE_CONTENT_H * GRID_H;
		};
	};
};
