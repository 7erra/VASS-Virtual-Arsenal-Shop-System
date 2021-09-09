class TER_VASS_AmmoBox2: TitleWide
{
	attributeLoad = ["attributeLoad",[_this, _value]] call ATTRIBUTE_SCRIPT(VASS_AmmoBox2);
	attributeSave = ["attributeSave",[_this]] call ATTRIBUTE_SCRIPT(VASS_AmmoBox2);
	INIT_CONTROL(VASS_AmmoBox2,TER_VASS_3den)
	#undef ATTRIBUTE_SCRIPT
	h = 12 * GRID_H;
	class Controls: Controls
	{
		class List: ctrlEdit
		{
			idc = IDC_VASS_AMMOBOX2_LIST;
			x = 5 * GRID_W;
			y = 1 * GRID_W;
			w = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - 5) * GRID_W;
			h = 5 * GRID_H;
		};
		class Edit: ctrlButton
		{
			idc = IDC_VASS_AMMOBOX2_EDIT;
			text = "Edit VASS Inventory";
			x = 5 * GRID_W;
			y = 6 * GRID_H;
			w = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - 5) * GRID_W;
			h = 5 * GRID_H;
		};
	};
};
