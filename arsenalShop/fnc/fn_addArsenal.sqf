/*
	Author: 7erra <https://forums.bohemia.net/profile/1139559-7erra/>

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

	Examples:
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
_costArray = call TER_costArray;
_shopItems = _costArray select {_x isEqualType "STRING"};
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
			case "Mine": {"Magazine"};
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