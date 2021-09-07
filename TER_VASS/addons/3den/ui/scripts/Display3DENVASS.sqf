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
			private _items = flatten (missionNamespace getVariable "bis_fnc_arsenal_data");
			//--- Add acessories, since they are not included in the arsenal data
			private _accessories = (
				"getNumber(_x >> 'type') == 131072 &&"+
				"getNumber(_x >> 'scope') == 2"
			) configClasses (configFile >> "CfgWeapons") apply {
				configName _x;
			};
			_items append _accessories;
			["fillList", [_display, _items]] call SELF;
		};
		//--- Set up the UI
		private _ctrlSearch = _display displayCtrl IDC_DISPLAY3DENVASS_SEARCH;
		_ctrlSearch ctrlAddEventHandler ["KeyUp", {
			with uiNamespace do {["search", _this] call SELF;};
		}];
		private _ctrlFilter = _display displayCtrl IDC_DISPLAY3DENVASS_FILTER;
		_ctrlFilter ctrlAddEventHandler ["CheckBoxesSelChanged", {
			with uiNamespace do {["checkboxesChanged", _this] call SELF;};
		}];
		private _ctrlFilterAll = _display displayCtrl IDC_DISPLAY3DENVASS_FILTERALL;
		_ctrlFilterAll ctrlAddEventHandler ["ButtonClick",{
			with uiNamespace do {["filterToggle", [_this#0, false]] call SELF;};
		}];
		private _ctrlFilterNone = _display displayCtrl IDC_DISPLAY3DENVASS_FILTERNONE;
		_ctrlFilterNone ctrlAddEventHandler ["ButtonClick",{
			with uiNamespace do {["filterToggle", [_this#0, true]] call SELF;};
		}];
		diag_log [_ctrlFilterAll, _ctrlFilterNone];
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

		//--- Iterate over all items and create the controls for each
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
			if (!fileExists _image) then {
				_image = "\a3\ui_f\data\Map\Markers\Military\unknown_CA.paa";
			};
			_ctrlImage ctrlSetText _image;

			_ctrlClass = _display ctrlCreate ["RscStructuredText", IDC_DISPLAY3DENVASS_ITEM_CLASS, _ctrlItem];
			_ctrlClass ctrlSetPosition [
				(H_ROW + 1) * GRID_W,
				0,
				100 * GRID_W,
				H_ROW * GRID_H
			];
			_ctrlClass ctrlCommit 0;
			private _displayName = [_itemConfig] call BIS_fnc_displayName;
			_ctrlClass ctrlSetStructuredText parseText format [
				"%1<br/><t font='EtelkaMonospaceProBold' size='0.6'>%2</t>",
				_displayName,
				_class
			];
			
			private _ctrlLabelPrice = _display ctrlCreate ["ctrlStructuredText", -1, _ctrlItem];
			_ctrlLabelPrice ctrlSetPosition [
				(H_ROW + 102) * GRID_W,
				2 * GRID_H,
				15 * GRID_W,
				5 * GRID_H
			];
			_ctrlLabelPrice ctrlCommit 0;
			_ctrlLabelPrice ctrlSetText "Price:";
			
			private _ctrlPrice = _display ctrlCreate ["ctrlEdit", IDC_DISPLAY3DENVASS_ITEM_PRICE, _ctrlItem];
			_ctrlPrice ctrlSetPosition [
				(H_ROW + 117) * GRID_W,
				2 * GRID_H,
				50 * GRID_W,
				5 * GRID_H
			];
			_ctrlPrice ctrlCommit 0;

			private _ctrlLabelAmount = _display ctrlCreate ["ctrlStructuredText", -1, _ctrlItem];
			_ctrlLabelAmount ctrlSetPosition [
				(H_ROW + 102) * GRID_W,
				(H_ROW - 7) * GRID_H,
				15 * GRID_W,
				5 * GRID_H
			];
			_ctrlLabelAmount ctrlCommit 0;
			_ctrlLabelAmount ctrlSetText "Amount:";

			private _ctrlAmount = _display ctrlCreate ["ctrlEdit", IDC_DISPLAY3DENVASS_ITEM_AMOUNT, _ctrlItem];
			_ctrlAmount ctrlSetPosition [
				(H_ROW + 117) * GRID_W,
				(H_ROW - 7) * GRID_H,
				50 * GRID_W,
				5 * GRID_H
			];
			_ctrlAmount ctrlCommit 0;

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
		["filter", ctrlParent _ctrlSearch] call SELF;
		ctrlSetFocus _ctrlSearch; // The above function call unfocuses the search bar
	};
	case "filter":{
		_params params ["_display"];
		private _ctrlSearch = _display displayCtrl IDC_DISPLAY3DENVASS_SEARCH;
		private _ctrlFilter = _display displayCtrl IDC_DISPLAY3DENVASS_FILTER;
		private _searchText = ctrlText _ctrlSearch;
		private _y = 0;
		{
			//--- Check filters:
			private _class = _x getVariable "classname";
			//--- Item types:
			private _arsenalData = missionNamespace getVariable "bis_fnc_arsenal_data";
			private _dataIndex = _arsenalData findIf {_class in _x};
			if (_dataIndex == -1) then {
				//--- Attachments do not have a data index as they are not part
				//--- of the arsenal data
				_dataIndex = switch (_class call BIS_fnc_itemType select 1) do {
					case "AccessoryMuzzle": {IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE};
					case "AccessoryPointer": {IDC_RSCDISPLAYARSENAL_TAB_ITEMACC};
					case "AccessorySights": {IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC};
					case "AccessoryBipod": {IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD};
					default {-1};
				};
			};
			private _excluded = for "_i" from 0 to (lnbSize _ctrlFilter select 1) do {
				if (_ctrlFilter lbValue _i == _dataIndex) exitWith {
					_ctrlFilter ctrlChecked _i
				};
				false
			};
			//--- Use search query:
			private _filterSearch = 
				toLower _searchText in toLower(_class) ||
				toLower _searchText in toLower(_x getVariable "displayname");
			if (_filterSearch && !_excluded) then {
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
	case "checkboxesChanged":{
		_params params ["_ctrlCheckboxes", "_ind", "_state"];
		if (_ctrlCheckboxes getVariable ["noUpdate", false]) exitWith {};
		private _display = ctrlParent _ctrlCheckboxes;
		["filter", _display] call SELF;
	};
	case "filterToggle":{
		_params params ["_ctrlFilterToggle", "_state"];
		private _display = ctrlParent _ctrlFilterToggle;
		_ctrlFilter = _display displayCtrl IDC_DISPLAY3DENVASS_FILTER;
		//--- Prevent the triggering of the CheckBoxesSelChanged for every category
		_ctrlFilter setVariable ["noUpdate", true];
		for "_i" from 0 to (lnbSize _ctrlFilter select 1) do {
			_ctrlFilter ctrlSetChecked [_i, _state];
		};
		_ctrlFilter setVariable ["noUpdate", nil];
		//--- Instead do it only once when all changes are applied
		["filter", _display] call SELF;
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
