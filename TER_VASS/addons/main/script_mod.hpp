/*
	Header: script_mod.hpp

	Description:
		Settings that affect the mod.

	Authors:
		Terra

	Includes:
		- main\script_version.hpp

	Included by:
		- 3den\script_component.hpp
		- functions\script_component.hpp
		- language\script_component.hpp
		- main\script_component.hpp
*/
#define MAINPREFIX z
#define PREFIX TER_VASS

#include "script_version.hpp"

#define VERSION MAJOR.MINOR.PATCH.BUILD
#define VERSION_AR MAJOR,MINOR,PATCH,BUILD

#define REQUIRED_VERSION 2.06
