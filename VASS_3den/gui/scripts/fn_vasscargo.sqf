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
	private _findInd = TER_VASS_3den_tempCargo findIf {_x isEqualTo (_this#0)};
	if (_findInd < 0) then {_findInd = count TER_VASS_3den_tempCargo};
	if ((_this#2) isEqualTo false) then {_this = [nil,nil,nil]};
	for "_i" from 0 to 2 do {
		TER_VASS_3den_tempCargo set [_findInd+_i, _this#_i];
	};
	TER_VASS_3den_tempCargo = TER_VASS_3den_tempCargo select {!isNil "_x"};
	TER_VASS_3den_tempCargo = TER_VASS_3den_tempCargo apply {if (_x isEqualType "") then {toLower _x} else {_x}};
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
		_btnExport = _grp controlsGroupCtrl IDC_VASSCARGO_BTNEXPORT;
		_toolFilter = _grp controlsGroupCtrl IDC_VASSCARGO_TOOLFILTER;
		_lnbCargo = _grp controlsGroupCtrl IDC_VASSCARGO_LNBCARGO;
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
		uiNamespace setVariable ["TER_VASS_3den_tempCargo",parseSimpleArray _3denCargo];
		//--- Preload arsenal for items
		if (isNil {uiNamespace getVariable "TER_VASS_preloadCargo"}) then {
			["Preload"] call BIS_fnc_arsenal;
			uiNamespace setVariable ["TER_VASS_preloadCargo",bis_fnc_arsenal_data];
		};
		//--- Export button
		_btnExport ctrlAddEventHandler ["ButtonClick",{
			with uiNamespace do {["export",_this] call SELF};
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
		//--- Preset combo
		//--- Go through all units to get the gear and faction
		_factionFilter = uinamespace getVariable ["TER_VASS_factionFilter",[]];
		if (count _factionFilter == 0) then {
			_allUnitsCfg = "
				getnumber (_x >> 'scope') == 2 &&
				configname _x iskindof 'Man'
			" configclasses (configfile >> "CfgVehicles");
			//--- Faction filter will have format ["faction0", [classes0], "faction1", [classes1], ...]
			{
				_unitCfg = _x;
				_unitClass = configname _x;
				_unitFaction = tolower gettext(_x >> "faction");

				private ["_curFilter","_indFilter"];
				_factionInd = _factionFilter find _unitFaction;
				if (_factionInd == -1) then {
					_newInd = _factionFilter pushback _unitFaction;
					_indFilter = _newInd +1;
					_curFilter = [];
				} else {
					_indFilter = _factionInd +1;
					_curFilter = _factionFilter select _indFilter;
				};

				_loadout = getunitloadout _unitCfg;
				//--- _wXXX = weapon, _cXXX = container
				_loadout params ["_wPrimary","_wSecondary","_wHandgun","_cUniform","_cVest","_cBackpack","_helmet","_facewear","_wBinocular","_itemsAssigned"];
				_weapons = [_wPrimary, _wSecondary, _wHandgun, _wBinocular];
				_weaponClasses = _weapons apply {[_x#0] call BIS_fnc_baseWeapon};
				_accClasses = [];
				_weapons apply {_accClasses append [_x param [1,""], _x param [2,""], _x param [3,""], _x param [6,""]]};
				_cBackpack set [0, _cBackpack#0 call BIS_fnc_basicBackpack];
				_containers = [_cUniform, _cVest, _cBackpack];
				_containerClasses = _containers apply {_x param [0, ""]};
				_itemClasses = [];
				_containers apply {_itemClasses append (_x param [1,[]])};
				_itemClasses = _itemClasses apply {_x param [0,""]};
				_itemClasses = _itemClasses -[nil]; // no magazines
				_otherClasses = [_helmet, _facewear] +_itemsAssigned;

				{
					if (_x isequaltype "") then {_curFilter pushbackunique tolower _x};
				} foreach (_weaponClasses + _accClasses + _containerClasses + _itemClasses + _otherClasses);
				_curFilter = _curFilter -[""];
				_factionFilter set [_indFilter, _curFilter];
			} foreach _allUnitsCfg;
			uinamespace setVariable ["TER_VASS_factionFilter",_factionFilter];
		};

		_factionCfgs = [];
		for "_i" from 0 to (count _factionFilter -1) step 2 do {
			if (count (_factionFilter#(_i+1)) > 0) then {
				_factionCfgs pushback (configfile >> "CfgFactionClasses" >> (_factionFilter#_i));
			};
		};
		_comboPreset lbadd " NO FILTER";
		_comboPreset lbsetcursel 0;
		{
			_sideID = getnumber (_x >> "side");
			private _ind = _comboPreset lbadd format ["%1 (Cfg: %2, side: %3)", gettext (_x >> "displayname"),configname _x, _sideID call BIS_fnc_sideType];
			_comboPreset lbsetvalue [_ind, _sideID];
			_comboPreset lbsetdata [_ind, tolower configname _x];
		} forEach _factionCfgs;
		lbsortbyvalue _comboPreset;
		_comboPreset ctrlAddEventHandler ["LBSelChanged",{
			with uiNamespace do {["presetChange",_this] call SELF;};
		}];
	};
	case "export":{
		//_att = (_box get3DENAttribute "TER_VASS_cargo")#0;
		copyToClipboard str TER_VASS_3den_tempCargo;
	};
	case "filterChanged":{
		params ["_toolFilter","_ind"];
		_grp = ctrlparentcontrolsgroup _toolFilter;
		_comboPreset = _grp controlsgroupctrl IDC_VASSCARGO_COMBOPRESETS;
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
				_itemsLNB = TER_VASS_3den_tempCargo select {_x isEqualType ""};
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
		if (_ind != 0) then {
			_filterFaction = _comboPreset lbdata (lbcursel _comboPreset);
			_factionInd = TER_VASS_factionFilter find _filterFaction;
			if (_factionInd != -1) then {
				_filterFaction = TER_VASS_factionFilter#(_factionInd +1);
				_itemsLNB = _itemsLNB select {_x in _filterFaction};
			};
		};
		_findCargo = [0,-2] +TER_VASS_3den_tempCargo;
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
			_displayName = getText (_cfg>>"displayName");
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
		_lnbCargo = _grp controlsGroupCtrl IDC_VASSCARGO_LNBCARGO;
		_change = switch _key do {
			case DIK_LEFTARROW: {-1};
			case DIK_RIGHTARROW: {+1};
			default {0};
		};
		if (_change == 0) exitWith {false};
		if (_ctrl) then {_change = _change * 5};
		["amount",[_grp, _change]] call SELF;
		true
	};
	case "clear":{
		params ["_btnClear"];
		_grp = ctrlParentControlsGroup _btnClear;
		_toolFilter = _grp controlsGroupCtrl IDC_VASSCARGO_TOOLFILTER;
		TER_VASS_3den_tempCargo = [];
		["filterChanged",[_toolFilter, lbCurSel _toolFilter]] call SELF;
	};
	case "priceChange":{
		params ["_edPrice", "_key", "_shift", "_ctrl", "_alt"];
		if (_edPrice getVariable ["lastText",""] == ctrlText _edPrice) exitWith {};
		_edPrice setVariable ["lastText",ctrlText _edPrice];
		_lnbCargo = (ctrlParentControlsGroup _edPrice) controlsGroupCtrl IDC_VASSCARGO_LNBCARGO;
		_class = _lnbCargo lnbData [lnbCurSelRow _lnbCargo, 0];
		_price = parseNumber ctrltext _edPrice;
		_amount = _lnbCargo lnbValue [lnbCurSelRow _lnbCargo, 3];
		if (_amount == -1) then {_amount = true};
		_colPrice = [lnbCurSelRow _lnbCargo, 2];
		_lnbCargo lnbSetText [_colPrice, format ["%1$",_price]];
		_lnbCargo lnbSetValue [_colPrice, _price];
		[_class,_price,_amount] call _fncSetCargo;
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

		[_class,_price,_newAmount] call _fncSetCargo;
	};
	case "presetChange":{
		params ["_comboPreset","_ind"];
		_grp = ctrlParentControlsGroup _comboPreset;
		_toolFilter = _grp controlsgroupctrl IDC_VASSCARGO_TOOLFILTER;
		["filterChanged",[_toolFilter, lbCurSel _toolFilter]] call SELF;
	};
	case "attributeLoad":{
	};
	case "3denExpression":{
		params ["_box","_cargo"];
		_cargo = parseSimpleArray _cargo;
		_box setVariable ["TER_VASS_cargo",_cargo];
	};
	case "attributeSave":{
		_saveCargo = uiNamespace getVariable ["TER_VASS_3den_tempCargo",[]];
		str(_saveCargo)
	};
	default {};
};