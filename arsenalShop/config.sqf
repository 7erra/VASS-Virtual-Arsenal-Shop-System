/* Config part, change to your liking */
TER_moneyNameSpace = player; // where the money variable is saved
TER_moneyVariable = "TER_money"; // name of the money variable
TER_moneyUnit = "$"; // added behind all numbers which represent currency (duh)
//eg >player getVariable "TER_money";< will return the current amount of money the player has

TER_costArray = [// add your entries in the format >"classname",cost<
	"arifle_AK12_F",100,
	"arifle_AKM_F",50,
	"arifle_MX_F",75,
	"hgun_P07_F",20,
	"optic_DMS",10,
	"optic_ACO_grn",5,
	"B_AssaultPack_mcamo",25,
	"U_B_CombatUniform_mcam",15,
	"30Rnd_762x39_Mag_F",5,
	"30Rnd_65x39_caseless_mag",13
];

/* end of config */

  ///////////////////////////////////////////////////////////////////////////////
 ////			 		Set up system, pls dont change 						////
///////////////////////////////////////////////////////////////////////////////
// adjust the cost table
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

		 Optional:
		 1: STRING or ARRAY OF STRINGS - Only add specific item types (Categories from https://community.bistudio.com/wiki/BIS_fnc_itemType)
		 	default: []
		 2: STRING - "add" or "remove" arsenal items
		 	default: "add"
		 3: BOOLEAN - add for everyone
		 	default: true

		Returns:
		Bool - True when done

		Example:
		 [this,[],true] call TER_fnc_addArsenal; <- Full shop
		 [this,["Weapon"]] call TER_fnc_addArsenal; <- Weapon shop
		 [this,["Magazine"],"remove"] call TER_fnc_addArsenal; <- remove magazines from shop
	*/

	params [
		"_box",
		["_shopTypes",[]],
		["_addOrRemove","add"],
		["_global",true]
	];
	_shopItems = TER_costArray select {_x isEqualType "STRING"};
	if (_shopTypes isEqualType "") then {_shopTypes = [_shopTypes]};
	_all = false;
	if (count _shopTypes == 0) then {_all = true};
	_shopTypes = _shopTypes apply {toLower _x};
	{
		_itemType = _x call BIS_fnc_itemType;
		_itemType params ["_category","_type"];
		// possible categorys:
		// Weapon, Item, Equipment, Magazine, Mine
		if (
			toLower _category in _shopTypes OR
			toLower _type in _shopTypes OR
			_all
		) then {
			_typeFnc = switch _category do {
				case "Equipment": {["Item","Backpack"] select (_type == "Backpack")};
				case "Mine": {"Item"};
				default {_category};
			};
			_fncAdd = format ["BIS_fnc_%1Virtual%2Cargo",_addOrRemove,_typeFnc];
			if (!isNil _fncAdd) then {
				_fncAdd = call compile _fncAdd;
				_return = [_box, _x, _global, true] call _fncAdd;
			};
		};
	} forEach _shopItems;

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

// this is where the magic happens:
TER_fnc_arsenalEH = compile preprocessFileLineNumbers "arsenalShop\arsenalEH.sqf";
TER_arsenalOpenedEHID = [missionNamespace, "arsenalOpened", TER_fnc_arsenalEH] call BIS_fnc_addScriptedEventHandler;