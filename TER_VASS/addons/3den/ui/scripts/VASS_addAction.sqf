#include "script_component.hpp"
params ["_mode", "_params"];
switch _mode do {
	case "attributeLoad": {
		_params params ["_ctrlGroup", "_value"];
		if (_value isEqualType true) then {
			_value = [false, "Shop", "alive _this && alive _target", 5, 1.5];
		};
		(_ctrlGroup controlsGroupCtrl 100) cbSetChecked (_value#0);
		{
			private _ctrlX = _ctrlGroup controlsGroupCtrl (IDC_VASS_ADDACTION_TITLE + _forEachIndex);
			_ctrlX ctrlSetText ([str _x, _x] select (_x isEqualType ""));
		} forEach (_value select [1,4]);
	};
	case "attributeSave":{
		_params params ["_ctrlGroup"];
		[
			cbChecked (_ctrlGroup controlsGroupCtrl IDC_VASS_ADDACTION_ENABLE),
			ctrlText (_ctrlGroup controlsGroupCtrl IDC_VASS_ADDACTION_TITLE),
			ctrlText (_ctrlGroup controlsGroupCtrl IDC_VASS_ADDACTION_CONDITION),
			parseNumber ctrlText (_ctrlGroup controlsGroupCtrl IDC_VASS_ADDACTION_RADIUS),
			parseNumber ctrlText (_ctrlGroup controlsGroupCtrl IDC_VASS_ADDACTION_PRIORITY)
		];
	};
};
