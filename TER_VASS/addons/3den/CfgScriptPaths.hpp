/*
	Header: CfgScriptPaths.hpp

	Description:
		Used by BIS_fnc_initDisplay to compile UI functions.
		https://community.bistudio.com/wiki/GUI_Tutorial#BIS_fnc_initDisplay

	Authors:
		Terra

	Includes:
		None

	Included by:
		- 3den\config.cpp
*/
class CfgScriptPaths
{
	DOUBLES(PREFIX,COMPONENT) = PATHTOF(ui\scripts\);
};
