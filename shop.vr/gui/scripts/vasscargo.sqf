#include "\a3\ui_f\hpp\definedikcodes.inc"
#include "\A3\Ui_f\hpp\defineResinclDesign.inc"
#include "\VASS_3den\gui\scripts\idcs.inc"
#define SYMBOL_VIRTUAL_1 "∞"
#define SELF compile preprocessFileLineNumbers "gui\scripts\vasscargo.sqf"

_fncSetCargo = {
	_findInd = TER_VASS_3den_tempCargo findIf {_x isEqualTo (_this#0)};
	if (_findInd < 0) then {_findInd = count TER_VASS_3den_tempCargo};
	if (_this#2 == 0) then {_this = [nil,nil,nil]};
	TER_VASS_3den_tempCargo set [_findInd+0, _this#0];
	TER_VASS_3den_tempCargo set [_findInd+1, _this#1];
	TER_VASS_3den_tempCargo set [_findInd+2, _this#2];
	TER_VASS_3den_tempCargo = TER_VASS_3den_tempCargo select {!isNil "_x"};
	TER_VASS_3den_tempCargo = TER_VASS_3den_tempCargo apply {if (_x isEqualType "") then {toLower _x} else {_x}};
};
params ["_mode","_this"];
_box = get3DENSelected "object" param [0,objNull];
switch _mode do {
	case "onLoad":{
		params ["_grp"];
		//--- Init UI
		_btnExport = _grp controlsGroupCtrl IDC_VASSCARGO_BTNEXPORT;
		_toolFilter = _grp controlsGroupCtrl IDC_VASSCARGO_TOOLFILTER;
		_lnbCargo = _grp controlsGroupCtrl IDC_VASSCARGO_LNBCARGO;
		_btnClear = _grp controlsGroupCtrl IDC_VASSCARGO_BTNCLEAR;
		_edPrice = _grp controlsGroupCtrl IDC_VASSCARGO_EDPRICE;
		_btnMinus = _grp controlsGroupCtrl IDC_VASSCARGO_BTNMINUS;
		_btnPlus = _grp controlsGroupCtrl IDC_VASSCARGO_BTNPLUS;
		//--- Get current cargo
		_3denCargo = (_box get3DENAttribute "TER_VASS_cargo")#0;
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
		_lnbCargo ctrlAddEventHandler ["KeyDown",{
			with uiNamespace do {["keylnb",_this] call SELF};
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
	case "export":{
		_att = (_box get3DENAttribute "TER_VASS_cargo")#0;
		if (_att isEqualType "") then {
			copyToClipboard (_att);
		} else {
			["No cargo set on this object!",1] call BIS_fnc_3DENNotification;
		};
	};
	case "filterChanged":{
		params ["_toolFilter","_ind"];
		_itemsLNB = [];
		_tab = 0;
		_types = [];
		_mags = [];
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
				} forEach [IDC_RSCDISPLAYARSENAL_TAB_BINOCULARS,IDC_RSCDISPLAYARSENAL_TAB_MAP,IDC_RSCDISPLAYARSENAL_TAB_GPS,IDC_RSCDISPLAYARSENAL_TAB_RADIO,IDC_RSCDISPLAYARSENAL_TAB_COMPASS,IDC_RSCDISPLAYARSENAL_TAB_WATCH];
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
		_findCargo = [0,0] +TER_VASS_3den_tempCargo;
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
			_symbol = [str _amount, "-", SYMBOL_VIRTUAL_1] select ([0,-1,-2] findIf {_amount > _x});
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
		_textBtn = ["-", SYMBOL_VIRTUAL_1] select (_lnbCargo lnbValue [_row,3] <= 0);
		_btnMinus = (ctrlParentControlsGroup _lnbCargo) controlsGroupCtrl IDC_VASSCARGO_BTNMINUS;
		_btnMinus ctrlSetText _textBtn;
	};
	case "keylnb":{
		params ["_lnbCargo", "_key", "_shift", "_ctrl", "_alt"];
		_change = switch _key do {
			case DIK_LEFTARROW: {-1};
			case DIK_RIGHTARROW: {+1};
			default {0};
		};
		if (_change == 0) exitWith {};
		if (_ctrl) then {_change = _change * 5};
		["amount",[ctrlParentControlsGroup _lnbCargo, _change]] call SELF;
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
		_newAmount = (_curAmount +_change) max -1;
		_text = str _newAmount;
		if (_newAmount == -1) then {
			//--- Unlimited
			_text = SYMBOL_VIRTUAL_1;
		};
		if (_newAmount == 0) then {_text = "-"};
		_lnbCargo lnbsettext [_colAmount,_text];
		_lnbCargo lnbSetValue [_colAmount, _newAmount];
		_price = _lnbCargo lnbValue [lnbCurSelRow _lnbCargo, 2];

		_textBtn = ["-", SYMBOL_VIRTUAL_1] select (_newAmount <= 0);
		_btnMinus = _grp controlsGroupCtrl IDC_VASSCARGO_BTNMINUS;
		_btnMinus ctrlSetText _textBtn;

		[_class,_price,_newAmount] call _fncSetCargo;
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