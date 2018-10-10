#include "controls.sqf"
#include "\A3\ui_f\hpp\defineDIKCodes.inc"
#define _PLAYER_MONEY (TER_moneyNameSpace getVariable [TER_moneyVariable,0])
#define _CURRENTCOST (_display getVariable ["TER_cost",0])
#define _SELFEH(ehname) {[ehname,_this] call TER_fnc_arsenalEH;}
#include "localFunctions.sqf"
// global ui function
TER_fnc_moneyText = {
	_btnMoneyNew = ARSENAL_CTRL(7303);
	_btnMoneyNew ctrlSetStructuredText parseText format [
		"Current Money: %1 %4<t align='center'>Cost: %2 %4</t><t align='right'>Balance: %3 %4</t>",
		_PLAYER_MONEY,
		_CURRENTCOST,
		_PLAYER_MONEY - _CURRENTCOST,
		TER_moneyUnit
	];
	//update lnb detail
	["updatedetails",[]] spawn TER_fnc_arsenalEH;
};

_display setVariable ["_fncSelectItemEH",compile preprocessFileLineNumbers "arsenalShop\selectItemEH.sqf"];

// handle loadout
_display setVariable ["loadoutOwned",getUnitLoadout player];
_display displayAddEventHandler ["unload",_SELFEH("unload")];

// keep controlsbar hidden
call _fncShowControlsbar;
_display displayaddeventhandler ["keydown",{["hidecontrolsbar",_this] spawn TER_fnc_arsenalEH;}];
_ctrlMouseArea ctrlAddEventHandler ["mousebuttonclick",{["hidecontrolsbar",_this] spawn TER_fnc_arsenalEH;}];

// create buy button
_btnBuy = _display ctrlCreate ["RscButtonMenu",7300,_grpControlsBar];
_btnBuy ctrlSetText "BUY";
_btnBuy ctrlSetPosition ctrlPosition _btnOk;
_btnBuy ctrlAddEventHandler ["ButtonClick",_SELFEH("buy")];
_btnBuy ctrlCommit 0;
_btnOk ctrlShow false;
_btnOk ctrlEnable false;

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
	_control ctrlAddEventHandler ["LBSelChanged",_SELFEH("weaponchanged")];
};
for "_idc_weaponTab" from 930 to 932 do {// add eh to button tabs to set lb prices
	_control = ARSENAL_CTRL(_idc_weaponTab);
	_control ctrlAddEventHandler ["ButtonClick",_SELFEH("weaponchanged")];
};

// rsc listnboxes: magazines items and stuff
{
	// add price column
	_x lnbSetColumnsPos [0.07,0.15,0.725];
	_column = _x lnbAddColumn 0.78;
	[_x] spawn _SELFEH("lnbPrice");
} forEach _rightLBs;

// add eh to uniform vest backpack controls to keep lnbprice up to date
{
	_addIDC = _x;
	{
		_ctrl = _display displayCtrl (_x +_addIDC);
		_ctrl ctrlAddEventHandler ["ButtonClick",{
			_lbCargoMagIDC = IDC_RSCDISPLAYARSENAL_LIST +IDC_RSCDISPLAYARSENAL_TAB_CARGOMAG;
			_lbCargoMag = (uiNamespace getVariable "RscDisplayArsenal") displayCtrl _lbCargoMagIDC;
			["lnbprice",[_lbCargoMag]] spawn TER_fnc_arsenalEH;
		}];
	} forEach [IDC_RSCDISPLAYARSENAL_ICON,IDC_RSCDISPLAYARSENAL_TAB];
} forEach [IDC_RSCDISPLAYARSENAL_TAB_UNIFORM,IDC_RSCDISPLAYARSENAL_TAB_VEST,IDC_RSCDISPLAYARSENAL_TAB_BACKPACK];


{
	_x ctrlAddEventHandler ["ButtonClick",_SELFEH("btnPlusMinus")];
} forEach [_btnMinus, _btnPlus];

// create cost text
_btnMoneyNew = _display ctrlCreate ["RscButtonMenu",7303,_grpControlsBar];
ctrlPosition _btnHide params ["_btnHideX","_btnHideY"];
_btnMoneyNew ctrlSetPosition [_btnHideX,_btnHideY,
	(ctrlPosition _btnBuy select 0) -_btnHideX -(0.1 * _wGrid),
	_hGrid
]; // position in the bottom ctrlsgrp between "close" and "buy"
_btnMoneyNew ctrlCommit 0;
_btnMoneyNew ctrlSetBackgroundColor [0,0,0,0.8];
_btnMoneyNew ctrlSetFont "PuristaLight";
_btnMoneyNew ctrlAddEventHandler ["ButtonClick",_SELFEH("buydetails")];
[] call TER_fnc_moneyText;

