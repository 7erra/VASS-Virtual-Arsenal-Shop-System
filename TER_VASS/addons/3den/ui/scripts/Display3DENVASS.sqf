#include "script_component.hpp"
#define SELF UISCRIPT(Display3DENVASS)
#define H_ROW 15
params ["_mode", "_params"];
switch _mode do {
	case "onLoad":{
		_params params ["_display"];
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
	};
	case "fillList":{
		#undef DEBUG_MODE_FULL
		_params params ["_display", ["_cargo", []]];
		with missionNamespace do {
			["Preload"] call BIS_fnc_arsenal;
		};
		#ifndef DEBUG_MODE_FULL
		["Display3DENVASS"] call BIS_fnc_startLoadingScreen;
		#endif
		private _items = flatten (missionNamespace getVariable "bis_fnc_arsenal_data");
		//--- Add acessories, since they are not included in the arsenal data
		private _accessories = (
			"getNumber(_x >> 'type') == 131072 && "+
			"getNumber(_x >> 'scope') == 2 && "+
			"!(configName _x in _items)"
		) configClasses (configFile >> "CfgWeapons") apply {
			configName _x;
		};
		_items append _accessories;
		
		//--- Sort the list by alphabet
		_items = _items apply {
			private _config = [_x] call TER_VASS_fnc_itemConfig;
			private _displayName = [_config] call BIS_fnc_displayName;

			[_displayName, _config]
		};
		_items sort true;
		_items = _items apply {_x#1};

		//--- Iterate over all items and create the controls for each
		private _ctrlCargo = _display displayCtrl IDC_DISPLAY3DENVASS_CARGO;
		{
			["createItemControls", [_display, _x, _forEachIndex, _cargo]] call SELF;
			#ifndef DEBUG_MODE_FULL
			[_forEachIndex/(count _items)] call BIS_fnc_progressLoadingScreen;
			#else
			if (_forEachIndex > 10) exitWith {};
			#endif
		} forEach _items;
		["filter", [_display]] call SELF;
		#ifndef DEBUG_MODE_FULL
		["Display3DENVASS"] call BIS_fnc_endLoadingScreen;
		#endif
	};
	case "createItemControls":{
		_params params ["_display", "_config", "_ind", "_cargo"];
		private _class = configName _config;
		private _name = [_config] call BIS_fnc_displayName;
		private _ctrlCargo = _display displayCtrl IDC_DISPLAY3DENVASS_CARGO;
		private _wGroup = ctrlPosition _ctrlCargo select 2;
		
		private _ctrlItem = _display ctrlCreate ["ctrlControlsGroupNoScrollbars", -1, _ctrlCargo];
		_ctrlItem ctrlSetPosition [
			0,
			_ind * (H_ROW + 1) * GRID_H,
			_wGroup,
			H_ROW * GRID_H
		];
		_ctrlItem ctrlCommit 0;
		_ctrlItem setVariable ["classname", _class];
		_ctrlItem setVariable ["config", _config];
		_ctrlItem setVariable ["displayname", _name];

		private _ctrlBackground = _display ctrlCreate ["ctrlStatic", -1, _ctrlItem];
		_ctrlBackground ctrlSetPosition [
			0,
			0,
			_wGroup,
			H_ROW * GRID_H
		];
		_ctrlBackground ctrlCommit 0;
		_ctrlBackground ctrlSetBackgroundColor [0.3,0.3,0.3,1];

		private _curX = 0;
		private _ctrlImage = _display ctrlCreate ["RscPictureKeepAspect", IDC_DISPLAY3DENVASS_ITEM_PICTURE, _ctrlItem];
		_ctrlImage ctrlSetPosition [
			_curX,
			0,
			H_ROW * GRID_W,
			H_ROW * GRID_H
		];
		_ctrlImage ctrlCommit 0;
		_curX = _curX + (ctrlPosition _ctrlImage select 2);
		private _image = getText(_config >> "picture");
		_ctrlImage ctrlSetText _image;

		_ctrlClass = _display ctrlCreate ["RscStructuredText", IDC_DISPLAY3DENVASS_ITEM_CLASS, _ctrlItem];
		_ctrlClass ctrlSetPosition [
			_curX,
			0,
			_wGroup - (H_ROW + 15 + 50 + 4) * GRID_W,
			H_ROW * GRID_H
		];
		_ctrlClass ctrlCommit 0;
		_ctrlClass ctrlSetStructuredText parseText format [
			"%1<br/><t font='EtelkaMonospaceProBold' size='0.6'>%2</t>",
			_name,
			_class
		];
		
		_curX = _wGroup - 69 * GRID_W;
		private _ctrlLabelPrice = _display ctrlCreate ["ctrlStructuredText", -1, _ctrlItem];
		_ctrlLabelPrice ctrlSetPosition [
			_curX,
			2 * GRID_H,
			15 * GRID_W,
			5 * GRID_H
		];
		_ctrlLabelPrice ctrlCommit 0;
		_ctrlLabelPrice ctrlSetText localize "STR_TER_VASS_Display3DENVASS_LabelPrice_text";

		private _ctrlLabelAmount = _display ctrlCreate ["ctrlStructuredText", -1, _ctrlItem];
		_ctrlLabelAmount ctrlSetPosition [
			_curX,
			(H_ROW - 7) * GRID_H,
			15 * GRID_W,
			5 * GRID_H
		];
		_ctrlLabelAmount ctrlCommit 0;
		_ctrlLabelAmount ctrlSetText localize "STR_TER_VASS_Display3DENVASS_LabelAmount_text";
		_ctrlLabelAmount ctrlSetTooltip localize "STR_TER_VASS_Display3DENVASS_LabelAmount_tooltip";
		
		_curX = _wGroup - 54 * GRID_W;
		private _ctrlPrice = _display ctrlCreate ["ctrlEdit", IDC_DISPLAY3DENVASS_ITEM_PRICE, _ctrlItem];
		_ctrlPrice ctrlSetPosition [
			_curX,
			2 * GRID_H,
			50 * GRID_W,
			5 * GRID_H
		];
		_ctrlPrice ctrlCommit 0;

		private _ctrlAmount = _display ctrlCreate ["ctrlEdit", IDC_DISPLAY3DENVASS_ITEM_AMOUNT, _ctrlItem];
		_ctrlAmount ctrlSetPosition [
			_curX,
			(H_ROW - 7) * GRID_H,
			50 * GRID_W,
			5 * GRID_H
		];
		_ctrlAmount ctrlCommit 0;

		//--- Get the item's price and amount
		private _ind = _cargo find _class;
		if (_ind > -1) then {
			private _price = _cargo select (_ind + 1);
			_ctrlPrice ctrlSetText str _price;
			private _amount = _cargo select (_ind + 2);
			_ctrlAmount ctrlSetText str _amount;
		};
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
		if (_exitCode != 1) exitWith {};
		//--- Changes confirmed, set to 3den attribute display
		private _ctrlList = _display getVariable "ctrlList";
		private _list = [];
		{
			private _class = _x getVariable "classname";
			private _ctrlPrice = _x controlsGroupCtrl IDC_DISPLAY3DENVASS_ITEM_PRICE;
			private _ctrlAmount = _x controlsGroupCtrl IDC_DISPLAY3DENVASS_ITEM_AMOUNT;
			private _amount = ctrlText _ctrlAmount;
			if (_amount == "true" || {parseNumber _amount > 0}) then {
				if (_amount != "true") then {
					_amount = parseNumber _amount;
				} else {
					_amount = _amount == "true";
				};
				//--- Valid, add
				private _price = parseNumber ctrlText _ctrlPrice;
				_list append [_class, _price, _amount];
			};
		} forEach (["getItemControls", [_display]] call SELF);
		_ctrlList ctrlSetText str _list;
	};
};
