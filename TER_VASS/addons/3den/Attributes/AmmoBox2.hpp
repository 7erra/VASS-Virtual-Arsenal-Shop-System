class TER_VASS_AmmoBox2: Title
{
	attributeLoad = ["attributeLoad",[_this, _value]] call ATTRIBUTE_SCRIPT(VASS_AmmoBox2);
	attributeSave = ["attributeSave",[_this]] call ATTRIBUTE_SCRIPT(VASS_AmmoBox2);
	INIT_CONTROL(VASS_AmmoBox2,TER_VASS_3den)
	#undef ATTRIBUTE_SCRIPT
	h = 12 * GRID_H;
	class Controls: Controls
	{
		class Title: Title {};
		class List: ctrlEdit
		{
			idc = IDC_VASS_AMMOBOX2_LIST;
			font = "EtelkaMonospacePro";
			sizeEx = "3.41 * (1 / (getResolution select 3)) * pixelGrid * 0.5";
			x = ATTRIBUTE_TITLE_W * GRID_W;
			w = ATTRIBUTE_CONTENT_W * GRID_W;
			h = ATTRIBUTE_CONTENT_H * GRID_H;
		};
		class Edit: ctrlButton
		{
			idc = IDC_VASS_AMMOBOX2_EDIT;
			text = "Edit VASS Inventory";
			x = ATTRIBUTE_TITLE_W * GRID_W;
			y = 6 * GRID_H;
			w = ATTRIBUTE_CONTENT_W * GRID_W;
			h = ATTRIBUTE_CONTENT_H * GRID_H;
		};
	};
};
