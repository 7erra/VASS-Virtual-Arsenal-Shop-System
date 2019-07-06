/*
	Author: 7erra <https://forums.bohemia.net/profile/1139559-7erra/>

	Description:
	Internal function to set the cargo of a trader inside 3den.

	Parameter(s):
	Don't use this function.

	Returns:
	Really don't.
*/

#include "\a3\ui_f\hpp\definedikcodes.inc"
#include "\A3\Ui_f\hpp\defineResinclDesign.inc"
#include "\VASS_3den\gui\scripts\idcs.inc"
#define SYMBOL_VIRTUAL_1 "∞"
#define SELF TER_fnc_vasscargo

_fncSetCargo = {
	params ["_grp","_class","_price","_amount"];
	_edCargoArray = _grp controlsgroupctrl IDC_VASSCARGO_EDCARGOARRAY;
	private _cargo = if (ctrltext _edCargoArray == "") then {[]} else {call compile ctrltext _edCargoArray};
	private _findInd = _cargo findIf {_x isEqualTo _class};
	if (_findInd < 0) then {_findInd = count _cargo};
	if (_amount isEqualTo false) then {
		_class = nil;
		_price = nil;
		_amount = nil;
	};
	_cargo set [_findInd+0, _class];
	_cargo set [_findInd+1, _price];
	_cargo set [_findInd+2, _amount];
	_cargo = _cargo select {!isNil "_x"};
	_cargo = _cargo apply {if (_x isEqualType "") then {toLower _x} else {_x}};
	["attributeLoad",[_grp, str _cargo]] call SELF;
};
params ["_mode","_this"];
_box = get3DENSelected "object" param [0,objNull];
switch _mode do {
	case "onLoad":{
		params ["_grp"];
		//TER_fnc_vasscargo = compile preprocessFileLineNumbers "gui\scripts\vasscargo.sqf";
		if (isNil {uiNamespace getVariable "TER_fnc_vasscargo"}) then {
			uiNamespace setVariable ["TER_fnc_vasscargo", TER_fnc_vasscargo];
		};
		//--- Init UI
		_toolView = _grp controlsgroupctrl IDC_VASSCARGO_TOOLVIEW;
		_btnImport = _grp controlsgroupctrl IDC_VASSCARGO_BTNIMPORT;
		_btnExport = _grp controlsGroupCtrl IDC_VASSCARGO_BTNEXPORT;
		_edCargoArray = _grp controlsgroupctrl IDC_VASSCARGO_EDCARGOARRAY;
		_toolFilter = _grp controlsGroupCtrl IDC_VASSCARGO_TOOLFILTER;
		_lnbCargo = _grp controlsGroupCtrl IDC_VASSCARGO_LNBCARGO;
		_txtValidate = _grp controlsgroupctrl IDC_VASSCARGO_TXTVALIDATE;
		_btnValidate = _grp controlsgroupctrl IDC_VASSCARGO_BTNVALIDATE;
		_btnClear = _grp controlsGroupCtrl IDC_VASSCARGO_BTNCLEAR;
		_edPrice = _grp controlsGroupCtrl IDC_VASSCARGO_EDPRICE;
		_btnMinus = _grp controlsGroupCtrl IDC_VASSCARGO_BTNMINUS;
		_btnPlus = _grp controlsGroupCtrl IDC_VASSCARGO_BTNPLUS;
		_comboPreset = _grp controlsGroupCtrl IDC_VASSCARGO_COMBOPRESETS;
		//--- Set the group as global active to access it from outside
		_grp ctrladdeventhandler ["setfocus",{with uinamespace do {vasscargo_grp = _this select 0;};}];
		_grp ctrladdeventhandler ["killfocus",{with uinamespace do {vasscargo_grp = nil;};}];
		//--- Get current cargo
		_3denCargo = (_box get3DENAttribute "TER_VASS_cargo") param [0,"[]"];
		if (_3denCargo isEqualType true) then {_3denCargo = "[]";};
		//uiNamespace setVariable ["TER_VASS_3den_tempCargo",parseSimpleArray _3denCargo];
		//--- Preload arsenal for items
		if (isNil {uiNamespace getVariable "TER_VASS_preloadCargo"}) then {
			["Preload"] call BIS_fnc_arsenal;
			uiNamespace setVariable ["TER_VASS_preloadCargo",bis_fnc_arsenal_data];
		};
		//--- View toolbox
		_toolView ctrladdeventhandler ["ToolBoxSelChanged",{
			with uinamespace do {["changeView",_this] call SELF};
		}];
		//--- Array editbox
		_edCargoArray ctrladdeventhandler ["KeyDown",{
			with uinamespace do {["keyCargoArray",_this] call SELF};
		}];
		//--- Toolbox filter
		_toolFilter ctrlAddEventHandler ["ToolBoxSelChanged",{
			with uiNamespace do {["filterChanged",_this] call SELF};
		}];
		with uiNamespace do {["filterChanged",[_toolFilter,0]] call SELF};
		//--- Cargo lnb
		_lnbCargo ctrlAddEventHandler ["LBSelChanged",{
			with uiNamespace do {["itemchanged",_this] call SELF};
		}];
		(ctrlParent _grp) displayAddEventHandler ["KeyDown",{// Prevent control from getting unfocused when using the arrow keys
			with uiNamespace do {["keylnb",[vasscargo_grp] +_this] call SELF};
		}];
		//--- Validate button
		_btnValidate ctrladdeventhandler ["ButtonClick",{
			with uinamespace do {["validate",_this] call SELF};
		}];
		//--- Clear button
		_btnClear ctrlAddEventHandler ["ButtonClick",{
			with uiNamespace do {["clear",_this] call SELF};
		}];
		//--- Price tag
		_edPrice ctrlAddEventHandler ["KeyDown",{
			with uiNamespace do {["priceChange",_this] spawn SELF};
		}];
		//--- Add/Remove button
		_btnPlus ctrlAddEventHandler ["ButtonClick",{
			with uiNamespace do {["amount",[ctrlParentControlsGroup (_this#0),+1]] call SELF;};
		}];
		_btnMinus ctrlAddEventHandler ["ButtonClick",{
			with uiNamespace do {["amount",[ctrlParentControlsGroup (_this#0),-1]] call SELF;};
		}];
	};
	case "changeView":{
		params ["_toolView", "_ind"];
		_grp = ctrlparentcontrolsgroup _toolView;
		_toolFilter = _grp controlsgroupctrl IDC_VASSCARGO_TOOLFILTER;
		_guiIDCs = [IDC_VASSCARGO_TOOLFILTER, IDC_VASSCARGO_LNBCARGO, IDC_VASSCARGO_EDPRICE, IDC_VASSCARGO_BTNCLEAR, IDC_VASSCARGO_STATICLISTBACKGROUND, IDC_VASSCARGO_TITLEPRICE];
		_arrayIDCs = [IDC_VASSCARGO_GRPCARGOARRAY,IDC_VASSCARGO_TXTVALIDATE,IDC_VASSCARGO_BTNVALIDATE];
		_guiFade = _ind == 1;
		_arrayFade = _ind == 0;
		{
			_x apply {
				_enable = [_guiFade, _arrayFade] select _foreachindex;
				_ctrl = _grp controlsgroupctrl _x;
				_ctrl ctrlenable !_enable;
				_ctrl ctrlsetfade parseNumber _enable;
				_ctrl ctrlcommit 0;
			};
		} forEach [_guiIDCs, _arrayIDCs];

		if (_arrayFade) then {
			//--- Return to gui editing, update
			["filterChanged",[_toolFilter, lbcursel _toolFilter]] call SELF;
		};
	};
	case "keyCargoArray":{
		params ["_edCargoArray", "_key", "_shift", "_ctrl", "_alt"];
		_text = ctrltext _edCargoArray;
		_lasttext = _edCargoArray getVariable ["lasttext",""];
		if (_lasttext == _text) exitWith {};
		_edCargoArray setVariable ["lasttext",_text];
		["scaleEdit",[_edCargoArray]] call SELF;
		false
	};
	case "filterChanged":{
		params ["_toolFilter","_ind"];
		_grp = ctrlparentcontrolsgroup _toolFilter;
		_comboPreset = _grp controlsgroupctrl IDC_VASSCARGO_COMBOPRESETS;
		_edCargoArray = _grp controlsgroupctrl IDC_VASSCARGO_EDCARGOARRAY;
		private _cargo = ctrltext _edCargoArray;
		if (count _cargo == 0) then {_cargo = []} else {_cargo = call compile _cargo};
		_itemsLNB = [];
		_tab = 0;
		_types = [];
		_lnbCargo = (ctrlParentControlsGroup _toolFilter) controlsGroupCtrl IDC_VASSCARGO_LNBCARGO;
		lnbClear _lnbCargo;
		switch _ind do {
			case 1:{
				_types = ["AssaultRifle","Shotgun","Rifle","SubmachineGun"];
				_tab = IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON;
				_magArray = [];
			};
			case 2:{
				_types = ["MachineGun"];
				_tab = IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON;
			};
			case 3:{
				_types = ["SniperRifle"];
				_tab = IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON;
			};
			case 4:{
				_types = ["Launcher","MissileLauncher","RocketLauncher"];
				_tab = IDC_RSCDISPLAYARSENAL_TAB_SECONDARYWEAPON;
			};
			case 5:{
				_types = ["Handgun"];
				_tab = IDC_RSCDISPLAYARSENAL_TAB_HANDGUN;
			};
			case 6:{
				{
					_itemsLNB = _itemsLNB +(TER_VASS_preloadCargo select _x);
				} forEach [IDC_RSCDISPLAYARSENAL_TAB_CARGOTHROW,IDC_RSCDISPLAYARSENAL_TAB_CARGOPUT];
			};
			case 7:{
				//--- Attachements
				_itemsLNB = ("getNumber(_x>>""itemInfo"">>""type"") in [101,201,301,302] && getNumber(_x>>'scope') == 2" configClasses (configFile >> "CfgWeapons")) apply {configName _x};
			};
			case 8:{
				_types = ["Uniform"];
				_tab = IDC_RSCDISPLAYARSENAL_TAB_UNIFORM;
			};
			case 9:{
				_types = ["Vest"];
				_tab = IDC_RSCDISPLAYARSENAL_TAB_VEST;
			};
			case 10:{
				_types = ["Backpack"];
				_tab = IDC_RSCDISPLAYARSENAL_TAB_BACKPACK;
			};
			case 11:{
				{
					_itemsLNB = _itemsLNB +(TER_VASS_preloadCargo select _x);
				} forEach [IDC_RSCDISPLAYARSENAL_TAB_HEADGEAR,IDC_RSCDISPLAYARSENAL_TAB_GOGGLES];
			};
			case 12:{
				{
					_itemsLNB = _itemsLNB +(TER_VASS_preloadCargo select _x);
				} forEach [IDC_RSCDISPLAYARSENAL_TAB_NVGS,IDC_RSCDISPLAYARSENAL_TAB_BINOCULARS,IDC_RSCDISPLAYARSENAL_TAB_MAP,IDC_RSCDISPLAYARSENAL_TAB_GPS,IDC_RSCDISPLAYARSENAL_TAB_RADIO,IDC_RSCDISPLAYARSENAL_TAB_COMPASS,IDC_RSCDISPLAYARSENAL_TAB_WATCH, IDC_RSCDISPLAYARSENAL_TAB_CARGOMISC];
			};
			default {
				//--- Get currently loaded items
				_itemsLNB = _cargo select {_x isEqualType ""};
			};
		};
		if (count _itemsLNB == 0) then {
			_itemsLNB = TER_VASS_preloadCargo select _tab;
			_itemsLNB = _itemsLNB select {((_x call BIS_fnc_itemType) select 1) in _types};
		};
		_mags = [];
		if (_ind in [1,2,3,4,5]) then {
			{
				//--- Add magazines compatible with the weapon
				_weaponCfg = configFile >> "CfgWeapons" >> _x;
				{
					private _muzzle = if (_x == "this") then { _weaponCfg } else { _weaponCfg >> _x };
					private _magazinesList = getArray (_muzzle >> "magazines");

					// Add magazines from magazine wells
					{ { _magazinesList append (getArray _x) } forEach configproperties [configFile >> "CfgMagazineWells" >> _x, "isArray _x"] } forEach getArray (_muzzle >> "magazineWell");

					{
						_mags pushBackUnique toLower _x;
					} forEach _magazinesList;
				} forEach getArray (_weaponCfg >> "muzzles");
			} forEach _itemsLNB;
		};
		_itemsLNB = (_itemsLNB +_mags) apply {tolower _x};
		//--- Apply filter which was set in the combobox
		/*
		if (_ind != 0) then {
			_filterFaction = _comboPreset lbdata (lbcursel _comboPreset);
			_factionInd = TER_VASS_factionFilter find _filterFaction;
			if (_factionInd != -1) then {
				_filterFaction = TER_VASS_factionFilter#(_factionInd +1);
				_itemsLNB = _itemsLNB select {_x in _filterFaction};
			};
		};
		*/
		_findCargo = [0,-2] +_cargo;
		// EXPLANATION: The price and amount of the item comes always +1 (+2) after the items class name. If the item is not in the array the "findIf" command returns -1. Adding 1 leads to 0 (+2 = 1). Setting the first two array items as 0 and -1 therefore assigns default values
		{
			_class = _x;
			_findInd = _findCargo findIf {_x isEqualTo _class};
			_price = _findCargo select (_findInd + 1);
			_amount = _findCargo select (_findInd + 2);
			_cfg = {
				_testCfg = configFile >> _x;
				if (isClass (_testCfg >> _class)) exitWith {_testCfg >> _class};
				configNull
			} forEach ["CfgWeapons","CfgMagazines","CfgGlasses","CfgVehicles"];
			_displayName = [_cfg] call BIS_fnc_displayName;
			if (_displayName == "") then {_displayName = _class};
			_pic = gettext (_cfg >> "picture");
			//_symbol = [str _amount, "-", SYMBOL_VIRTUAL_1] select ([0,-1,-2] findIf {_amount > _x});
			_symbol = if (_amount isEqualTo true) then {
				_amount = -1;
				SYMBOL_VIRTUAL_1
			} else {
				[str _amount, "-"] select (_amount == -2);
			};
			_row = _lnbCargo lnbAddRow ["", _displayName, format ["%1$",_price], _symbol];
			_lnbCargo lnbSetData [[_row,0],_class];
			_lnbCargo lnbSetPicture [[_row,0],_pic];
			_lnbCargo lnbSetValue [[_row,2],_price];
			_lnbCargo lnbSetValue [[_row,3],_amount];
		} forEach _itemsLNB;
		_lnbCargo lnbSort [1,false];
	};
	case "itemchanged":{
		params ["_lnbCargo","_row"];
		//--- Set price text
		_edPrice = (ctrlParentControlsGroup _lnbCargo) controlsGroupCtrl IDC_VASSCARGO_EDPRICE;
		_price = (_lnbCargo lnbValue [_row,2]);
		_edPrice ctrlSetText str _price;
		//--- Set button minus text
		/*
		_textBtn = ["-", SYMBOL_VIRTUAL_1] select (_lnbCargo lnbValue [_row,3] <= 0);
		_btnMinus = (ctrlParentControlsGroup _lnbCargo) controlsGroupCtrl IDC_VASSCARGO_BTNMINUS;
		_btnMinus ctrlSetText _textBtn;
		*/
	};
	case "keylnb":{
		params ["_grp", "_display", "_key", "_shift", "_ctrl", "_alt"];
		if (isnil "_grp") exitwith {false}; // Group is not focused, keep normal behaviour
		_lnbCargo = _grp controlsGroupCtrl IDC_VASSCARGO_LNBCARGO;
		_change = switch _key do {
			case DIK_LEFTARROW: {-1};
			case DIK_RIGHTARROW: {+1};
			default {0};
		};
		if (_change == 0 OR !ctrlenabled _lnbCargo) exitWith {false};
		if (_ctrl) then {_change = _change * 5};
		["amount",[_grp, _change]] call SELF;
		//--- Intercept engine behaviour
		true
	};
	case "validate":{
		params ["_btnValidate"];
		_grp = ctrlparentcontrolsgroup _btnValidate;
		_txtValidate = _grp controlsgroupctrl IDC_VASSCARGO_TXTVALIDATE;
		_edCargoArray = _grp controlsgroupctrl IDC_VASSCARGO_EDCARGOARRAY;
		//--- Go through array and compare format:
		_cargo = call compile ctrlText _edCargoArray;
		if !(_cargo isequaltype [] OR isNil "_cargo") exitwith {_txtValidate ctrlsetstructuredtext parsetext "<t color='#CC0000'>ERROR: Not an array"};
		_message = "<t color='#00CC00'>Array is valid";
		for "_i" from 0 to (count _cargo -1) step 3 do {
			_class = _cargo param [_i+0, nil];
			_price = _cargo param [_i+1, nil];
			_amount = _cargo param [_i+2, nil];
			if !(_class isequaltype "") exitwith {_message = format ["<t color='#CC0000'>Class is not a string (Position: %1, %2)",_i,str _class]};
			if (isnil "_price") exitwith {_message = format ["<t color='#CC0000'>(%1) Price not defined",_class]};
			if !(_price isequaltype 0) exitwith {_message = format ["<t color='#CC0000'>%1: Price not a number (%2)",_class,str _price]};
			if (isnil "_amount") exitwith {_message = format ["<t color='#CC0000'>(%1) Amount not defined",_class]};
			if !(_amount isequaltypeany [0,true]) exitwith {_message = format ["<t color='#CC0000'>ERROR: %1: Amount not a number/boolean (%2)",_class,str _amount]};
		};
		_txtValidate ctrlsetstructuredtext parsetext _message;
	};
	case "clear":{
		params ["_btnClear"];
		_grp = ctrlParentControlsGroup _btnClear;
		_toolFilter = _grp controlsGroupCtrl IDC_VASSCARGO_TOOLFILTER;
		_edCargoArray = _grp controlsgroupctrl IDC_VASSCARGO_EDCARGOARRAY;
		_edCargoArray ctrlsettext "[]";
		["filterChanged",[_toolFilter, lbCurSel _toolFilter]] call SELF;
	};
	case "priceChange":{
		params ["_edPrice", "_key", "_shift", "_ctrl", "_alt"];
		_grp = ctrlparentcontrolsgroup _edPrice;
		if (_edPrice getVariable ["lastText",""] == ctrlText _edPrice) exitWith {};
		_edPrice setVariable ["lastText",ctrlText _edPrice];
		_lnbCargo = _grp controlsGroupCtrl IDC_VASSCARGO_LNBCARGO;
		_class = _lnbCargo lnbData [lnbCurSelRow _lnbCargo, 0];
		_price = parseNumber ctrltext _edPrice;
		_amount = _lnbCargo lnbValue [lnbCurSelRow _lnbCargo, 3];
		if (_amount == -1) then {_amount = true};
		_colPrice = [lnbCurSelRow _lnbCargo, 2];
		_lnbCargo lnbSetText [_colPrice, format ["%1$",_price]];
		_lnbCargo lnbSetValue [_colPrice, _price];
		[_grp,_class,_price,_amount] call _fncSetCargo;
	};
	case "amount":{
		params ["_grp","_change"];
		_lnbCargo = _grp controlsGroupCtrl IDC_VASSCARGO_LNBCARGO;
		_class = _lnbCargo lnbData [lnbCurSelRow _lnbCargo, 0];
		_colAmount = [lnbCurSelRow _lnbCargo, 3];
		_curAmount = _lnbCargo lnbValue _colAmount;
		_newAmount = (_curAmount +_change) max -2;
		_lnbCargo lnbSetValue [_colAmount, _newAmount];
		//_textBtn = ["-", SYMBOL_VIRTUAL_1] select (_newAmount <= -1);
		_text = str _newAmount;
		_newAmount = switch _newAmount do {
			case -2: {_text = "-"; false};
			case -1: {_text = SYMBOL_VIRTUAL_1; true};
			default {_newAmount};
		};
		//_btnMinus = _grp controlsGroupCtrl IDC_VASSCARGO_BTNMINUS;
		//_btnMinus ctrlSetText _textBtn;
		_lnbCargo lnbsettext [_colAmount, _text];
		_price = _lnbCargo lnbValue [lnbCurSelRow _lnbCargo, 2];

		[_grp,_class,_price,_newAmount] call _fncSetCargo;
	};
	case "presetChange":{
		params ["_comboPreset","_ind"];
		_grp = ctrlParentControlsGroup _comboPreset;
		_toolFilter = _grp controlsgroupctrl IDC_VASSCARGO_TOOLFILTER;
		["filterChanged",[_toolFilter, lbCurSel _toolFilter]] call SELF;
	};
	case "scaleEdit":{
		params ["_ed"];
		_parentGrp = ctrlparentcontrolsgroup _ed;
		_hMin = ctrlposition _parentGrp select 3;
		_hText = ctrltextheight _ed + 1 * 5 * (pixelH * pixelGrid * 0.50);
		_ed ctrlsetpositionh (_hText max _hMin);
		_ed ctrlcommit 0;
	};
	case "attributeLoad":{
		params ["_grp","_value",["_from3den",false]];
		_edCargoArray = _grp controlsgroupctrl IDC_VASSCARGO_EDCARGOARRAY;
		_grpCargoArray = _grp controlsgroupctrl IDC_VASSCARGO_GRPCARGOARRAY;
		_toolFilter = _grp controlsgroupctrl IDC_VASSCARGO_TOOLFILTER;
		//_value = _value select [1, count _value -2];
		_cargo = if (_cargo isEqualType "") then {call compile _value;} else {[]};
		_text = format ["[%1", str (_cargo deleteat 0)];
		{
			if (_x isequaltype "") then {
				_text = format ["%1,%2%3",_text,endl,str _x];
			} else {
				_text = format ["%1, %2",_text,_x];
			};
		} forEach _cargo;
		_text = format ["%1]",_text];
		_edCargoArray ctrlsettext _text;
		with uinamespace do {
			["scaleEdit",[_edCargoArray]] call SELF;
		};
		if (_from3den) then {
			["filterChanged",[_toolFilter, lbcursel _toolFilter]] call SELF;
		};
	};
	case "3denExpression":{
		params ["_box","_cargo"];
		_cargo = call compile _cargo;
		_box setVariable ["TER_VASS_cargo",_cargo];
	};
	case "attributeSave":{
		params ["_grp"];
		_edCargoArray = _grp controlsgroupctrl IDC_VASSCARGO_EDCARGOARRAY;
		_saveCargo = if (ctrltext _edCargoArray == "") then {[]} else {call compile ctrltext _edCargoArray};
		_saveCargo = _saveCargo apply {if (_x isequaltype "") then {tolower _x} else {_x}};
		str(_saveCargo)
	};
	default {};
};