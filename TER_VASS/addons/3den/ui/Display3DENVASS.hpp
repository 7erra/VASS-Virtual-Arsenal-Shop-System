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
			w = safeZoneW - 12 * GRID_W;
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

				ARSENAL_ICON(cargoMag),
				ARSENAL_ICON(cargoThrow),
				ARSENAL_ICON(cargoPut),
				ARSENAL_ICON(cargoMisc)
			};
			colorTextSelect[] = {0,0.5,0,1};
			colorText[] = {0.5,0,0,1};
			colorSelectedBg[] = {0,0,0,0};
			rows = 1;
			columns = 23;
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
