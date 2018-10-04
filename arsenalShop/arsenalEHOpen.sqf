#include "controls.inc"
#define _PLAYER_MONEY (TER_moneyNameSpace getVariable [TER_moneyVariable,0])
#define _CURRENTCOST (ARSENAL_DISPLAY getVariable ["TER_cost",0])
params ["_display","_toggleSpace"];
_costTable = +TER_costArray;
TER_loadoutOpen = getUnitLoadout player;
_display setVariable ["loadoutOwned",getUnitLoadout player];
_display displayAddEventHandler ["Unload",{
	params ["_display","_exitCode"];
	player setUnitLoadout (_display getVariable "loadoutOwned");
}];

// disable saving, loading, randomizing, export, import
{
	ARSENAL_CTRL(_x) ctrlEnable false;
} forEach [
	IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONSAVE,
	IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONLOAD,
	IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONEXPORT,
	IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONIMPORT
	//IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONRANDOM
];

// create buy button

_btnBuy = _display ctrlCreate ["RscButtonMenu",7300,GRP_CONTROLSBAR_CONTROLBAR];
_btnBuy ctrlSetText "BUY";
_btnBuy ctrlSetPosition ctrlPosition BTN_OK;
_btnBuy ctrlAddEventHandler ["ButtonClick",{
	params ["_control"];
	_newBalance = _PLAYER_MONEY -_CURRENTCOST;
	if (_newBalance >= 0) then {
		TER_moneyNameSpace setVariable [TER_moneyVariable,_newBalance];
		ARSENAL_DISPLAY setVariable ["loadoutOwned",getUnitLoadout player];
		ARSENAL_DISPLAY closeDisplay 2;
		["#(argb,8,8,3)color(0,0,0,1)",false,nil,0,[0,0.5]] call BIS_fnc_textTiles;
		hint "Transaction successful";
	} else {
		systemChat "Not enough money";
	};
}];
_btnBuy ctrlCommit 0;

BTN_OK ctrlShow false;
BTN_OK ctrlEnable false;
// create cost text
_stxtMoney = _display ctrlCreate ["RscStructuredText",7301];
_stxtMoney ctrlSetBackgroundColor [0,0,0,0.5];

TER_fnc_updateMoneyText = {
	STXT_MONEY ctrlSetStructuredText parseText format [
		"Current Money: %1 %3 %6%2<br/>Cost: %1 %4 %6%2<br/>Balance: %1 %5 %6%2",
		"<t align='right'>",
		"</t>",
		_PLAYER_MONEY,
		_CURRENTCOST,
		_PLAYER_MONEY - _CURRENTCOST,
		TER_moneyUnit
	];
	STXT_MONEY ctrlSetPosition [0,0,1,1];
	STXT_MONEY ctrlCommit 0;
	ctrlPosition LB_LIST_WEAPONS params ["_lbX","_lbY","_lbW","_lbH"];
	STXT_MONEY ctrlSetPosition [
		_lbX + _lbW + (0.1 * GUI_GRID_W),
		_lbY + _lbH - ctrlTextHeight STXT_MONEY,
		ctrlTextWidth STXT_MONEY,
		ctrlTextHeight STXT_MONEY
	];
	STXT_MONEY ctrlCommit 0;
};
call TER_fnc_updateMoneyText;

TER_fnc_setLBPrice = {
	params ["_listbox"];
	//if (canSuspend) then {uiSleep 0.001};
	for "_index" from 1 to lbSize _listbox do {
		_lbData = _listbox lbData _index;
		_costIndex = TER_costArray find _lbData;
		_itemCost = [_lbData] call TER_fnc_itemCostFromTable;
		if (_listbox lbPictureRight _index == "") then {
			_listbox lbSetPictureRight [_index,"#(rgb,8,8,3)color(1,0,0,0)"];
		};
		_listbox lbSetTextRight [_index,format ["%1 %2",_itemCost,TER_moneyUnit]];
	};
};

// detect new selections
_forIlbLoop = {
	_control = ARSENAL_CTRL(_lb_idc);
	_startClass = _control lbData lbCurSel _control;
	if (lbCurSel _control == -1) then {
		[_control] spawn {
			params ["_control"];
			waitUntil {lbCurSel _control != -1};
			_startClass = _control lbData lbCurSel _control;
			_control setVariable ["startData",_startClass];
		};
	} else {
		_control setVariable ["startData",_startClass];
	};

	//--- TODO: opening arsenal and selecting weapons costs money the first time for owned attachments
	_control ctrlAddEventHandler ["LBSelChanged", {
		params ["_control","_index"];

		_costTable = +TER_costArray;
		_lbData = _control lbData _index;
		// set cost of current gear to 0
		_startData = _control getVariable ["startData",""];
		_startDataIndex = _costTable find _startData;
		_ownedPrice = 0;
		if (_startDataIndex > -1) then {
			_ownedPrice = _costTable select (_startDataIndex +1);
			_costTable set [_startDataIndex +1, 0];
		};
		// readd money from previous calculation
		_prevItemCost = _control getVariable ["prevCost",0];
		// new cost
		_itemCost = [
			[_lbData] call TER_fnc_itemCostFromTable,
			0
		] select (_startData == _lbData);
		_newCost = _CURRENTCOST +_itemCost -_prevItemCost;
		ARSENAL_DISPLAY setVariable ["TER_cost",_newCost];
		_control setVariable ["prevCost",_itemCost];
		[] call TER_fnc_updateMoneyText;

		//systemChat str [_prevItemCost,_itemCost,_startDataIndex,_lbData,_startData];
	}];

	[_control] spawn TER_fnc_setLBPrice;

};

