#include "controls.sqf"
#define _PLAYER_MONEY (TER_moneyNameSpace getVariable [TER_moneyVariable,0])
#define _CURRENTCOST (_display getVariable ["TER_cost",0])
#define _SELFEH(ehname) {[ehname,_this] call TER_fnc_arsenalEH;}

// ui functions
_fncItemText = {
	params ["_price"];
	_stxtItemCost = ARSENAL_CTRL(7302);
	_stxtItemCost ctrlSetStructuredText parseText format [
		"%1 %2",
		_price,
		TER_moneyUnit
	];
	_stxtItemCost ctrlSetPosition [0,0,1,1];
	_stxtItemCost ctrlCommit 0;
	ctrlPosition (_rightLBs select 0) params ["_lbX","_lbY","_lbW","_lbH"];
	_stxtItemCost ctrlSetPosition [
		_lbX - ctrlTextWidth _stxtItemCost - (0.1 * _wGrid),
		_lbY,
		ctrlTextWidth _stxtItemCost,
		ctrlTextHeight _stxtItemCost
	];
	_stxtItemCost ctrlCommit 0;
};
_fnclbPrice = {
	params ["_listbox"];
	//if (canSuspend) then {uiSleep 0.001};
	for "_index" from 1 to lbSize _listbox do {
		_lbData = _listbox lbData _index;
		_itemCost = [_lbData] call TER_fnc_itemCostFromTable;
		if (_listbox lbPictureRight _index == "") then {
			_listbox lbSetPictureRight [_index,"#(rgb,8,8,3)color(1,0,0,0)"];
		};
		_listbox lbSetTextRight [_index,format ["%1 %2",_itemCost,TER_moneyUnit]];
	};
};
/* start init */
_isInit = _display getVariable ["_isInit",true];
if (_isInit) exitWith {// display hasn't been initialized yet
	_display setVariable ["_isInit",false];

	// global ui function
	TER_fnc_moneyText = {
		_stxtMoney ctrlSetStructuredText parseText format [
			"<t size='0.8'>Current Money: %1 %3 %6%2<br/>Cost: %1 %4 %6%2<br/>Balance: %1 %5 %6%2%2",
			"<t align='right'>",
			"</t>",
			_PLAYER_MONEY,
			_CURRENTCOST,
			_PLAYER_MONEY - _CURRENTCOST,
			TER_moneyUnit
		];
		_stxtMoney ctrlSetPosition [0,0,1,1];
		_stxtMoney ctrlCommit 0;
		ctrlPosition _lbPrimary params ["_lbX","_lbY","_lbW","_lbH"];
		_stxtMoney ctrlSetPosition [
			_lbX + _lbW + (0.1 * _wGrid),
			_lbY + _lbH - ctrlTextHeight _stxtMoney,
			ctrlTextWidth _stxtMoney,
			ctrlTextHeight _stxtMoney
		];
		_stxtMoney ctrlCommit 0;
	};
	_display setVariable ["_fncSelectItemEH",compile preprocessFileLineNumbers "arsenalShop\selectItemEH.sqf"];

	// handle loadout
	_display setVariable ["loadoutOwned",getUnitLoadout player];
	_display displayAddEventHandler ["unload",_SELFEH("unload")];

	// disable saving, loading, randomizing, export, import
	{
		(_display displayCtrl _x) ctrlEnable false;
	} forEach [
		IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONSAVE,
		IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONLOAD,
		IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONEXPORT,
		IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONIMPORT,
		IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONRANDOM
	];

	// create buy button
	_btnBuy = _display ctrlCreate ["RscButtonMenu",7300,_grpControlsBar];
	_btnBuy ctrlSetText "BUY";
	_btnBuy ctrlSetPosition ctrlPosition _btnOk;
	_btnBuy ctrlAddEventHandler ["ButtonClick",_SELFEH("buy")];
	_btnBuy ctrlCommit 0;
	_btnOk ctrlShow false;
	_btnOk ctrlEnable false;

	// create cost text
	_stxtMoney = _display ctrlCreate ["RscStructuredText",7301];
	_stxtMoney ctrlSetBackgroundColor [0,0,0,0.5];
	call TER_fnc_moneyText;

	// handle listboxes
	// weapons and containers need some extra attention
	// remove standard ehs and add own ones
	{
		_x ctrlRemoveAllEventHandlers "LBSelChanged";
		_x ctrlAddEventHandler ["LBSelChanged",_SELFEH("selectItem")];
	} forEach [_lbPrimary,_lbSecondary,_lbHandgun,_lbUniform,_lbVest,_lbBackpack];

	// handle all other listboxes
	{
		_x setVariable ["_isInit",true];
	} forEach _attachementLBs;

	_forIlbLoop = {
		_control = ARSENAL_CTRL(_lb_idc);
		if (lbCurSel _control != -1) then {
			_startClass = _control lbData lbCurSel _control;
			_control setVariable ["startData",_startClass];
			_control setVariable ["_prevData",_startClass];
		};
		_control ctrlAddEventHandler ["LBSelChanged", _SELFEH("lbchanged")];
		[_control] spawn _fnclbPrice;
	};
	//960: lb weapons; 960-974 left lbs; 974-980 right lbs; 985: lb bipod
	for "_lb_idc" from 960/*974*/ to /*960*/980 do _forIlbLoop;
	for "_lb_idc" from 985/*974*/ to /*974*/985 do _forIlbLoop; // bipod idc was added later so the rsclistnboxes are in between

	// lb weapon slots need some extra attention to handle the attachments
	for "_idc_weapon" from 960 to 962 do {
		_control = ARSENAL_CTRL(_idc_weapon);
		_control ctrlAddEventHandler ["LBSelChanged",_SELFEH("updateAttachementPrices")];
	};
	for "_idc_weaponTab" from 930 to 932 do {// add eh to button tabs to set lb prices
		_control = ARSENAL_CTRL(_idc_weaponTab);
		_control ctrlAddEventHandler ["ButtonClick",_SELFEH("updateAttachementPrices")];
	};

	// rsc listnboxes: magazines items and stuff
	_stxtItemCost = _display ctrlCreate ["RscStructuredText",7302];
	_stxtItemCost ctrlSetBackgroundColor [0,0,0,0.5];
	_stxtItemCost ctrlSetPosition [0,0,0,0];
	_stxtItemCost ctrlCommit 0;

	{
		_x ctrlAddEventHandler ["LBSelChanged",_SELFEH("listnboxlbchanged")];
		_x ctrlAddEventHandler ["KillFocus",_SELFEH("killLNBFocus")];
		_x ctrlAddEventHandler ["SetFocus",_SELFEH("setLNBFocus")];
	} forEach _rightLBs;

	{
		_x ctrlAddEventHandler ["ButtonClick",_SELFEH("btnPlusMinus")];
	} forEach [_btnMinus, _btnPlus];
};
/* end init */
/* start switch eh */
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
		// add new loadout and close arsenal to reaload values
		TER_moneyNameSpace setVariable [TER_moneyVariable,_newBalance];
		_display setVariable ["loadoutOwned",getUnitLoadout player];
		_display closeDisplay 2;
		["#(argb,8,8,3)color(0,0,0,1)",false,nil,0,[0,0.5]] call BIS_fnc_textTiles;
		hint "Transaction successful";
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

