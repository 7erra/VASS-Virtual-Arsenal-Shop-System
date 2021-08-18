class VASS_AmmoBox: TitleWide
{
	onLoad = "[""onLoad"",_this] call TER_VASS_fnc_vasscargo;";
	attributeLoad = "[""attributeLoad"",[_this,_value,true]] call TER_VASS_fnc_vasscargo;";
	attributeSave = "[""attributeSave"",[_this]] call TER_VASS_fnc_vasscargo;";
	
	h = (17 * ATTRIBUTE_CONTENT_H + 1) * GRID_H;
	class Controls: Controls
	{
		class Title: Title
		{
			//text = "Content";
			w = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - ATTRIBUTE_CONTENT_H - 51) * GRID_W;
		};
		class toggleView: ctrlToolbox
		{
			idc = IDC_VASSCARGO_TOOLVIEW;
			x = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - 25) * GRID_W;
			w = 25 * GRID_W;
			h = ATTRIBUTE_CONTENT_H * GRID_H;
			rows = 1;
			columns = 2;
			strings[] = {"GUI", "Array"};
		};
		class grpArrayEdit: ctrlControlsGroup
		{
			idc = IDC_VASSCARGO_GRPCARGOARRAY;
			fade = 1;
			x = ATTRIBUTE_CONTENT_H * GRID_W;
			y = 1.1 * ATTRIBUTE_CONTENT_H * GRID_H;
			w = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - ATTRIBUTE_CONTENT_H) * GRID_W;
			h = (2 + 13 - 0.1) * ATTRIBUTE_CONTENT_H * GRID_H;
			class controls
			{
				class arrayEdit: ctrlEdit
				{
					idc = IDC_VASSCARGO_EDCARGOARRAY;
					style = "0x00 + 0x10";
					font = "EtelkaMonospacePro";
					sizeEx = "3.41 * (1 / (getResolution select 3)) * pixelGrid * 0.5";
					x = 0;
					y = 0;
					w = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - ATTRIBUTE_CONTENT_H) * GRID_W;
					h = (2 + 13 - 0.1) * ATTRIBUTE_CONTENT_H * GRID_H;
				};
			};
		};
		/*
		class exportCargo: ctrlButton
		{
			idc = IDC_VASSCARGO_BTNEXPORT;
			text = "Export";
			tooltip = "Copy the current cargo to the clipboard.";
			x = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - 25) * GRID_W;
			w = 25 * GRID_W;
			h = ATTRIBUTE_CONTENT_H * GRID_H;
		}; 
		class importCargo: exportCargo
		{
			idc = IDC_VASSCARGO_BTNIMPORT;
			text = "Import";
			tooltip = "Import a cargo array from the clipboard.";
			x = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - 51) * GRID_W;
		};
		*/
		
		class Filter: ctrlToolbox
		{
			idc = IDC_VASSCARGO_TOOLFILTER;
			style = "0x30 + 0x800";
			x = ATTRIBUTE_CONTENT_H * GRID_W;
			y = 1.1 * ATTRIBUTE_CONTENT_H * GRID_H;
			w = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - ATTRIBUTE_CONTENT_H) * GRID_W;
			h = 2 * ATTRIBUTE_CONTENT_H * GRID_H;
			rows = 1;
			columns = 13;
			strings[] = {
				"\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_0_ca.paa",
				"\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_1_ca.paa",
				"\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_2_ca.paa",
				"\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_3_ca.paa",
				"\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_4_ca.paa",
				"\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_5_ca.paa",
				"\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_6_ca.paa",
				"\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_7_ca.paa",
				"\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_8_ca.paa",
				"\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_9_ca.paa",
				"\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_10_ca.paa",
				"\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_11_ca.paa",
				"\a3\Ui_F_Curator\Data\RscCommon\RscAttributeInventory\filter_12_ca.paa"
			};
		};
		class ListBackground: Title
		{
			idc = IDC_VASSCARGO_STATICLISTBACKGROUND;
			x = ATTRIBUTE_CONTENT_H * GRID_W;
			y = 3 * ATTRIBUTE_CONTENT_H * GRID_H;
			w = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - ATTRIBUTE_CONTENT_H) * GRID_W;
			h = 13 * ATTRIBUTE_CONTENT_H * GRID_H;
			colorBackground[] = {1,1,1,0.1};
		};
		class List: ctrlListNBox
		{
			idc = IDC_VASSCARGO_LNBCARGO;
			//style = 32;
			x = ATTRIBUTE_CONTENT_H * GRID_W;
			y = 3 * ATTRIBUTE_CONTENT_H * GRID_H;
			w = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - ATTRIBUTE_CONTENT_H) * GRID_W;
			h = 13 * ATTRIBUTE_CONTENT_H * GRID_H;
			drawSideArrows = 1;
			idcLeft = IDC_VASSCARGO_BTNMINUS;
			idcRight = IDC_VASSCARGO_BTNPLUS;
			columns[] = {0.050000001,0.15000001,0.7,0.85000002};
			disableOverflow = 1;
		};
		class Validate: ctrlStructuredText
		{
			idc = IDC_VASSCARGO_TXTVALIDATE;
			x = ATTRIBUTE_CONTENT_H * GRID_W;
			y = 16 * ATTRIBUTE_CONTENT_H * GRID_H;
			w = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - ATTRIBUTE_CONTENT_H) * GRID_W;
			h = 1 * ATTRIBUTE_CONTENT_H * GRID_H;
		};
		class BtnValidate: ctrlButton
		{
			idc = IDC_VASSCARGO_BTNVALIDATE;
			text = "Validate";
			x = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - 25) * GRID_W;
			y = 16 * ATTRIBUTE_CONTENT_H * GRID_H;
			w = 25 * GRID_W;
			h = ATTRIBUTE_CONTENT_H * GRID_H;
		};
		class TextPrice: Title
		{
			idc = IDC_VASSCARGO_TITLEPRICE;
			text = "Price:";
			style = 0;
			x = ATTRIBUTE_CONTENT_H * GRID_W;
			y = 16 * ATTRIBUTE_CONTENT_H * GRID_H;
			w = 15 * GRID_W;
		};
		class Price: ctrlEdit
		{
			idc = IDC_VASSCARGO_EDPRICE;
			x = 20 * GRID_W;
			y = 16 * ATTRIBUTE_CONTENT_H * GRID_H;
			w = 25 * GRID_W;
			h = ATTRIBUTE_CONTENT_H * GRID_H;
		};
		class ButtonClear: ctrlButton
		{
			idc = IDC_VASSCARGO_BTNCLEAR;
			text = "Clear";
			x = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - 25) * GRID_W;
			y = 16 * ATTRIBUTE_CONTENT_H * GRID_H;
			w = 25 * GRID_W;
			h = ATTRIBUTE_CONTENT_H * GRID_H;
		};
		class ArrowLeft: ctrlButton
		{
			idc = IDC_VASSCARGO_BTNMINUS;
			text = "-";
			font = "RobotoCondensedBold";
			x = -1;
			y = -1;
			w = ATTRIBUTE_CONTENT_H * GRID_W;
			h = ATTRIBUTE_CONTENT_H * GRID_H;
		};
		class ArrowRight: ArrowLeft
		{
			idc = IDC_VASSCARGO_BTNPLUS;
			text = "+";
		};
	};
};
