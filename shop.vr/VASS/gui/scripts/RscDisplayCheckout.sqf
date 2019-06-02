#include "\A3\Ui_f\hpp\defineResinclDesign.inc"
#include "idcs.inc"
#define SELF (compile preprocessFileLineNumbers "VASS\gui\scripts\RscDisplayCheckout.sqf")
#define MONEYGREEN [0.13,0.42,0.16,1]
//DEBUG
#define TER_fnc_getItemValues (compile preprocessFileLineNumbers "VASS\fnc\fn_getItemValues.sqf")
#define TER_fnc_resetTimer (compile preprocessFileLineNumbers "VASS\fnc\fn_resetTimer.sqf")

params ["_mode","_this"];
switch _mode do {
	case "onLoad":{
		//--- Init GUI
		params ["_grpCheckout"];
		_displayArsenal = ctrlParent _grpCheckout;
		private _center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
		//--- Tabs Added/Removed
		_tabsChange = _grpCheckout controlsGroupCtrl IDC_RSCDISPLAYCHECKOUT_TABSCHANGE;
		_tabsChange ctrlAddEventHandler ["ToolBoxSelChanged",{
			with uiNamespace do {["tabChange",_this] call SELF};
		}];
		//--- LNB header line
		_header = _grpCheckout controlsGroupCtrl IDC_RSCDISPLAYCHECKOUT_LNBHEADERITEMS;
		_header lnbAddRow ["","#","Item","Price","Total"];
		_header ctrlEnable false;
		//--- LNB items
		_lnbItemsAdded = _grpCheckout controlsGroupCtrl IDC_RSCDISPLAYCHECKOUT_LNBITEMSADDED;
		_lnbItemsRemoved = _grpCheckout controlsGroupCtrl IDC_RSCDISPLAYCHECKOUT_LNBITEMSREMOVED;
		_lnbItemsRemoved ctrlEnable false;
		//--- Button buy
		_btnBuy = _grpCheckout controlsGroupCtrl IDC_RSCDISPLAYCHECKOUT_BTNBUY;
		_btnBuy ctrlAddEventHandler ["ButtonClick",{
			with uiNamespace do {["btnBuy",_this] call SELF};
		}];
		//--- Button return
		_btnReturn = _grpCheckout controlsGroupCtrl IDC_RSCDISPLAYCHECKOUT_BTNRETURN;
		_btnReturn ctrlAddEventHandler ["ButtonClick",{
			with uiNamespace do {["btnReturn",_this] call SELF};
		}];
	};
	case "refresh":{
		params ["_grpCheckout"];
		_displayArsenal = ctrlParent _grpCheckout;
		_grpCheckout ctrlsetfade 0;
		_grpCheckout ctrlcommit 0.15;
		_grpCheckout ctrlenable true;
		private _center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
		//--- LNB items
		_lnbItemsAdded = _grpCheckout controlsGroupCtrl IDC_RSCDISPLAYCHECKOUT_LNBITEMSADDED;
		_lnbItemsRemoved = _grpCheckout controlsGroupCtrl IDC_RSCDISPLAYCHECKOUT_LNBITEMSREMOVED;
		{lnbClear _x} forEach [_lnbItemsAdded, _lnbItemsRemoved];
		/*
			_newLoadout = getUnitLoadout _center;
			_oldLoadout = _displayArsenal getVariable ["shop_loadoutStart",getUnitLoadout (configFile >> "EmptyLoadout")];
			_changed = [_newLoadout,_oldLoadout] call {
				params ["_previousLoadout","_newLoadout"];

				_pItems = [];
				_nItems = [];
				_fnc1DLoadout = {
					_loadout = _this;
					_array = [];
					// handle weapons
					_weaponArrays = _loadout select [0,3];
					_weaponArrays pushBack (_loadout select 8);
					{
						_curArray = _x;
						_flatArray = _curArray call {
							//--- Author: KillzoneKid ---//
							private ["_res", "_fnc"];
							_res = [];
							_fnc = {
								{
									if (typeName _x isEqualTo "ARRAY") then [
										{_x call _fnc; false},
										{_res pushBack _x; false}
									];
								} count _this;
							};
							_this call _fnc;
							_res
						};
						_flatArray = _flatArray select {_x isEqualType ""};
						_array append _flatArray;
					} forEach _weaponArrays;
					// handle container
					_containers = _loadout select [3,3];
					_containersAsItems = _containers apply {
						if (count _x > 0) then {_x select 0}
						else {""};
					};
					_array append _containersAsItems;
					_containerItemArrays = _containers apply {
							if (count _x > 0) then {_x select 1}
							else {nil}
					};
					_containerItemArrays = _containerItemArrays -[nil];
					{
						if !(isNil "_x") then {
							_curContainer = _x;
							{
								if (count _x > 0) then {
									for "_i" from 1 to (_x select 1) do {
										_array pushBack (_x select 0);
									};
								};
							} forEach _curContainer;
						};
					} forEach _containerItemArrays;
					// helmet, facewear
					_array = _array +(_loadout select [6,1]);
					//assigned items
					_array = _array +(_loadout select 9);

					_array = _array -["",nil];
					_array
				};

				_pItems = _previousLoadout call _fnc1DLoadout;
				_nItems = _newLoadout call _fnc1DLoadout;

				_pairs = [];
				{
					_pairs = [_pairs,_x,1] call BIS_fnc_addToPairs;
				} forEach _nItems;
				{
					_pairs = [_pairs,_x,-1] call BIS_fnc_addToPairs;
				} forEach _pItems;
				_pairs = _pairs select {_x#1 != 0};

				_pairs
			};
		*/
		_columns = count lnbGetColumnsPosition _lnbItemsAdded;
		{
			_x params ["_item","_amount"];
			_ctrl = [_lnbItemsRemoved, _lnbItemsAdded] select (_amount > 0);
			_config = format ["configFile >> ""%1"" >> ""%2""","%1",_item];
			_itemCfg = {
				_itemCfg = call compile format [_config,_x];
				if (isClass _itemCfg) exitWith {_itemCfg};
				configNull
			} forEach ["CfgWeapons","CfgMagazines","CfgVehicles"];
			_itemName = _itemCfg call BIS_fnc_displayName;
			_itemPicture = getText (_itemCfg >> "picture");
			_itemPrice = [TER_VASS_shopObject, _item, 1] call TER_fnc_getItemValues;
			_ind = _ctrl lnbAddRow [
				"",
				format ["%1x", abs _amount],
				_itemName,
				format ["%1$",[_itemPrice] call BIS_fnc_numberText],
				format ["%1$",[_itemPrice * abs _amount] call BIS_fnc_numberText]
			];
			_ctrl lbsettooltip [_ind * _columns, _itemName];
			_ctrl lnbSetPicture [[_ind,0],_itemPicture];
		} forEach TER_VASS_changedItems;

		_ctrlMouseBlock = _displayArsenal displayctrl IDC_RSCDISPLAYARSENAL_MOUSEBLOCK;
		//_ctrlMouseBlock ctrlenable true;
		//ctrlsetfocus _ctrlMouseBlock;

		//--- Money info
		_stxtMoney = _grpCheckout controlsGroupCtrl IDC_RSCDISPLAYCHECKOUT_STXTMONEY;
		_tRed = "#FF0000";
		_tGreen = "#00FF00";
		_tWhite = "#FFFFFF"; // respect
		//--- Funds
		_funds = ["getMoney",[_center]] call (missionnamespace getVariable "TER_fnc_VASShandler");
		_fundsText = format ["<t align='left' color='#00FF00'>%1$</t>",_funds];
		//--- Costs
		_cost = _displayArsenal getVariable ["shop_cost",0];
		_grpCheckout setVariable ["shop_cost",_cost];
		_tColor = [_tGreen,_tRed] select (_cost > 0);
		_sign = ["+","-"] select (_cost > 0);
		if (_cost == 0) then {_tColor = _tWhite; _sign = "";};
		_costText = format ["<t align='center' color='%2'>%3%1$</t>",abs _cost,_tColor,_sign];
		//--- Difference
		_diff = _funds -_cost;
		_tColor = [_tGreen,_tRed] select (_diff < 0);
		_sign = ["+","-"] select (_diff < 0);
		if (_diff == 0) then {_tColor = _tWhite; _sign = "";};
		_diffText = format ["<t align='right' color='%2'>%3%1$",abs _diff,_tColor,_sign];

		_topLine = "<t align='left'>Current</t><t align='center'>Cost</t><t align='right'>Difference</t>";
		_stxtMoney ctrlSetStructuredText composeText [parsetext _topLine,lineBreak,parsetext _fundsText,parsetext _costText,parsetext _diffText];
		//--- Button buy
		_btnBuy = _grpCheckout controlsGroupCtrl IDC_RSCDISPLAYCHECKOUT_BTNBUY;
		if (_funds >= _cost) then {
			_btnBuy ctrlSetText "BUY";
			_btnBuy ctrlEnable true;
		} else {
			_btnBuy ctrlSetText "Not enough money";
			_btnBuy ctrlEnable false;
		};

		_tabsChange = _grpCheckout controlsGroupCtrl IDC_RSCDISPLAYCHECKOUT_TABSCHANGE;
		ctrlsetfocus _tabsChange;
	};
	case "tabChange":{
		params ["_tabsChange","_ind"];
		_grpCheckout = ctrlParentControlsGroup _tabsChange;
		{
			_ctrl = _grpCheckout controlsGroupCtrl _x;
			if (_forEachIndex == _ind) then {
				_ctrl ctrlEnable true;
				_ctrl ctrlShow true;
			} else {
				_ctrl ctrlEnable false;
				_ctrl ctrlShow false;
			};
		} forEach [IDC_RSCDISPLAYCHECKOUT_LNBITEMSADDED, IDC_RSCDISPLAYCHECKOUT_LNBITEMSREMOVED];
	};
	case "btnBuy":{
		params ["_btnBuy"];
		_grpCheckout = ctrlParentControlsGroup _btnBuy;
		_displayArsenal = ctrlParent _grpCheckout;
		_cost = _displayArsenal getVariable "shop_cost";
		//--- Update player's money
		["setMoney",[_center, -_cost]] call (missionnamespace getVariable "TER_fnc_VASShandler");
		//--- Update shop inventory
		_cargo = TER_VASS_shopObject getVariable ["TER_VASS_cargo",[]];
		_cargo = [0,-1] + _cargo;// if an item is not in the cargo these values will be used
		private _resetArray = [];
		{
			_x params ["_item", "_amount"];
			_findInd = _cargo findIf {_x isEqualTo _item};
			_indAmount = _findInd +2;// Amount of the item comes 2 places behind class
			if ((_cargo select _indAmount) != -1) then {// Only modify finite items (-1 indicates inifite ones)
				_newAmount = (_cargo select _indAmount) -_amount;
				_itemPrice = [TER_VASS_shopObject, _item, 1] call TER_fnc_getItemValues;
				if (abs _amount == _amount) then {_resetArray append [_item, _itemPrice, _amount];};
				if (_newAmount <= 0) then {// Delete empty items
					for "_i" from 0 to 2 do {_cargo deleteAt _findInd};
				} else {// Add/remove sold item count
					_cargo set [_indAmount, _newAmount];
				};
			};
		} forEach TER_VASS_changedItems;// Format: ["class", change]
		if (TER_VASS_shopObject getVariable ["TER_VASS_refresh",-1] > 0) then {
			// Reset inventory after certain time
			[TER_VASS_shopObject, _resetArray] spawn TER_fnc_resetTimer;
		};
		for "_i" from 0 to 1 do {_cargo deleteAt 0};//remove this script's default values
		TER_VASS_shopObject setVariable ["TER_VASS_cargo", _cargo, TER_VASS_shopObject getVariable ["TER_VASS_shared", true]];
		//--- Exit arsenal
		_displayArsenal closeDisplay 1;
		["#(argb,8,8,3)color(0,0,0,1)",false,nil,0,[0,0.5]] call bis_fnc_textTiles;
		["Exit"] call BIS_fnc_arsenal;
	};
	case "btnReturn":{
		params ["_btnReturn"];
		_grpCheckout = ctrlParentControlsGroup _btnReturn;
		_displayArsenal = ctrlParent _grpCheckout;
		_ctrlMouseBlock = _displayArsenal displayctrl IDC_RSCDISPLAYARSENAL_MOUSEBLOCK;
		_ctrlMouseBlock ctrlenable false;
		_grpCheckout ctrlEnable false;
		_grpCheckout ctrlSetFade 1;
		_grpCheckout ctrlCommit 0.15;
	};
};