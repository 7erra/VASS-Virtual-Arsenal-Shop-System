#define GLUE_3(A,B,C) A##B##C
#define ARSENAL_ICON(NAME) QUOTE(GLUE_3(\a3\ui_f\data\GUI\Rsc\RscDisplayArsenal\,NAME,_ca.paa))
class Display3DENVASS
{
	INIT_DISPLAY(Display3DENVASS,TER_VASS_3den)
	idd = IDD_DISPLAY3DENVASS;
	class ControlsBackground
	{
		class BackgroundDisable: ctrlStaticBackgroundDisable{};
		class BackgroundDisableTiles: ctrlStaticBackgroundDisableTiles{};
		class Background: ctrlStaticBackground
		{
			x = safeZoneX + 5 * GRID_W;
			y = safeZoneY + 10 * GRID_H;
			w = safeZoneW - 10 * GRID_W;
			h = safeZoneH - 15 * GRID_H;
		};
		class BackgroundButtons: ctrlStaticFooter
		{
			x = safeZoneX + 5 * GRID_W;
			y = safeZoneY + safeZoneH - 12 * GRID_H;
			w = safeZoneW - 10 * GRID_W;
			h = 7 * GRID_H;
		};
		class Title: ctrlStaticTitle
		{
			text = "VASS Inventory";
			x = safeZoneX + 5 * GRID_W;
			y = safeZoneY + 5 * GRID_H;
			w = safeZoneW - 10 * GRID_W;
			h = 5 * GRID_H;
		};
	};
	class Controls
	{
		class Filter: ctrlCheckboxes
		{
			idc = IDC_DISPLAY3DENVASS_FILTER;
			style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
			x = safeZoneX + 6 * GRID_W;
			y = safeZoneY + 11 * GRID_H;
			w = safeZoneW - 23 * GRID_W;
			h = 10 * GRID_H;
			strings[] = {
				ARSENAL_ICON(primaryWeapon),
				ARSENAL_ICON(secondaryWeapon),
				ARSENAL_ICON(handgun),
				ARSENAL_ICON(uniform),
				ARSENAL_ICON(vest),
				ARSENAL_ICON(backpack),
				ARSENAL_ICON(headgear),
				ARSENAL_ICON(goggles),
				ARSENAL_ICON(nvgs),
				ARSENAL_ICON(binoculars),
				ARSENAL_ICON(map),
				ARSENAL_ICON(gps),
				ARSENAL_ICON(radio),
				ARSENAL_ICON(compass),
				ARSENAL_ICON(watch),
				
				ARSENAL_ICON(itemOptic),
				ARSENAL_ICON(itemAcc),
				ARSENAL_ICON(itemMuzzle),
				ARSENAL_ICON(itemBipod),

				ARSENAL_ICON(cargoThrow),
				ARSENAL_ICON(cargoPut),
				ARSENAL_ICON(cargoMisc),
				ARSENAL_ICON(cargoMag)
			};
			values[] = {
				IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON,
				IDC_RSCDISPLAYARSENAL_TAB_SECONDARYWEAPON,
				IDC_RSCDISPLAYARSENAL_TAB_HANDGUN,
				IDC_RSCDISPLAYARSENAL_TAB_UNIFORM,
				IDC_RSCDISPLAYARSENAL_TAB_VEST,
				IDC_RSCDISPLAYARSENAL_TAB_BACKPACK,
				IDC_RSCDISPLAYARSENAL_TAB_HEADGEAR,
				IDC_RSCDISPLAYARSENAL_TAB_GOGGLES,
				IDC_RSCDISPLAYARSENAL_TAB_NVGS,
				IDC_RSCDISPLAYARSENAL_TAB_BINOCULARS,
				IDC_RSCDISPLAYARSENAL_TAB_MAP,
				IDC_RSCDISPLAYARSENAL_TAB_GPS,
				IDC_RSCDISPLAYARSENAL_TAB_RADIO,
				IDC_RSCDISPLAYARSENAL_TAB_COMPASS,
				IDC_RSCDISPLAYARSENAL_TAB_WATCH,
				// IDC_RSCDISPLAYARSENAL_TAB_FACE,
				// IDC_RSCDISPLAYARSENAL_TAB_VOICE,
				// IDC_RSCDISPLAYARSENAL_TAB_INSIGNIA,
				IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC,
				IDC_RSCDISPLAYARSENAL_TAB_ITEMACC,
				IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE,
				IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD,
				// IDC_RSCDISPLAYARSENAL_TAB_CARGOMAG,
				IDC_RSCDISPLAYARSENAL_TAB_CARGOTHROW,
				IDC_RSCDISPLAYARSENAL_TAB_CARGOPUT,
				IDC_RSCDISPLAYARSENAL_TAB_CARGOMISC,
				IDC_RSCDISPLAYARSENAL_TAB_CARGOMAGALL
			};
			colorTextSelect[] = {0.5,0,0,1};
			colorText[] = {0,0.5,0,1};
			colorSelectedBg[] = {0,0,0,0};
			rows = 1;
			columns = 23;
		};
		class FilterAll: ctrlButton
		{
			idc = IDC_DISPLAY3DENVASS_FILTERALL;
			text = "ALL";
			x = safeZoneX + safeZoneW - 12 * GRID_W - 5 * GRID_W;
			y = safeZoneY + 11 * GRID_H;
			w = 10 * GRID_W;
			h = 5 * GRID_H;
			colorBackground[] = {0,0,0,0.5};
		};
		class FilterNone: FilterAll
		{
			idc = IDC_DISPLAY3DENVASS_FILTERNONE;
			text = "NONE";
			y = safeZoneY + 16 * GRID_H;
		};
		class LabelSearch: ctrlStructuredText
		{
			text = "Search:";
			x = safeZoneX + 6 * GRID_W;
			y = safeZoneY + 22 * GRID_H;
			w = 15 * GRID_W;
			h = 5 * GRID_H;
		};
		class Search: ctrlEdit
		{
			idc = IDC_DISPLAY3DENVASS_SEARCH;
			x = safeZoneX + 22 * GRID_W;
			y = safeZoneY + 22 * GRID_H;
			w = safeZoneW - 28 * GRID_W;
			h = 5 * GRID_H;
		};
		class Cargo: ctrlControlsGroup
		{
			idc = IDC_DISPLAY3DENVASS_CARGO;
			x = safeZoneX + 6 * GRID_W;
			y = safeZoneY + 28 * GRID_H;
			w = safeZoneW - 12 * GRID_W;
			h = safeZoneH - 41 * GRID_H;
			colorBackground[] = {1,0,0,0.5};
		};
		class Cancel: ctrlButtonCancel
		{
			x = safeZoneX + 6 * GRID_W;
			y = safeZoneY + safeZoneH - 11 * GRID_H;
			w = 25 * GRID_W;
			h = 5 * GRID_H;
		};
		class Save: ctrlButtonOK
		{
			x = safeZoneX + safeZoneW - 31 * GRID_W;
			y = safeZoneY + safeZoneH - 11 * GRID_H;
			w = 25 * GRID_W;
			h = 5 * GRID_H;
		};
	};
};
