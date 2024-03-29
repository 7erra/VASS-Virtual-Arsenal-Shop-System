/*
	Header: script_component.hpp

	Description:
		Common macros used across the addon.

	Authors:
		Terra

	Includes:
		- main\script_mod.hpp
		- main\script_macros.hpp
		- \a3\3DEN\UI\macros.inc
		- \a3\3den\UI\resincl.inc
		- \a3\ui_f\hpp\defineResinclDesign.inc

	Included by:
		- 3den\config.cpp
		- 3den\ui\scripts\script_component.hpp
*/
#define COMPONENT 3den
#include "\z\TER_VASS\addons\main\script_mod.hpp"

// #define DEBUG_ENABLED_3den

#ifdef DEBUG_ENABLED_3den
    #define DEBUG_MODE_FULL
#endif
#ifdef DEBUG_SETTINGS_OTHER
    #define DEBUG_SETTINGS DEBUG_SETTINGS_3den
#endif

#include "\z\TER_VASS\addons\main\script_macros.hpp"
#include "\a3\3DEN\UI\macros.inc"
#include "\a3\3den\UI\resincl.inc"
#include "\a3\ui_f\hpp\defineResinclDesign.inc"
#define CT_CONTROLS_TABLE 19

#ifdef DEBUG_MODE_FULL
    #define INIT_DISPLAY_FUNCTION (compileScript [QUOTE(\p\TER_VASS\addons\3den\ui\scripts\NAME.sqf)])
    #define UISCRIPT(NAME) (compileScript [QUOTE(\p\TER_VASS\addons\3den\ui\scripts\NAME.sqf)])
    #define ATTRIBUTE_SCRIPT(ATT) UISCRIPT(ATT)
#else
    #define UISCRIPT(NAME) NAME##_script
    #define ATTRIBUTE_SCRIPT(ATT) (uinamespace getVariable QUOTE(UISCRIPT(ATT)))
#endif

#define W_VASS_AMMOBOX2 (ATTRIBUTE_TITLE_W + ATTRIBUTE_CONTENT_W - 5)

//--- Display idcs
#define IDC_VASSCARGO_TOOLFILTER 7100
#define IDC_VASSCARGO_LNBCARGO 7101
#define IDC_VASSCARGO_BTNCLEAR 7102
#define IDC_VASSCARGO_BTNMINUS 7103
#define IDC_VASSCARGO_BTNPLUS 7104
#define IDC_VASSCARGO_EDPRICE 7105
#define IDC_VASSCARGO_BTNEXPORT 7106
#define IDC_VASSCARGO_COMBOPRESETS 7107
#define IDC_VASSCARGO_BTNIMPORT 7108
#define IDC_VASSCARGO_TOOLVIEW 7109
#define IDC_VASSCARGO_EDCARGOARRAY 7110
#define IDC_VASSCARGO_STATICLISTBACKGROUND 7111
#define IDC_VASSCARGO_TITLEPRICE 7112
#define IDC_VASSCARGO_GRPCARGOARRAY 7113
#define IDC_VASSCARGO_TXTVALIDATE 7114
#define IDC_VASSCARGO_BTNVALIDATE 7115

//--- Displays
//--- VASS Cargo v2
#define IDD_DISPLAY3DENVASS 210806
#define IDC_DISPLAY3DENVASS_FILTER 100
#define IDC_DISPLAY3DENVASS_CARGO 101
#define IDC_DISPLAY3DENVASS_SEARCH 102
#define IDC_DISPLAY3DENVASS_FILTERALL 103
#define IDC_DISPLAY3DENVASS_FILTERNONE 104
#define IDC_DISPLAY3DENVASS_ITEM_PICTURE 1000
#define IDC_DISPLAY3DENVASS_ITEM_CLASS 1001
#define IDC_DISPLAY3DENVASS_ITEM_PRICE 1002
#define IDC_DISPLAY3DENVASS_ITEM_AMOUNT 1003

//--- 3den Attributes
//--- Ammobox (cargo)
#define IDC_VASS_AMMOBOX2_LIST 100
#define IDC_VASS_AMMOBOX2_EDIT 101

//--- addAction
#define IDC_VASS_ADDACTION_ENABLE 100
#define IDC_VASS_ADDACTION_TITLE 101
#define IDC_VASS_ADDACTION_CONDITION 102
#define IDC_VASS_ADDACTION_RADIUS 103
#define IDC_VASS_ADDACTION_PRIORITY 104
