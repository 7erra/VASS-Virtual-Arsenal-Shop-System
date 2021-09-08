#include "script_component.hpp"
#define SELF UISCRIPT(VASS_AmmoBox2)
params ["_mode", "_params"];
//diag_log ["VASS_AmmoBox2.sqf", _this];
private _display = uiNamespace getVariable "Display3DENEditAttributes";
switch _mode do {
	case "onLoad":{
		_params params ["_ctrlGroup"];
		private _ctrlEdit = _ctrlGroup controlsGroupCtrl IDC_VASS_AMMOBOX2_EDIT;
		_ctrlEdit ctrlAddEventHandler ["ButtonClick", {
			with uiNamespace do {["edit", _this] call SELF;};
		}];
	};
	case "edit":{
		_params params ["_ctrlEdit"];
		private _display = ctrlParent _ctrlEdit;
		private _ctrlGroup = ctrlParentControlsGroup _ctrlEdit;
		private _ctrlList = _ctrlGroup controlsGroupCtrl IDC_VASS_AMMOBOX2_LIST;
		private _cargo = ctrlText _ctrlList;
		if (_cargo == "") then {
			_cargo = [];
		} else {
			_cargo = parseSimpleArray _cargo;
		};
		//_display setVariable ["TER_VASS_cargo", _cargo];
		private _display3denVass = _display createDisplay "Display3DENVASS";
		["fillList", [_display3denVass, _cargo]] spawn UISCRIPT(Display3DENVASS);
	};

	//--- Eden related
	case "attributeLoad": {
		_params params ["_ctrlGroup", "_value"];
		_ctrlList = _ctrlGroup controlsGroupCtrl 100;
		_ctrlList ctrlSetText _value;
	};
	case "attributeSave": {
		_params params ["_ctrlGroup"];
		_ctrlList = _ctrlGroup controlsGroupCtrl 100;
		ctrlText _ctrlList
	};
};
