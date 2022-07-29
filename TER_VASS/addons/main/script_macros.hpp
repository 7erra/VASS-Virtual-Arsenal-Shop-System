/*
	Header: script_macros.hpp

	Description:
		TODO

	Authors:
		Terra

	Includes:
		- main\script_macros_common.hpp

	Included by:
		- 3den\script_component.hpp
		- functions\script_component.hpp
		- language\script_component.hpp
		- main\script_component.hpp
		- main\script_macros_common.hpp
*/
#include "script_macros_common.hpp"

#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)

#ifdef DISABLE_COMPILE_CACHE
    #undef PREP
    #define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)
#else
    #undef PREP
    #define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif

#ifdef DEBUG_MODE_FULL
    #undef MAINPREFIX
	#define MAINPREFIX p
#endif
