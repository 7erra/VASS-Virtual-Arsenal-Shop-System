/*
	Author: Terra

	Description:
		Adds a shop to an object. Requires a config class in "CfgShopsVASS".

	Parameter(s):
		0:	OBJECT - Object to attach the shop to
		1:	STRING - Config subclass of "CfgShops" either from missionConfigFile or configFile

	Returns:
		NUMBER - addAction ID, also saved as TER_VASS_actionID_%shop% where %shop% is the second parameter

	Example(s):
		[cursorObject, "Weapons"] call TER_VASS_fnc_addShop; //-> 0
*/
params ["_object", "_shop"];
if (isNull _object) exitWith {["Object does not exist!", _object] call BIS_fnc_error};
private _cfg = {
	private _xCfg = _x >> "CfgShopsVASS" >> _shop;
	if !(isNull (_xCfg)) exitWith {_xCfg};
	configNull
} forEach [missionConfigFile, configFile];
if (isNull _cfg) exitWith {["Shop config ""%1"" does not exist!", _shop] call BIS_fnc_error};
//--- Fill the shop with items
private _cargoObject = createSimpleObject ["Static", [0, 0, 0], true]; // placeholder object to allow for multiple shops
_cargoObject attachTo [_object, [0,0,0]];
_object setVariable [["TER_VASS_cargoObject_%1", _shop], _cargoObject];
_object addEventHandler ["Deleted", { // delete the placeholder together with the object
	params ["_object"];
	deleteVehicle (_object getVariable [format ["TER_VASS_cargoObject_%1", _shop], objNull]);
}];
private _cfgCargo = _cfg >> "Cargo";
{
	private _cfgCargoType = _cfgCargo >> _x;
	private _classes = ("true" configClasses _cfgCargoType) apply {configName _x};
	[_cargoObject, _classes , nil, false, 1, _forEachIndex] call BIS_fnc_addVirtualItemCargo;
} forEach ["Items", "Weapons", "Magazines", "Backpacks"];
//--- Add the action to the object
private _script = {
	params ["_target", "_caller", "_actionID", "_arguments"];
	_arguments params ["_cargoObject"];
	["Open",[nil,_cargoObject,_caller]] call BIS_fnc_arsenal;
};

private _cfgAddAction = _cfg >> "AddAction";
private _actionID = _object addAction [
	getText(_cfgAddAction >> "title"),
	_script,
	[_cargoObject],
	getNumber(_cfgAddAction >> "priority"),
	getNumber(_cfgAddAction >> "showWindow") == 1,
	getNumber(_cfgAddAction >> "hideOnUse") == 1,
	getText(_cfgAddAction >> "shortcut"),
	getText(_cfgAddAction >> "condition"),
	getNumber(_cfgAddAction >> "radius"),
	getNumber(_cfgAddAction >> "unconscious") == 1,
	getText(_cfgAddAction >> "selection"),
	getText(_cfgAddAction >> "memeoryPoint")
];
_object setVariable [format["TER_VASS_actionID_%1", _shop], _actionID];

//--- Update shops array but only if the shop hasn't been added yet
if (isNil "TER_VASS_allShops") then {
	TER_VASS_allShops = [];
};
if (TER_VASS_allShops pushBackUnique _object > -1) then {
	publicVariable "TER_VASS_allShops";
};
_actionID
