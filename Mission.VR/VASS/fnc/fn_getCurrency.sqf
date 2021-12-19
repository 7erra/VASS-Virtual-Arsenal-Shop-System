/*
	Author: M1keSK

	Description:
		Get currency of shop.

	Parameter(s):
		0:	OBJECT - Shop object

	Returns:
		STRING - return currency symbol for shop

	Example(s):
		[cursorObject] call TER_fnc_getCurrency; //-> $
*/
params ["_object"];
private _currency = _object getVariable ["TER_VASS_currency", missionNamespace getVariable ["TER_VASS_currency", "$"]];

_currency