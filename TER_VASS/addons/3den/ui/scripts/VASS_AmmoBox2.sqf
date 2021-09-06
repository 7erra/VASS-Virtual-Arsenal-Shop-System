#include "script_component.hpp"
#define SELF UISCRIPT(VASS_AmmoBox2)
params ["_mode", "_params"];
diag_log ["VASS_AmmoBox2.sqf", _this];
private _display = uiNamespace getVariable "Display3DENEditAttributes";
switch _mode do {
	case "onLoad":{
	};

	//--- Eden related
	case "attributeLoad": {
		_params params ["_ctrlGroup", "_value"];
		_ctrlList = _ctrlGroup controlsGroupCtrl 100;
		diag_log str [_value];
		_ctrlList ctrlSetText _value;
	};
	case "attributeSave": {
		_params params ["_ctrlGroup"];
		_ctrlList = _ctrlGroup controlsGroupCtrl 100;
		ctrlText _ctrlList
	};
};
