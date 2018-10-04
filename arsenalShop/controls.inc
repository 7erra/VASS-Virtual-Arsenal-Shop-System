#include "\a3\ui_f\hpp\defineresincldesign.inc"
#define GUI_GRID_X	(safezoneX)
#define GUI_GRID_Y	(safezoneY + safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))
#define GUI_GRID_W	(((safezoneW / safezoneH) min 1.2) / 40)
#define GUI_GRID_H	((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)
#define GUI_GRID_WAbs	((safezoneW / safezoneH) min 1.2)
#define GUI_GRID_HAbs	(((safezoneW / safezoneH) min 1.2) / 1.2)

//default arsenal
#define ARSENAL_DISPLAY (uiNamespace getVariable "RscDisplayArsenal")
#define ARSENAL_CTRL(IDC) (ARSENAL_DISPLAY displayCtrl IDC)
//default controls
#define GRP_CONTROLSBAR_CONTROLBAR ARSENAL_CTRL(IDC_RSCDISPLAYARSENAL_CONTROLSBAR_CONTROLBAR)
#define BTN_OK ARSENAL_CTRL(IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONOK)
#define LB_LIST_WEAPONS ARSENAL_CTRL(IDC_RSCDISPLAYARSENAL_LIST)
#define ATTACHMENT_LBS [ARSENAL_CTRL(978),ARSENAL_CTRL(979),ARSENAL_CTRL(980),ARSENAL_CTRL(985)]
#define BTN_MINUS ARSENAL_CTRL(IDC_RSCDISPLAYARSENAL_ARROWLEFT)
#define BTN_PLUS ARSENAL_CTRL(IDC_RSCDISPLAYARSENAL_ARROWRIGHT)
#define LBNS_RIGHT [\
	ARSENAL_CTRL(981),\
	ARSENAL_CTRL(986),\
	ARSENAL_CTRL(982),\
	ARSENAL_CTRL(983),\
	ARSENAL_CTRL(984)\
]

//custom controls
#define BTN_BUY ARSENAL_CTRL(7300)
#define STXT_MONEY ARSENAL_CTRL(7301)
#define STXT_ITEMCOST ARSENAL_CTRL(7302)