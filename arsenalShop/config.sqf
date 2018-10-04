/* Config part, change to your liking */
TER_moneyNameSpace = player;
TER_moneyVariable = "TER_money";
TER_moneyUnit = "$";

TER_costArray = [// add your entries in the format >"classname",cost<
	"arifle_AK12_F",100,
	"arifle_AKM_F",50,
	"arifle_MX_F",75,
	"hgun_P07_F",20,
	"optic_DMS",10,
	"optic_ACO_grn",5,
	"B_AssaultPack_mcamo_Ammo",25,
	"B_AssaultPack_mcamo_Ammo",10,
	"U_B_CombatUniform_mcam",15,
	"30Rnd_762x39_Mag_F",5,
	"30Rnd_65x39_caseless_mag",13
];
/* end of config */

  ///////////////////////////////////////////////////////////////////////////////
 ////			 		Set up system, pls dont change 						////
///////////////////////////////////////////////////////////////////////////////
TER_costArray = TER_costArray +["",0];
TER_costArray = TER_costArray apply {
	if (_x isEqualType "STRING") then {
		toLower _x
	} else {
		_x
	};
};

TER_fnc_addArsenal = {
	/*
		Description:
		Add an arsenal with all things of which the cost is defined

		Parameter(s):
		 0: Object - Object to add the arsenal to
		 1: BOOLEAN - add for everyone

		Returns:
		Bool - True when done

		Example:
		[this,true] call TER_fnc_addArsenal;
	*/

	params ["_box",["_global",true]];
	{
		_itemType = _x call BIS_fnc_itemType;
		_itemType params ["_category","_type"];
		// possible categorys:
		// Weapon, Item, Equipment, Magazine, Mine
		_typeFnc = switch _category do {
			case "Equipment": {["Item","Backpack"] select (_type == "Backpack")};
			case "Mine": {"Item"};
			default {_category};
		};
		_fncAdd = format ["BIS_fnc_addVirtual%1Cargo",_typeFnc];
		if (!isNil _fncAdd) then {
			_fncAdd = call compile _fncAdd;
			_return = [_box, _x, _global, true] call _fncAdd;
		};
	} forEach (TER_costArray select {_x isEqualType "STRING"});

	true
};

TER_fnc_itemCostFromTable = {
	/*
		Description:
		Get the cost of an item

		Parameter(s):
		 0: STRING - Item classname

		Returns:
		NUMBER - cost from the cost array

		Example:
		_itemCost = "arifle_AK12_F" call TER_fnc_itemCostFromTable;
	*/
	params ["_classname"];
	_costIndex = TER_costArray find toLower _classname;
	_itemCost = [TER_costArray select (_costIndex +1), 0] select (_costIndex == -1); // if object is not registered then set cost to 0
	_itemCost
};

[missionNamespace, "arsenalOpened", compile preprocessFileLineNumbers "arsenalShop\arsenalEHOpen.sqf"] call BIS_fnc_addScriptedEventHandler;
