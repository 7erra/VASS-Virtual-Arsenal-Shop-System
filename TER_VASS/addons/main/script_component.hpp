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
		- main\config.cpp
		- main\script_macros_common.hpp
*/
#define COMPONENT main
#include "\z\TER_VASS\addons\main\script_mod.hpp"

// #define DEBUG_ENABLED_MAIN
// #define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_MAIN
    #define DEBUG_MODE_FULL
#endif
    #ifdef DEBUG_SETTINGS_MAIN
    #define DEBUG_SETTINGS DEBUG_SETTINGS_MAIN
#endif

#include "\z\TER_VASS\addons\main\script_macros.hpp"
