/*
	Header: script_component.hpp

	Description:
		Common macros used across different files in the addon.

	Authors:
		Terra

	Includes:
		- main\script_mod.hpp
		- main\script_macros.hpp

	Included by:
		- functions\config.cpp
		- functions\Items\fn_compatibleWeapons.sqf
*/
#define COMPONENT functions
#include "\z\TER_VASS\addons\main\script_mod.hpp"

// #define DEBUG_ENABLED_functions

#ifdef DEBUG_ENABLED_functions
    #define DEBUG_MODE_FULL
#endif
#ifdef DEBUG_SETTINGS_OTHER
    #define DEBUG_SETTINGS DEBUG_SETTINGS_functions
#endif

#include "\z\TER_VASS\addons\main\script_macros.hpp"