for "_lb_idc" from 960/*974*/ to /*974*/980 do _forIlbLoop;
for "_lb_idc" from 985/*974*/ to /*974*/985 do _forIlbLoop; // bipod idc was added later so the rsclistnboxes are in between

// lb weapon slots need some extra attention to handle the attachments
for "_idc_weapon" from 960 to 962 do {
	_control = ARSENAL_CTRL(_idc_weapon);
	_control ctrlAddEventHandler ["LBSelChanged",{
		params ["_control", "_index"];
		{
			[_x] spawn TER_fnc_setLBPrice;
		} forEach ATTACHMENT_LBS;

	}];
	_control lbSetCurSel (lbCurSel _control);
};
for "_idc_weaponTab" from 930 to 932 do {// add eh to button tabs to set lb prices
	_control = ARSENAL_CTRL(_idc_weaponTab);
	_control ctrlAddEventHandler ["ButtonClick",{
		{
			[_x] spawn TER_fnc_setLBPrice;
		} forEach ATTACHMENT_LBS;
	}];
};

// rsc listnboxes: magazines items and stuff
_stxtItemCost = _display ctrlCreate ["RscStructuredText",7302];
_stxtItemCost ctrlSetBackgroundColor [0,0,0,0.5];
_stxtItemCost ctrlSetPosition [0,0,0,0];
_stxtItemCost ctrlCommit 0;

TER_fnc_updateItemCostText = {
	params ["_price"];
	_stxtItemCost = STXT_ITEMCOST;
	_stxtItemCost ctrlSetStructuredText parseText format [
		"%1 %2",
		_price,
		TER_moneyUnit
	];
	_stxtItemCost ctrlSetPosition [0,0,1,1];
	_stxtItemCost ctrlCommit 0;
	ctrlPosition (LBNS_RIGHT select 0) params ["_lbX","_lbY","_lbW","_lbH"];
	_stxtItemCost ctrlSetPosition [
		_lbX - ctrlTextWidth _stxtItemCost - (0.1 * GUI_GRID_W),
		_lbY,
		ctrlTextWidth _stxtItemCost,
		ctrlTextHeight _stxtItemCost
	];
	_stxtItemCost ctrlCommit 0;
};

{
	_x ctrlAddEventHandler ["LBSelChanged",{
		params ["_control","_index"];
		_lbData = _control lnbData [_index,0];
		_itemCost = [_lbData] call TER_fnc_itemCostFromTable;
		[_itemCost] call TER_fnc_updateItemCostText;

	}];
	_x ctrlAddEventHandler ["KillFocus",{
		STXT_ITEMCOST ctrlSetFade 1;
		STXT_ITEMCOST ctrlCommit 0.5;
	}];
	_x ctrlAddEventHandler ["SetFocus",{
		STXT_ITEMCOST ctrlSetFade 0;
		STXT_ITEMCOST ctrlCommit 0.15;
	}];

} forEach LBNS_RIGHT;


{
	_x ctrlAddEventHandler ["ButtonClick",{
		params ["_button"];
		_activeLB = LBNS_RIGHT select {ctrlEnabled _x} select 0;
		_itemCount = _activeLB lnbText [lbCurSel _activeLB,2];
		[_activeLB,_itemCount,_button] spawn {
			params ["_activeLB","_itemCount","_button"];
			// no changed items
			if (_itemCount == _activeLB lnbText [lbCurSel _activeLB,2]) exitWith {};
			_lbData = _activeLB lnbData [lbCurSel _activeLB,0];
			_itemCost = [_lbData] call TER_fnc_itemCostFromTable;
			[_itemCost] call TER_fnc_updateItemCostText;
			if (ctrlText _button == "-") then {_itemCost = -_itemCost};

			_newCost = _CURRENTCOST +_itemCost;

			ctrlParent _activeLB setVariable ["TER_cost",_newCost];
			[] call TER_fnc_updateMoneyText;

		};
	}];
} forEach [BTN_MINUS, BTN_PLUS];

