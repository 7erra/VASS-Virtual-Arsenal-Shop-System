#include "script_component.hpp"
#define SELF UISCRIPT(Display3DENVASS)
#define H_ROW 15
params ["_mode", "_params"];
switch _mode do {
	case "onLoad":{
		_params params ["_display"];
		//--- Load the arsenal data to missionNamespace
		_params spawn {
			params ["_display"];
			with missionNamespace do {
				["Preload"] call BIS_fnc_arsenal;
			};
			["fillList", [_display, flatten (missionNamespace getVariable "bis_fnc_arsenal_data")]] call SELF;
		};
		//--- Set up the UI
		private _ctrlSearch = _display displayCtrl IDC_DISPLAY3DENVASS_SEARCH;
		_ctrlSearch ctrlAddEventHandler ["KeyDown", {
			with uiNamespace do {["search", _this] spawn SELF;};
		}];
	};
	case "fillList":{
		_params params ["_display", "_list"];
		//--- Sort the list by alphabet
		_list = _list apply {
			private _config = [_x] call TER_VASS_fnc_itemConfig;
			private _displayName = [_config] call BIS_fnc_displayName;

			[_displayName, _config, _x]
		};
		_list sort true;
		private _ctrlCargo = _display displayCtrl IDC_DISPLAY3DENVASS_CARGO;
		{
			_x params ["_displayName", "_itemConfig", "_class"];

			private _ctrlItem = _display ctrlCreate ["ctrlControlsGroupNoScrollbars", -1, _ctrlCargo];
			_ctrlItem ctrlSetPosition [
				0,
				_forEachIndex * (H_ROW + 1) * GRID_H,
				safeZoneW - 12 * GRID_W,
				H_ROW * GRID_H
			];
			_ctrlItem ctrlCommit 0;

			private _ctrlBackground = _display ctrlCreate ["ctrlStatic", -1, _ctrlItem];
			_ctrlBackground ctrlSetPosition [
				0,
				0,
				safeZoneW - 12 * GRID_W,
				H_ROW * GRID_H
			];
			_ctrlBackground ctrlCommit 0;
			_ctrlBackground ctrlSetBackgroundColor [0.3,0.3,0.3,1];

			private _ctrlImage = _display ctrlCreate ["RscPictureKeepAspect", IDC_DISPLAY3DENVASS_ITEM_PICTURE, _ctrlItem];
			_ctrlImage ctrlSetPosition [
				0,
				0,
				H_ROW * GRID_W,
				H_ROW * GRID_H
			];
			_ctrlImage ctrlCommit 0;
			private _image = getText(_itemConfig >> "picture");
			if (_image == "") then {
				_image = "\a3\ui_f\data\Map\Markers\Military\unknown_CA.paa";
			};
			_ctrlImage ctrlSetText _image;

			_ctrlClass = _display ctrlCreate ["RscStructuredText", IDC_DISPLAY3DENVASS_ITEM_CLASS, _ctrlItem];
			_ctrlClass ctrlSetPosition [
				(H_ROW + 1) * GRID_W,
				0,
				safeZoneW - (12 - (H_ROW + 1)) * GRID_W,
				H_ROW * GRID_H
			];
			_ctrlClass ctrlCommit 0;
			private _displayName = [_itemConfig] call BIS_fnc_displayName;
			_ctrlClass ctrlSetStructuredText parseText format [
				"%1<br/><t font='EtelkaMonospaceProBold' size='0.6'>%2</t>",
				_displayName,
				_class
			];

			_ctrlItem setVariable ["classname", _class];
			_ctrlItem setVariable ["config", _itemConfig];
			_ctrlItem setVariable ["displayname", _displayName];
		} forEach _list;
		["filter", [_display]] call SELF;
	};
	case "search":{
		_params params ["_ctrlSearch"];
		if (ctrlText _ctrlSearch == _ctrlSearch getVariable ["lastSearch", ""]) exitWith {};
		_ctrlSearch setVariable ["lastSearch", ctrlText _ctrlSearch];
		private _display = ctrlParent _ctrlSearch;
		private _focCtrl = focusedCtrl _display;
		diag_log [
			_focCtrl,
			ctrlClassName _focCtrl
		];
		["filter", ctrlParent _ctrlSearch] call SELF;
		private _focCtrl = focusedCtrl _display;
		diag_log [
			_focCtrl,
			ctrlClassName _focCtrl
		];
	};
	case "filter":{
		_params params ["_display"];
		private _ctrlSearch = _display displayCtrl IDC_DISPLAY3DENVASS_SEARCH;
		private _searchText = ctrlText _ctrlSearch;
		private _y = 0;
		{
			private _filterApplies = 
				toLower _searchText in toLower(_x getVariable "classname") ||
				toLower _searchText in toLower(_x getVariable "displayname");
			if (_filterApplies) then {
				_x ctrlShow true; // This is bugged. It forces focus to another control for some reason...
				_x ctrlSetPositionY (_y * (H_ROW + 1) * GRID_H);
				_y = _y + 1;
			} else {
				_x ctrlShow false;
				_x ctrlSetPositionY 0;
			};
			_x ctrlCommit 0;
		} forEach (["getItemControls", _display] call SELF);
	};
	case "getItemControls":{
		_params params ["_display"];
		private _ctrlCargo = _display displayCtrl IDC_DISPLAY3DENVASS_CARGO;
		private _controls = allControls _ctrlCargo select {
			ctrlParentControlsGroup _x == _ctrlCargo
		};
		_controls
	};
	case "checkFilter":{
		_params params ["_ctrlItem"];
	};
	case "onUnload":{
		_params params ["_display", "_exitCode"];
		if (_exitCode == 1) then {
			get3DENSelected "object" apply {
				_x set3DENAttribute ["TER_VASS_cargo", str [
					"class0", 100, 1,
					"class1", 200, 2
				]];
			};
		};
	};
};
