/*
	Author: Terra

	Description:
		Checks if a string is a number. parseNumber can parse strings like
		"123abc" to 123 but this function does not allow that.

	Parameter(s):
		0:	STRING - STRING to be checked

	Returns:
		BOOL - true when string is a number

	Example(s):
		"123" call TER_fnc_validNumber; //-> true
		"-123" call TER_fnc_validNumber; //-> true
		"123.45" call TER_fnc_validNumber; //-> true
		"-123.45" call TER_fnc_validNumber; //-> true
		"1e+6" call TER_fnc_validNumber; //-> true
		"-1e+6" call TER_fnc_validNumber; //-> true
		"hello" call TER_fnc_validNumber; //-> false
*/
params ["_string"];
_string regexMatch "^-?\d*\.?\d*(?:[eE](?:\+|\-))?\d*\.?\d+$"
