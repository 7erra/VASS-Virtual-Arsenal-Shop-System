systemChat str _this;
if (_mode == "load") then {
	params ["_mode","_this","_value"];
	_checked = if (_value isEqualTo "") then {
		(parseSimpleArray _value)#0
	} else {
		false
	};
	(_this controlsGroupCtrl 100) cbsetchecked _checked;
} else {
	params ["_this"];
	str[
		cbChecked _this,
		get3DENAttribute
	]
};
