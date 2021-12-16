/*
	Author: M1keSK

	Description:
		Set currency of shop.

	Parameter(s):
		0:	OBJECT - Shop object
		1:	STRING - currency symbol

	Returns:
		nothing

	Example(s):
		[cursorObject, "€"] call TER_fnc_setCurrency;
		[cursorObject, "£"] call TER_fnc_setCurrency;
		[cursorObject, "Ұ"] call TER_fnc_setCurrency;
*/
params ["_object", ["_currency", missionNamespace getVariable ["TER_VASS_currency", "$"]]];
_object setVariable ["TER_VASS_currency", _currency];
