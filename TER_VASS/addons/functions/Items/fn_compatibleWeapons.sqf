/*
	Author: Terra

	Description:
		__DESCRIPTION___

	Parameter(s):
		0:	__TYPE__ - __EXPLANATION__
		Optional:
		N:	__TYPE___ - __EXPLANATION__
			Default: __DEFAULT___

	Returns:
		__TYPE__ - __EXPLANATION___

	Example(s):
		__PARAMETER__ __EXECUTIONMETHOD__ __FUNCTION___; //-> __RETURN__
*/
#include "..\script_component.hpp"
params ["_item"];
//--- Check all weapon configs for this item
private _weapons = [];
{
	private _weapon = configName _x;
	if (
		_item in ([_weapon] call BIS_fnc_compatibleItems) &&
		([_weapon] call BIS_fnc_baseWeapon) == _weapon
	) then {
		_weapons pushBack _weapon;
	};
} forEach ("getNumber(_x>>'scope') == 2" configClasses (configFile >> "CfgWeapons"));
_weapons
