#include "script_component.hpp"
#define SELF UISCRIPT(VASS_AmmoBox2)
params ["_mode", "_params"];
diag_log _this;
private _display = uiNamespace getVariable "Display3DENEditAttributes";
switch _mode do {
	case "onLoad":{
		_params params ["_control"];
		private _ctrlCargo = _control controlsGroupCtrl 100;
		for "_i" from 1 to 50 do {
			[_ctrlCargo] call _fnc_createRow;
		};
	};
	case "createRow":{
		params ["_ctrlGroup"];
		//--- Container group for row controls
		private _ctrlRowGroup = _display ctrlCreate ["ctrlControlsGroupNoScrollbars", -1, _ctrlGroup];
		_ctrlRowGroup ctrlSetPosition [
			0,
			(({ctrlParentControlsGroup _x == _ctrlGroup} count allControls _ctrlGroup) - 1) * 6 * GRID_H,
			W_VASS_AMMOBOX2 * GRID_W,
			5 * GRID_H
		];
		_ctrlRowGroup ctrlCommit 0;

		_ctrlClassname = _display ctrlCreate ["ctrlStructuredText", -1, _ctrlRowGroup];
		_ctrlClassname ctrlSetPosition [
			0, // x
			0, // y
			0.5 * W_VASS_AMMOBOX2 * GRID_W, // w
			5 * GRID_H // h
		];
		_ctrlClassname ctrlCommit 0;
		_ctrlClassname ctrlSetBackgroundColor [1,0,0,1];
		

		[_ctrlRowGroup, [_ctrlClassname]]
	};
};
