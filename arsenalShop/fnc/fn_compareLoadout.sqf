/*
	Author: 7erra

	Description:
	Returns all different items between two loadouts.

	Parameter(s):
	0: ARRAY - array A in format getUnitLoadout
	1: ARRAY - array B in format getUnitLoadout

	Returns:
	ARRAY - Array of items
*/

params ["_previousLoadout","_newLoadout"];
_KK_fnc_arrayFlatten = {
    private ["_res", "_fnc"];
    _res = [];
    _fnc = {
        {
            if (typeName _x isEqualTo "ARRAY") then [
                {_x call _fnc; false},
                {_res pushBack _x; false}
            ];
        } count _this;
    };
    _this call _fnc;
    _res
};

_pItems = [];
_nItems = [];
_fnc1DLoadout = {
	_loadout = _this;
	_array = [];
	// handle weapons
	_weaponArrays = _loadout select [0,3];
	_weaponArrays pushBack (_loadout select 8);
	{
		_curArray = _x;
		_flatArray = _curArray call _KK_fnc_arrayFlatten;
		_flatArray = _flatArray select {_x isEqualType ""};
		_array append _flatArray;
	} forEach _weaponArrays;
	// handle container
	_containers = _loadout select [3,3];
	_containersAsItems = _containers apply {
		if (count _x > 0) then {_x select 0}
		else {""};
	};
	_array append _containersAsItems;
	_containerItemArrays = _containers apply {
			if (count _x > 0) then {_x select 1}
			else {nil}
	};
	_containerItemArrays = _containerItemArrays -[nil];
	{
		if !(isNil "_x") then {
			_curContainer = _x;
			{
				if (count _x > 0) then {
					for "_i" from 1 to (_x select 1) do {
						_array pushBack (_x select 0);
					};
				};
			} forEach _curContainer;
		};
	} forEach _containerItemArrays;
	// helmet, facewear
	_array = _array +(_loadout select [6,1]);
	//assigned items
	_array = _array +(_loadout select 9);

	_array = _array -["",nil];
	_array
};

_pItems = _previousLoadout call _fnc1DLoadout;
_nItems = _newLoadout call _fnc1DLoadout;
_changedItems = [_nItems,_pItems] call TER_fnc_arrayChange;
_changedItems

/*
[
	["arifle_MX_F","muzzle_snds_H","acc_pointer_IR","optic_Aco",["30Rnd_65x39_caseless_mag",30],[],"bipod_01_F_blk"],
	["launch_NLAW_F","","","",[],[],""],
	["hgun_Pistol_heavy_01_F","muzzle_snds_acp","acc_flashlight_pistol","",[],[],""],
	["U_B_CombatUniform_mcam",[["FirstAidKit",1],["30Rnd_65x39_caseless_mag",2,30],["Chemlight_green",1,1],["16Rnd_9x21_Mag",1,16]]],
	["V_PlateCarrier1_rgr",[["30Rnd_65x39_caseless_mag",9,30],["16Rnd_9x21_Mag",2,16],["HandGrenade",2,1],["SmokeShell",1,1],["SmokeShellGreen",1,1],["Chemlight_green",1,1]]],
	["B_Bergen_mcamo_F",[]],
	"H_HelmetB_grass",
	"G_Aviator",
	["Rangefinder","","","",[],[],""],
	["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch","NVGoggles"]
]
*/
