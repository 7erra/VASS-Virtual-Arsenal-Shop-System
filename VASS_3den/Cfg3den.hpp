#include "\a3\3DEN\UI\macros.inc"
#include "gui\scripts\idcs.inc"
class ctrlButton;
class ctrlListNBox;
class ctrlStatic;
class ctrlToolbox;
class ctrlEdit;
class ctrlCheckboxBaseline;
class Cfg3den
{
	class Object
	{
		class AttributeCategories
		{
			class VASS
			{
				displayName = "VASS";
				collapsed = 1;
				class Attributes
				{
					class addAction
					{
						displayName = "";
						tooltip = "";
						property = "VASS_addAction";
						control = "VASS_addAction";
						expression = "\
							_value = parseSimpleArray _value;\
							if (_value#0 && !is3DEN) then {[_this,_value#1,parseNumber (_value#4),_value#2,parseNumber (_value#3)] call TER_fnc_addShop};\
						";
						defaultValue = "str[false,""Shop"",""alive _this && alive _target"",""5"",""1.5""]";
					};
					class cargo
					{
						property="TER_VASS_cargo";
						control="VASS_AmmoBox";
						displayName="Shop Inventory";
						tooltip="";
						expression="if (_value isEqualType '') then {\
							_value = parseSimpleArray _value;\
							_this setVariable ['TER_VASS_cargo', _value];\
							_this setVariable ['TER_VASS_cargo_default', _value];\
							};\
						";
					};
					class refresh
					{
						displayName = "Refresh";
						tooltip = "Sets the time in seconds which the shop will take to add/remove the items that were removed/added during mission.";
						property = "VASS_refesh";
						control = "EditShort";
						expression = "_this setVariable ['TER_VASS_refresh', _value];";
						defaultValue = "-1";
						validate = "number";
					};
					class shared
					{
						displayName = "Global";
						tooltip = "If checked the inventory's shop will broadcast its changes over the network and make it the same for everyone.";
						property = "VASS_shared";
						control = "Checkbox";
						expression = "_this setVariable ['TER_VASS_shared', _value];";
						defaultValue = "true";
					};
				};
			};
		};
	};
	class Attributes
	{
		class Default;
		class Title: Default
		{
			class Controls
			{
				class Title: ctrlStatic
				{
					style=1;
					x=0;
					w="48 * (pixelW * pixelGrid * 	0.50)";
					h="5 * (pixelH * pixelGrid * 	0.50)";
					colorBackground[]={0,0,0,0};
				};
			};
		};
		class TitleWide: Default
		{
			class Controls
			{
				class Title: ctrlStatic
				{
					x="5 * (pixelW * pixelGrid * 	0.50)";
					w="(	48 + 	82 - 	5) * (pixelW * pixelGrid * 	0.50)";
					h="5 * (pixelH * pixelGrid * 	0.50)";
					colorBackground[]={0,0,0,0};
				};
			};
		};
		class Checkbox;
		class VASS_AmmoBox: TitleWide
		{
			onLoad="[""onLoad"",_this] call compile preprocessfilelinenumbers ""gui\scripts\vasscargo.sqf"";";
			attributeLoad="[""attributeLoad"",[_this,_value]] call compile preprocessfilelinenumbers ""gui\scripts\vasscargo.sqf"";";
			attributeSave="[""attributeSave"",[_this]] call compile preprocessfilelinenumbers ""gui\scripts\vasscargo.sqf"";";
			h="(17 * 	5 + 1) * (pixelH * pixelGrid * 	0.50)";
			class Controls: Controls
			{
				class Title: Title
				{
					text="Content";
				};
				class exportCargo: ctrlButton
				{
					idc = IDC_VASSCARGO_BTNEXPORT;
					text = "Export";
					tooltip = "Copy the current cargo to the clipboard. The returned array can be used to set the ""TER_VASS_cargo"" variable on the object. Changes to the inventory have to be applied first by clicking the ""OK"" button.";
					x="(	48 + 	82 - 25) * (pixelW * pixelGrid * 	0.50)";
					w="25 * (pixelW * pixelGrid * 	0.50)";
					h="5 * (pixelH * pixelGrid * 	0.50)";
				};
				class Filter: ctrlToolbox
				{
					idc=IDC_VASSCARGO_TOOLFILTER;
					style="0x30 + 0x800";
					x="5 * (pixelW * pixelGrid * 	0.50)";
					y="1 * 	5 * (pixelH * pixelGrid * 	0.50)";
					w="(	48 + 	82 - 	5) * (pixelW * pixelGrid * 	0.50)";
					h="2 * 	5 * (pixelH * pixelGrid * 	0.50)";
					rows=1;
					columns=13;
					strings[]=
					{
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
				class ListBackground: ctrlStatic
				{
					x="5 * (pixelW * pixelGrid * 	0.50)";
					y="3 * 	5 * (pixelH * pixelGrid * 	0.50)";
					w="(	48 + 	82 - 	5) * (pixelW * pixelGrid * 	0.50)";
					h="13 * 	5 * (pixelH * pixelGrid * 	0.50)";
					colorBackground[]={1,1,1,0.1};
				};
				class List: ctrlListNBox
				{
					idc=IDC_VASSCARGO_LNBCARGO;
					x="5 * (pixelW * pixelGrid * 	0.50)";
					y="3 * 	5 * (pixelH * pixelGrid * 	0.50)";
					w="(	48 + 	82 - 	5) * (pixelW * pixelGrid * 	0.50)";
					h="13 * 	5 * (pixelH * pixelGrid * 	0.50)";
					drawSideArrows=1;
					idcLeft=IDC_VASSCARGO_BTNMINUS;
					idcRight=IDC_VASSCARGO_BTNPLUS;
					columns[]={0.050000001,0.15000001,0.7,0.85000002};
					disableOverflow=1;
				};
				class TextPrice: ctrlStatic
				{
					text = "Price:";
					style=0;
					x="5 * (pixelW * pixelGrid * 	0.50)";
					y="16 * 	5 * (pixelH * pixelGrid * 	0.50)";
					w="15 * (pixelW * pixelGrid * 	0.50)";
					h="5 * (pixelH * pixelGrid * 	0.50)";
				};
				class Price: ctrlEdit
				{
					idc=IDC_VASSCARGO_EDPRICE;
					x="20 * (pixelW * pixelGrid * 	0.50)";
					y="16 * 	5 * (pixelH * pixelGrid * 	0.50)";
					w="25 * (pixelW * pixelGrid * 	0.50)";
					h="5 * (pixelH * pixelGrid * 	0.50)";
				};
				class ButtonClear: ctrlButton
				{
					idc=IDC_VASSCARGO_BTNCLEAR;
					text="Clear";
					x="(	48 + 	82 - 25) * (pixelW * pixelGrid * 	0.50)";
					y="16 * 	5 * (pixelH * pixelGrid * 	0.50)";
					w="25 * (pixelW * pixelGrid * 	0.50)";
					h="5 * (pixelH * pixelGrid * 	0.50)";
				};
				class ArrowLeft: ctrlButton
				{
					idc=IDC_VASSCARGO_BTNMINUS;
					text="-";
					font="RobotoCondensedBold";
					x=-1;
					y=-1;
					w="5 * (pixelW * pixelGrid * 	0.50)";
					h="5 * (pixelH * pixelGrid * 	0.50)";
				};
				class ArrowRight: ArrowLeft
				{
					idc=IDC_VASSCARGO_BTNPLUS;
					text="+";
				};
			};
		};
		class VASS_addAction: Title
		{
			h= 5.4 * ATTRIBUTE_CONTENT_H * GRID_H;
			// Format: [Enable, Title, condition, radius, priority]
			attributeLoad="\
				_value = parseSimpleArray _value;\
				(_this controlsGroupCtrl 100) cbSetChecked (_value#0);\
				for ""_i"" from 1 to 4 do {(_this controlsGroupCtrl (100 + _i)) ctrlSetText (_value#_i);};\
			";
			attributeSave="\
				str[\
					cbChecked (_this controlsGroupCtrl 100),\
					ctrlText (_this controlsGroupCtrl 101),\
					ctrlText (_this controlsGroupCtrl 102),\
					str parseNumber ctrlText (_this controlsGroupCtrl 103),\
					str parseNumber ctrlText (_this controlsGroupCtrl 104)\
				]\
			";
			__EXEC(_y = 0)
			#define _YADD(VAL) __EXEC(_y = _y + VAL + 0.1)
			#define _Y __EVAL(_y)
			class Controls: Controls
			{
				class Title1: Title
				{
					text = "Add Shop";
					tooltip = "Enable access to the modified arsenal on this object.";
				};
				class enable: ctrlCheckboxBaseline
				{
					idc=100;
					x= ATTRIBUTE_TITLE_W * GRID_W;
					y = _Y;
					w= ATTRIBUTE_CONTENT_H * GRID_W;
					h= ATTRIBUTE_CONTENT_H * GRID_H;
				};
				_YADD(1)
				class Title2: Title
				{
					text = "addAction Title";
					tooltip = "Text shown in the scroll menu. Supports formatted text.";
					y = _Y * ATTRIBUTE_CONTENT_H * GRID_H;
				};
				class addTitle: ctrlEdit
				{
					idc = 101;
					x = ATTRIBUTE_TITLE_W * GRID_W;
					y = _Y * ATTRIBUTE_CONTENT_H * GRID_H;
					w = ATTRIBUTE_CONTENT_W * GRID_W;
					h = ATTRIBUTE_CONTENT_H * GRID_H;
				};
				_YADD(1)
				class Title3: Title
				{
					text = "Condition";
					tooltip = "Determine when the shop is accessible. Go to the addAction BIKI page for more information.";
					y = _Y * ATTRIBUTE_CONTENT_H * GRID_H;
				};
				class addCondition: addTitle
				{
					idc = 102;
					autocomplete = "scripting";
					font="EtelkaMonospacePro";
					sizeEx="3.41 * (1 / (getResolution select 3)) * pixelGrid * 0.5";
					y = _Y * ATTRIBUTE_CONTENT_H * GRID_H;
				};
				_YADD(1)
				class Title4: Title
				{
					text = "Radius";
					tooltip = "Sets from how far the player can access the shop.";
					y = _Y * ATTRIBUTE_CONTENT_H * GRID_H;
				};
				class radius: addTitle
				{
					idc = 103;
					y = _Y * ATTRIBUTE_CONTENT_H * GRID_H;
					w = round(ATTRIBUTE_CONTENT_W / 3) * GRID_W;
				};
				_YADD(1)
				class Title5: Title
				{
					text = "Priority";
					tooltip = "Higher values will place the scroll menu entry higher.";
					y = _Y * ATTRIBUTE_CONTENT_H * GRID_H;
				};
				class priority: radius
				{
					idc = 104;
					y = _Y * ATTRIBUTE_CONTENT_H * GRID_H;
				};
			};
		};
	};
};