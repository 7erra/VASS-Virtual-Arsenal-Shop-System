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
		- language\config.cpp
*/
#define COMPONENT language
#include "\z\TER_VASS\addons\main\script_mod.hpp"

// #define DEBUG_ENABLED_language

#ifdef DEBUG_ENABLED_language
    #define DEBUG_MODE_FULL
#endif
#ifdef DEBUG_SETTINGS_OTHER
    #define DEBUG_SETTINGS DEBUG_SETTINGS_language
#endif

#include "\z\TER_VASS\addons\main\script_macros.hpp"