// create listNbox with buy details
_grpDetails = _display ctrlCreate ["RscControlsGroupNoScrollbars",7305];
(ctrlPosition _lbPrimary) params ["_llbX","_llbY","_llbW","_llbH"];
(ctrlPosition (_rightLBs select 0)) params ["_rlbX","_rlbY","_rlbW","_rlbH"];
//["_rlbX","_rlbY","_rlbW","_rlbH"]
_llbRBorder = _llbX + _llbW;
_grpW = (_rlbX - _llbRBorder) - (0.2 * _wGrid);
_grpH = _llbH;
_grpDetails ctrlSetPosition [
	_llbRBorder + 0.1 * _wGrid,
	_llbY,
	_grpW,
	_grpH
];
_grpDetails ctrlCommit 0;
_grpDetails setVariable ["_startPos",ctrlPosition _grpDetails];
	//sub controls
	_grpInX = 0.1 * _wGrid;
	_grpInY = 0.1 * _hGrid;
	_grpInW = _grpW -(0.2 * _wGrid);
	_grpInH = _grpH -(0.2 * _hGrid);

	_backDetail = _display ctrlCreate ["RscText",-1,_grpDetails];
	_backDetail ctrlSetPosition [0,0,_grpW,_grpH];
	_backDetail ctrlCommit 0;
	_backDetail ctrlSetBackgroundColor [0,0,0,0.5];

	_lnbDetail = _display ctrlCreate ["RscListNBox",7306,_grpDetails];
	_lnbDetail ctrlSetPosition [
		_grpInX,
		_grpInY,
		_grpInW,
		_grpInH -(0.1 * _hGrid)
	];
	_lnbDetail ctrlCommit 0;
	_lnbDetail ctrlSetBackgroundColor [1,0,0,0];

	for "_i" from 1 to 2 do {
		_lnbDetail lnbAddColumn 0;
	};
	_lnbDetail lnbSetColumnsPos [
		0.01,// pic
		0.08,//item
		0.6,//amount
		0.7,//cost single
		0.85// cost total
	];
	_lnbDetail ctrlEnable false;
/*
	_btnDetailClose = _display ctrlCreate ["RscButtonMenu",7307,_grpDetails];
	_btnDetailClose ctrlSetPosition [
		_grpInX,
		_grpInH - _hGrid,
		_grpInW,
		_hGrid
	];
	_btnDetailClose ctrlCommit 0;
	_btnDetailClose ctrlSetText "Close";
	_btnDetailClose ctrlAddEventHandler ["ButtonClick",_SELFEH("closedetail")];
*/
_btnMoneyNew spawn _SELFEH("buydetails");

// create credit control
_stxtCredit = _display ctrlCreate ["RscStructuredText",7304];
_stxtCredit ctrlSetPosition [0,0,1,1];
_stxtCredit ctrlCommit 0;
_stxtCredit ctrlSetStructuredText parseText format ["<t size='0.8' align='center'><a href='https://forums.bohemia.net/forums/topic/219677-release-virtual-arsenal-shop-system/'>Virtual%1Arsenal%1Shop%1System%1by 7erra</a>"," "];
_stxtCredit ctrlSetTextColor [1,1,1,1];
_tWidht = ctrlTextWidth _stxtCredit;
_tHeight = ctrlTextHeight _stxtCredit;
_stxtCredit ctrlSetPosition [
	safeZoneX + safeZoneW -_tWidht,
	safeZoneH + safeZoneY -_tHeight,
	_tWidht,
	_tHeight
];
_stxtCredit ctrlSetFade 1;
_stxtCredit ctrlCommit 0;
//_stxtCredit ctrlSetBackgroundColor [0,0,0,0.2];

// purchase detail button
/*
// revert loadout button ?
"\A3\Modules_F_Beta\data\FiringDrills\restart_ca.paa"
"\A3\ui_f_orange\data\cfgmarkers\memoryFragment_ca.paa"
*/

_display setVariable ["_isInit",false];