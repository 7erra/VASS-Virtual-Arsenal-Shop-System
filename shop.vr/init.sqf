{
	_x setVariable ["TER_fnc_shop",compile preprocessFileLineNumbers "VASS\fnc\fn_shop.sqf"];
} forEach [uiNamespace, missionNamespace];
["initsystem"] call TER_fnc_shop;
