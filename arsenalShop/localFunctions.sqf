// ui functions
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
_fncShowControlsbar = {
	// disable saving, loading, randomizing, export, import
	{
		private _ctrl = (_display displayCtrl _x);
		_ctrl ctrlShow false;
		_ctrl ctrlEnable false;
	} forEach [
		IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONINTERFACE,
		IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONSAVE,
		IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONLOAD,
		IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONEXPORT,
		IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONIMPORT,
		IDC_RSCDISPLAYARSENAL_CONTROLSBAR_BUTTONRANDOM
	];
};