///////////////////////////////////////////////////////////////////////////////////////////////////

//--- Logo
#define COMMON_LOGO \
	class BcgLogo: RscBackgroundLogo \
	{ \
		idc = 11300; \
	};

//--- WIP Warning
#define COMMON_WIP \
	class BcgWIP: RscWIP \
	{ \
		idc = 11400; \
	};
	
//--- WIP Disclaimer
//#define COMMON_DISCLAIMER \
//	class BcgDisclaimer: RscIngameDisclaimer \
//	{ \
//		idc = 11401; \
//	};

//--- DLC Vehicle and weapon notification IDC_DLC_ACTION_NOTIFICATION_GROUP 11406
#define DLC_ACTION_NOTIFICATION \
	class DLCActionNotification: DLCActionNotification \
	{ \
		idc = IDC_DLC_ACTION_NOTIFICATION_GROUP; \
	};

//--- Base background
#define COMMON_BACKGROUND_BASE(WIN_X,WIN_Y,WIN_W,WIN_H,ID) \
	class BcgCommon##ID##: RscBackgroundGUI \
	{ \
		idc = 11000##ID##; \
		backgroundType = 0##ID##; \
		x = WIN_X; \
		y = WIN_Y; \
		w = WIN_W; \
		h = WIN_H; \
	}; \
	class BcgCommonLeft##ID##: RscBackgroundGUILeft \
	{ \
		idc = 11200##ID##; \
		backgroundType = 0##ID##; \
		x = WIN_X; \
		y = WIN_Y; \
		w = WIN_W; \
		h = WIN_H; \
	}; \
	class BcgCommonRight##ID##: RscBackgroundGUIRight \
	{ \
		idc = 11201##ID##; \
		backgroundType = 0##ID##; \
		x = WIN_X; \
		y = WIN_Y; \
		w = WIN_W; \
		h = WIN_H; \
	}; \
	class BcgCommonBottom##ID##: RscBackgroundGUIBottom \
	{ \
		idc = 11001##ID##; \
		backgroundType = 0##ID##; \
		x = WIN_X; \
		y = WIN_Y + WIN_H - (1 * GUI_GRID_OLD_H); \
		w = WIN_W; \
		h = 1 * GUI_GRID_OLD_H; \
	}; \
	class BcgCommonTop##ID##: RscBackgroundGUITop \
	{ \
		idc = 11002##ID##; \
		backgroundType = 0##ID##; \
		x = WIN_X; \
		y = WIN_Y; \
		w = WIN_W; \
		h = 1 * GUI_GRID_OLD_H; \
	};

#define COMMON_BACKGROUND_VIGNETTE \
	class Vignette: RscVignette \
	{ \
		idc = 114998; \
	};

