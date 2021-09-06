/*
	Author: Terra

	Description:
		Returns the config of a weapon, backpack or magazine.

	Parameter(s):
		0:	STRING - Classname of the item

	Returns:
		CONFIG - The config of the item.

	Example(s):
		["arifle_AK12_F"] call TER_VASS_fnc_itemConfig; //-> bin\config.bin/CfgWeapons/arifle_AK12_F
*/
params ["_class"];
private _subConfigs = ["CfgWeapons", "CfgVehicles", "CfgMagazines", "CfgGlasses"];
private _config = {
	private _testConfig = configFile >> _x >> _class;
	if (isClass _testConfig) exitWith { _testConfig };
	configNull
} forEach _subConfigs;
_config
