#include "controls.sqf"
#include "\A3\ui_f\hpp\defineDIKCodes.inc"
#define _PLAYER_MONEY (TER_moneyNameSpace getVariable [TER_moneyVariable,0])
#define _CURRENTCOST (_display getVariable ["TER_cost",0])
#define _SELFEH(ehname) {[ehname,_this] call TER_fnc_arsenalEH;}

if (isNull _display) exitWith {};// arsenal isn't open, can happen when a script is spawned and arsenal was closed
/* start init */
_isInit = _display getVariable ["_isInit",true];
if (_isInit) exitWith {// display hasn't been initialized yet
	[] execVM "arsenalShop\ui\initArsenal.sqf";
};
/* end init */
/* start switch eh */
#include "localFunctions.sqf"
params ["_ehCase","_ehArgs"];
switch (toLower _ehCase) do {

case "unload":{
	player setUnitLoadout (_display getVariable "loadoutOwned");
	_display setVariable ["_isInit",nil];
};

case "buy":{
	// buy button pressed
	_ehArgs params ["_control"];
	_newBalance = _PLAYER_MONEY -_CURRENTCOST;
	if (_newBalance >= 0) then {
		// add new loadout and close arsenal to reload values
		TER_moneyNameSpace setVariable [TER_moneyVariable,_newBalance];
		_display setVariable ["loadoutOwned",getUnitLoadout player];
		_display closeDisplay 2;
		["#(argb,8,8,3)color(0,0,0,1)",false,nil,0,[0,0.5]] call BIS_fnc_textTiles;
		hint format ["Transaction successful\nYour new balance is %1 %2",_newBalance,TER_moneyUnit];
	} else {
		// not enough money, do nothing
		systemChat "Not enough money";
	};
};

case "lbchanged":{
	// new selection in one of the listboxes
	_ehArgs params ["_control","_index"];
	if (_index == -1) exitWith {};
	_lbData = _control lbData _index;
	_varCheckInitArray = ["_isInit",false];
	if (_control getVariable _varCheckInitArray) exitWith {
		_control setVariable ["startData",_lbData];
		_control setVariable _varCheckInitArray;
		_control setVariable ["_prevData",_lbData];
	};
	_prevData = _control getVariable ["_prevData",""];
	if (_prevData == _lbData) exitWith {};// no new selection

	_startData = _control getVariable ["startData",""];
	_startCost = [_startData] call TER_fnc_itemCostFromTable;
	_prevItemCost = [
		[_prevData] call TER_fnc_itemCostFromTable,
		0
	] select (_startData == _prevData);//previous selection was start selection, don't substract cost
	_newCost = _CURRENTCOST;
	_refundDone = _control getVariable ["_refundDone",false];
	_itemCost = if (_lbData == _startData) then {// already owned
		if (_refundDone) then {// start gear has been refunded and start selection is selected, dont refund
			_newCost = _newCost +_startCost;
			_control setVariable ["_refundDone",false];
		};
		0
	} else {// new entry
		_itemCost = [_lbData] call TER_fnc_itemCostFromTable;
		_itemCost
	};
	_newCost = _newCost +_itemCost -_prevItemCost;
	if (!_refundDone) then {//refund currently owned gear
		_control setVariable ["_refundDone",true];
		_newCost = _newCost -_startCost;
	};

	_display setVariable ["TER_cost",_newCost];
	_control setVariable ["_prevData",_lbData];
	[] call TER_fnc_moneyText;
};

case "weaponchanged":{//update the lb price texts of the attachement lbs
	{
		[_x] spawn _fnclbPrice;
	} forEach _attachementLBs;
	//[_rightLBs select 0] spawn _SELFEH("lnbPrice");//update comp mags lnb
};

/*
case "listnboxlbchanged":{// set cost text of the lnb info text
	_ehArgs params ["_control","_index"];
	_lbData = _control lnbData [_index,0];
	_itemCost = [_lbData] call TER_fnc_itemCostFromTable;
	[_itemCost] call _fncItemText;
};
case "killlnbfocus":{// hide the lnb price tag
	_stxtItemCost ctrlSetFade 1;
	_stxtItemCost ctrlCommit 0.15;
};

case "setlnbfocus":{// show the lnb price tag
	_stxtItemCost ctrlSetFade 0;
	_stxtItemCost ctrlCommit 0.15;
};
*/

case "selectitem":{
	_ehArgs params ["_control","_index"];
	[_display,_control,ctrlIDC _control -IDC_RSCDISPLAYARSENAL_LIST] call (_display getVariable "_fncSelectItemEH");
};

case "hidecontrolsbar":{
	_ehArgs params ["", "_key", "_shift", "_ctrl", "_alt"];
	if (_key == DIK_BACKSPACE OR _key == 1) then {
		call _fncShowControlsbar;
	};
	_stxtCredit ctrlSetFade ([0,1] select (ctrlShown _grpControlsBar));
	_stxtCredit ctrlCommit 0;
};

case "buydetails":{
	_ehArgs	params [["_control",controlNull]];
	// hide
	if (ctrlFade _grpDetails < 1) exitWith {
		_setPosition = ctrlPosition _grpDetails;
		_setPosition set [1,(_setPosition select 1)+(_setPosition select 3)];
		_setPosition set [3,0];
		_grpDetails ctrlSetPosition _setPosition;
		_grpDetails ctrlSetFade 1;
		_grpDetails ctrlEnable false;
		_commitTime = [0.15,0] select (_grpDetails getVariable ["_isInit",true]);
		_grpDetails setVariable ["_isInit",false];
		_grpDetails ctrlCommit _commitTime;
	};
	// set position
	_grpDetails ctrlSetPosition (_grpDetails getVariable "_startPos");
	_grpDetails ctrlSetFade 0;
	_grpDetails ctrlEnable true;
	_grpDetails ctrlCommit 0.15;
};

case "updatedetails":{
	_ehArgs params ["_control"];
	// fill lnb
	_ownedLoadout = _display getVariable "loadoutOwned";
	_selectLoadout = getUnitLoadout player;
	_loadoutDiff = [_ownedLoadout,_selectLoadout] call TER_fnc_compareLoadout;
	_lostLoadout = [_selectLoadout,_ownedLoadout] call TER_fnc_compareLoadout;
	_handledItems = [];
	lnbClear _lnbDetailsList;
	_lnbDetailsList lnbAddRow ["","Item","Amount","Cost (single)","Cost (total)"];
	_absCost = 0;
	{
		_loadoutArray = _x;
		_sell = _loadoutArray isEqualTo _lostLoadout;
		{
			_item = _x;
			if !(_item in _handledItems) then {
				_handledItems pushBack _item;
				_config = format ["configFile >> ""%1"" >> ""%2""","%1",_item];
				_itemCfg = {
					_itemCfg = call compile format [_config,_x];
					if (isClass _itemCfg) exitWith {_itemCfg};
					configNull
				} forEach ["CfgWeapons","CfgMagazines","CfgVehicles"];
				_displayName = _itemCfg call BIS_fnc_displayName;
				_itemPicture = getText (_itemCfg >> "picture");
				_amount = {_x == _item} count _loadoutArray;
				_itemCost = _item call TER_fnc_itemCostFromTable;
				_itemCostMP = [1,-1] select _sell;
				_totalCost = _itemCost * _amount * _itemCostMP;
				_absCost = _absCost +_totalCost;
				_indexRow = _lnbDetailsList lnbAddRow [
					"",
					_displayName,
					str _amount,
					format ["%1 %2",_itemCost,TER_moneyUnit],
					format ["%1 %2",_totalCost,TER_moneyUnit]
				];
				_lnbDetailsList lnbSetPicture [[_indexRow,0],_itemPicture];
			};
		} forEach _loadoutArray;
		_lnbDetailsList lnbAddRow ["","","","",""];
	} forEach [_loadoutDiff,_lostLoadout];

	_lnbDetailsList lnbAddRow ["","","","",format ["Sum: %1 %2",_absCost,TER_moneyUnit]];
};

case "lnbprice":{
	_ehArgs params ["_control"];
	_vaBox = missionNamespace getVariable ["BIS_fnc_arsenal_cargo",objNull];
	_virtualCargo = [];
	{
		_cargo = _vaBox call _x;
		_virtualCargo append _cargo;
	} forEach [
		BIS_fnc_getVirtualBackpackCargo,
		BIS_fnc_getVirtualItemCargo,
		BIS_fnc_getVirtualWeaponCargo,
		BIS_fnc_getVirtualMagazineCargo
	];
	_virtualCargo = _virtualCargo apply {tolower _x};
	for "_i" from 0 to ((lbSize _control)) do {
		_item = _control lnbData [_i,0];
		_indexLNB = [_i,3];
		_enable = (toLower _item in (call TER_costArray)) AND (toLower _item in _virtualCargo);
		if (_enable) then {
			_cost = [_item] call TER_fnc_itemCostFromTable;
			_control lnbSetText [_indexLNB,format ["%1 %2",_cost,TER_moneyUnit]];
			_control lnbSetColor [_indexLNB,[0,0.5,0,1]];
		} else {
			_control lnbSetText [_indexLNB,"X"];
			_control lnbSetColor [_indexLNB,[1,0,0,1]];
		};
	};
};

case "lnbchanged":{
	_ehArgs params ["_control","_index"];
	_item = _control lnbData [_index,0];
	_vaBox = missionNamespace getVariable ["BIS_fnc_arsenal_cargo",objNull];
	_virtualCargo = [];
	{
		_cargo = _vaBox call _x;
		_virtualCargo append _cargo;
	} forEach [
		BIS_fnc_getVirtualBackpackCargo,
		BIS_fnc_getVirtualItemCargo,
		BIS_fnc_getVirtualWeaponCargo,
		BIS_fnc_getVirtualMagazineCargo
	];
	_virtualCargo = _virtualCargo apply {tolower _x};
	_enable = (toLower _item in (call TER_costArray)) AND (toLower _item in _virtualCargo);
	{
		_btn = _display displayCtrl _x;
		if (_enable) then {
			_btn ctrlSetTextColor [1,1,1,1];
			_btn ctrlSetEventHandler ["buttonclick","[""btnplusminus"",_this] call TER_fnc_arsenalEH;"];
		} else {
			_btn ctrlSetTextColor [1,0,0,1];
			_btn ctrlSetEventHandler ["buttonclick",""];
		};
	} forEach [IDC_RSCDISPLAYARSENAL_ARROWLEFT,IDC_RSCDISPLAYARSENAL_ARROWRIGHT];
};

case "btnplusminus":{// handle the +/- buttons
	_ehArgs params ["_control"];
	_change = [1,-1] select (_control == _btnMinus);
	// calculate cost
	_activeLNB = _rightLBs select {ctrlEnabled _x} select 0;
	private _item = _activeLNB lnbData [lnbCurSelRow _activeLNB, 0];
	_activeContainer = _lbsContainer select {ctrlEnabled _x} select 0;
	_container = switch (ctrlIDC _activeContainer -IDC_RSCDISPLAYARSENAL_LIST) do {
		case IDC_RSCDISPLAYARSENAL_TAB_UNIFORM: {"uniform"};
		case IDC_RSCDISPLAYARSENAL_TAB_VEST: {"vest"};
		case IDC_RSCDISPLAYARSENAL_TAB_BACKPACK: {"backpack"};
		default {""};
	};
	if (_container == "") exitWith {};//error no container selected, shouldnt happen though
	_canAdd = call compile format ["player canAddItemTo%1 ""%2""",_container,_item];
	//_canAdd2 = player canAddItemToBackpack _item;
	/*_maxAdd = 0;
	_condition = compile format ["player canAddItemTo%1 [_item,_maxAdd]",_container];
	while _condition do {_maxAdd = _maxAdd +1};
	_canAdd = _maxAdd > 0;*/
	_hasItem = call compile format ["toLower _item in (%1Items player apply {toLower _x})",_container];
	_doMoney = [_canAdd, _hasItem] select (_change == -1);
	if (_doMoney) then {
		_cost = _item call TER_fnc_itemCostFromTable;
		_cost = _cost * _change;
		_newCost = _CURRENTCOST +_cost;
		ctrlParent _control setVariable ["TER_cost",_newCost];
		[] call TER_fnc_moneyText;
	};

	// default behaviour
	with uinamespace do {['buttonCargo',[ctrlparent _control,_change]] call bis_fnc_arsenal;};
};

default {};

};
/* end switch eh */