#include "\a3\3DEN\UI\macros.inc"
#include "gui\scripts\idcs.inc"
class ctrlButton;
class ctrlListNBox;
class ctrlStatic;
class ctrlToolbox;
class ctrlEdit;
class ctrlCheckboxBaseline;
class ctrlCombo;
class ctrlControlsGroup;
class ctrlStructuredText;
class Cfg3den
{
	class Mission
	{
		class Scenario
		{
			class AttributeCategories
			{
				class VASS_moneySystem
				{
					displayName = "VASS - Money System";
					class Attributes
					{
						class VASS_mission_money
						{
							displayName = "Enable VASS Money System";
							tooltip = "Enable or disable the use of the money system.";
							property = "VASS_moneyEnable";
							control = "Checkbox";
							expression = "\
								if (_value && !is3den) then {\
									if (isnil 'vass_db') then {vass_db = []};\
									[vass_db, ['settings', 'money', 'enable'], true] call BIS_fnc_dbValueSet;\
								};\
							";
							defaultValue = "false";
						};
					};
				};
			};
		};
	};
	*/
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
						tooltip = "Define the items which the trader can sell and buy.\n""-"" means the item is not part of the shop, so not buyable or sellable. Script: -2.\n""∞"" means that the item will never run out. Script: -1.\n""0"" means that the item is not sold by the shop but can be sold to the trader. Script: 0.\nAny other number restricts the amonut of sellable items to the specified amount. If all items are sold out it is treated just as ""0"". Script: N.";
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
						tooltip = "Sets the time in seconds which the shop will take to add/remove the items that were removed/added during mission. -1 disables refreshing.";
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
					w = ATTRIBUTE_TITLE_W * GRID_W;
					h = ATTRIBUTE_CONTENT_H * GRID_H;
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
					x = ATTRIBUTE_CONTENT_H * GRID_W;
					w = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - ATTRIBUTE_CONTENT_H) * GRID_W;
					h = ATTRIBUTE_CONTENT_H * GRID_H;
					colorBackground[]={0,0,0,0};
				};
			};
		};
		#define _YADD(VAL) __EXEC(_y = _y + VAL + 0.1)
		#define _Y __EVAL(_y)
		__EXEC(_y = 0)
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
		__EXEC(_y = 0)
		class VASS_AmmoBox: TitleWide
		{
			// DEBUG
			/*
			onLoad = "[""onLoad"",_this] call compile preprocessfilelinenumbers ""gui\scripts\vasscargo.sqf"";";
			attributeLoad="[""attributeLoad"",[_this,_value,true]] call compile preprocessfilelinenumbers ""gui\scripts\vasscargo.sqf"";";
			attributeSave="[""attributeSave"",[_this]] call compile preprocessfilelinenumbers ""gui\scripts\vasscargo.sqf"";";
			*/
			// MOD
			
			onLoad = "[""onLoad"",_this] call TER_fnc_vasscargo;";
			attributeLoad = "[""attributeLoad"",[_this,_value,true]] call TER_fnc_vasscargo;";
			attributeSave = "[""attributeSave"",[_this]] call TER_fnc_vasscargo;";
			
			h = (17 * ATTRIBUTE_CONTENT_H + 1) * GRID_H;
			class Controls: Controls
			{
				class Title: Title
				{
					//text="Content";
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
				_YADD(1)
				class grpArrayEdit: ctrlControlsGroup
				{
					idc = IDC_VASSCARGO_GRPCARGOARRAY;
					fade = 1;
					x = ATTRIBUTE_CONTENT_H * GRID_W;
					y = _Y * ATTRIBUTE_CONTENT_H * GRID_H;
					w = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - ATTRIBUTE_CONTENT_H) * GRID_W;
					h = (2 + 13 - 0.1) * ATTRIBUTE_CONTENT_H * GRID_H;
					class controls
					{
						class arrayEdit: ctrlEdit
						{
							idc = IDC_VASSCARGO_EDCARGOARRAY;
							style = "0x00 + 0x10";
							font="EtelkaMonospacePro";
							sizeEx="3.41 * (1 / (getResolution select 3)) * pixelGrid * 0.5";
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
					idc=IDC_VASSCARGO_TOOLFILTER;
					style="0x30 + 0x800";
					x = ATTRIBUTE_CONTENT_H * GRID_W;
					y = _Y * ATTRIBUTE_CONTENT_H * GRID_H;
					w = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - ATTRIBUTE_CONTENT_H) * GRID_W;
					h = 2 * ATTRIBUTE_CONTENT_H * GRID_H;
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
				}; _YADD(1.9)
				class ListBackground: Title
				{
					idc = IDC_VASSCARGO_STATICLISTBACKGROUND;
					x = ATTRIBUTE_CONTENT_H * GRID_W;
					y = _Y * ATTRIBUTE_CONTENT_H * GRID_H;
					w = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - ATTRIBUTE_CONTENT_H) * GRID_W;
					h = 13 * ATTRIBUTE_CONTENT_H * GRID_H;
					colorBackground[]={1,1,1,0.1};
				};
				class List: ctrlListNBox
				{
					idc=IDC_VASSCARGO_LNBCARGO;
					//style = 32;
					x = ATTRIBUTE_CONTENT_H * GRID_W;
					y = _Y * ATTRIBUTE_CONTENT_H * GRID_H;
					w = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - ATTRIBUTE_CONTENT_H) * GRID_W;
					h = 13 * ATTRIBUTE_CONTENT_H * GRID_H;
					drawSideArrows=1;
					idcLeft=IDC_VASSCARGO_BTNMINUS;
					idcRight=IDC_VASSCARGO_BTNPLUS;
					columns[]={0.050000001,0.15000001,0.7,0.85000002};
					disableOverflow=1;
				}; _YADD(12.9)
				class Validate: ctrlStructuredText
				{
					idc = IDC_VASSCARGO_TXTVALIDATE;
					x = ATTRIBUTE_CONTENT_H * GRID_W;
					y = _Y * ATTRIBUTE_CONTENT_H * GRID_H;
					w = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - ATTRIBUTE_CONTENT_H) * GRID_W;
					h = 1 * ATTRIBUTE_CONTENT_H * GRID_H;
				};
				class BtnValidate: ctrlButton
				{
					idc = IDC_VASSCARGO_BTNVALIDATE;
					text = "Validate";
					x = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - 25) * GRID_W;
					y = _Y * ATTRIBUTE_CONTENT_H * GRID_H;
					w = 25 * GRID_W;
					h = ATTRIBUTE_CONTENT_H * GRID_H;
				};
				class TextPrice: Title
				{
					idc = IDC_VASSCARGO_TITLEPRICE;
					text = "Price:";
					style=0;
					x = ATTRIBUTE_CONTENT_H * GRID_W;
					y = _Y * ATTRIBUTE_CONTENT_H * GRID_H;
					w = 15 * GRID_W;
				};
				class Price: ctrlEdit
				{
					idc=IDC_VASSCARGO_EDPRICE;
					x = 20 * GRID_W;
					y = _Y * ATTRIBUTE_CONTENT_H * GRID_H;
					w = 25 * GRID_W;
					h = ATTRIBUTE_CONTENT_H * GRID_H;
				};
				class ButtonClear: ctrlButton
				{
					idc=IDC_VASSCARGO_BTNCLEAR;
					text="Clear";
					x = (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - 25) * GRID_W;
					y = _Y * ATTRIBUTE_CONTENT_H * GRID_H;
					w = 25 * GRID_W;
					h = ATTRIBUTE_CONTENT_H * GRID_H;
				};/* _YADD(1)
				
				class TextFactionFilter: Title
				{
					text = "Filter by faction";
					tooltip = "Only show items which the given faction uses.";
					style = 1;
					x = 0;
					y = _Y * ATTRIBUTE_CONTENT_H * GRID_H;
					w = ATTRIBUTE_TITLE_W * GRID_W;
					h = ATTRIBUTE_CONTENT_H * GRID_H;
				};
				class FactionFilter: ctrlCombo
				{
					idc = IDC_VASSCARGO_COMBOPRESETS;
					x = ATTRIBUTE_TITLE_W * GRID_W;
					y = _Y * ATTRIBUTE_CONTENT_H * GRID_H;
					w = ATTRIBUTE_CONTENT_W * GRID_W;
					h = ATTRIBUTE_CONTENT_H * GRID_H;
				};
				*/
				class ArrowLeft: ctrlButton
				{
					idc=IDC_VASSCARGO_BTNMINUS;
					text="-";
					font="RobotoCondensedBold";
					x = -1;
					y = -1;
					w = ATTRIBUTE_CONTENT_H * GRID_W;
					h = ATTRIBUTE_CONTENT_H * GRID_H;
				};
				class ArrowRight: ArrowLeft
				{
					idc=IDC_VASSCARGO_BTNPLUS;
					text="+";
				};
			};
		};
	};
};