case "updateattachementprices":{//update the lb price texts of the attachement lbs
	{
		[_x] spawn _fnclbPrice;
	} forEach _attachementLBs;
};

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

case "btnplusminus":{// handle the +/- buttons
	_ehArgs params ["_button"];
	_activeLB = _rightLBs select {ctrlEnabled _x} select 0;
	_itemCount = _activeLB lnbText [lbCurSel _activeLB,2];

	// change to check with item in XXX and canAddItemToXXX, remove spawn scope
	// has to be spawned bc this eh fires before any change to the loadout is done
	[_activeLB,_itemCount,_button,_fncItemText] spawn {
		#include "controls.sqf";
		params ["_activeLB","_itemCount","_button","_fncItemText"];
		// no changed items, do nothing
		if (_itemCount == _activeLB lnbText [lbCurSel _activeLB,2]) exitWith {};
		_lbData = _activeLB lnbData [lbCurSel _activeLB,0];
		_itemCost = [_lbData] call TER_fnc_itemCostFromTable;
		[_itemCost] call _fncItemText;
		// button is remove, substract cost instead of adding
		if (ctrlText _button == "-") then {_itemCost = -_itemCost};
		_newCost = _CURRENTCOST +_itemCost;
		ctrlParent _activeLB setVariable ["TER_cost",_newCost];
		[] call TER_fnc_moneyText;
	};
};

case "selectitem":{
	_ehArgs params ["_control","_index"];
	[_display,_control,ctrlIDC _control -IDC_RSCDISPLAYARSENAL_LIST] call (_display getVariable "_fncSelectItemEH");
};

default {};

};
/* end switch eh */