#define BCGTILE(posX,posY) \
	class Tile_##posX##_##posY##: RscText \
	{ \
		idc = 1150##posX####posY##; \
		x = (##posX## * 1/6) * safezoneW; \
		y = (##posY## * 1/6) * safezoneH; \
		w = 1/6 * safezoneW; \
		h = 1/6 * safezoneH; \
		colorBackground[] = {0,0,0,0.1}; \
	};
#define COMMON_BACKGROUND_TILES_OLD(CLASS_NAME)\
	class TileGroup: RscControlsGroupNoScrollbars\
	{\
		idc = 115099;\
		x = safezoneX;\
		y = safezoneY;\
		w = safezoneW;\
		h = safezoneH;\
		disableCustomColors = 1;\
		onLoad = [ctrlParent (_this select 0), #CLASS_NAME] call (uiNamespace getVariable 'BIS_fnc_guiEffectTiles');\
		class Controls\
		{\
			class TileFrame: RscFrame\
			{\
				idc = 114999;\
				x = 0;\
				y = 0;\
				w = safezoneW;\
				h = safezoneH;\
				colortext[] = {0,0,0,1};\
			};\
			BCGTILE(0,0)\
			BCGTILE(0,1)\
			BCGTILE(0,2)\
			BCGTILE(0,3)\
			BCGTILE(0,4)\
			BCGTILE(0,5)\
			BCGTILE(1,0)\
			BCGTILE(1,1)\
			BCGTILE(1,2)\
			BCGTILE(1,3)\
			BCGTILE(1,4)\
			BCGTILE(1,5)\
			BCGTILE(2,0)\
			BCGTILE(2,1)\
			BCGTILE(2,2)\
			BCGTILE(2,3)\
			BCGTILE(2,4)\
			BCGTILE(2,5)\
			BCGTILE(3,0)\
			BCGTILE(3,1)\
			BCGTILE(3,2)\
			BCGTILE(3,3)\
			BCGTILE(3,4)\
			BCGTILE(3,5)\
			BCGTILE(4,0)\
			BCGTILE(4,1)\
			BCGTILE(4,2)\
			BCGTILE(4,3)\
			BCGTILE(4,4)\
			BCGTILE(4,5)\
			BCGTILE(5,0)\
			BCGTILE(5,1)\
			BCGTILE(5,2)\
			BCGTILE(5,3)\
			BCGTILE(5,4)\
			BCGTILE(5,5)\
		}\
	};


#define COMMON_BACKGROUND_TILES\
	class TileGroup: RscControlsGroupNoScrollbars\
	{\
		idc = 115099;\
		x = safezoneXAbs;\
		y = safezoneY;\
		w = safezoneWAbs;\
		h = safezoneH;\
		class Controls\
		{\
			class Background: RscText\
			{\
				idc = 114999;\
				x = 0;\
				y = 0;\
				w = safezoneWAbs;\
				h = safezoneH;\
				colorBackground[] = {0,0,0,0.5};\
			};\
		};\
	};


//--- Background
#define COMMON_BACKGROUND(WIN_X,WIN_Y,WIN_W,WIN_H) \
	COMMON_BACKGROUND_VIGNETTE \
	COMMON_BACKGROUND_TILES \
	COMMON_BACKGROUND_BASE(WIN_X,WIN_Y,WIN_W,WIN_H,)

//--- Base background Dark
#define COMMON_BACKGROUND_DARK_BASE(WIN_X,WIN_Y,WIN_W,WIN_H,ID) \
	COMMON_BACKGROUND_BASE(WIN_X,WIN_Y,WIN_W,WIN_H,ID) \
	class BcgCommonDark##ID##: RscBackgroundGUIDark \
	{ \
		idc = 11100##ID##; \
		backgroundType = 0##ID##; \
		x = WIN_X; \
		y = WIN_Y; \
		w = WIN_W; \
		h = WIN_H; \
	};

//--- Background Dark
#define COMMON_BACKGROUND_DARK(WIN_X,WIN_Y,WIN_W,WIN_H) \
	COMMON_BACKGROUND_DARK_BASE(WIN_X,WIN_Y,WIN_W,WIN_H,)

//--- Demo background
#ifdef	_DEMO
	#define COMMON_BACKGROUND(WIN_X,WIN_Y,WIN_W,WIN_H) \
		COMMON_WIP \
		COMMON_BACKGROUND_BASE(WIN_X,WIN_Y,WIN_W,WIN_H,)
#endif


//--- Resizable background
#define COMMON_BACKGROUND_SCRIPTED \
	COMMON_BACKGROUND( \
		(uinamespace getvariable 'RscBackground_X'), \
		(uinamespace getvariable 'RscBackground_Y'), \
		(uinamespace getvariable 'RscBackground_W'), \
		(uinamespace getvariable 'RscBackground_H') \
	)

//--- Fullscreen Background of insert dialogues in mission editor
#define EDITOR_INSERT_BACKGROUND \
	class FullscreenBackground: RscText \
	{ \
		idc = -1; \
		x = SafezoneX; \
		y = SafezoneY; \
		w = SafezoneW; \
		h = SafezoneH; \
		colorBackground[] = {0.7, 0.7, 0.7, 0.8}; \
	};