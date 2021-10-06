/*
	Author: Terra

	Description:
		Returns all weapons that can use the given attachment. Basically the
		counterpart of BIS_fnc_compatibleItems.

	Parameter(s):
		0:	STRING - Classname of the item

	Returns:
		ARRAY of STRINGs - Weapon classnames

	Example(s):
		["bipod_01_F_blk"] call TER_VASS_fnc_compatibleWeapons; //-> ["srifle_DMR_01_F","srifle_EBR_F","LMG_Mk200_F",...
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
