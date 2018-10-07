#include "\A3\Ui_f\hpp\defineResinclDesign.inc"
#include "\A3\ui_f\hpp\defineDIKCodes.inc"
#define IDCS_LEFT\
	IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON,\
	IDC_RSCDISPLAYARSENAL_TAB_SECONDARYWEAPON,\
	IDC_RSCDISPLAYARSENAL_TAB_HANDGUN,\
	IDC_RSCDISPLAYARSENAL_TAB_UNIFORM,\
	IDC_RSCDISPLAYARSENAL_TAB_VEST,\
	IDC_RSCDISPLAYARSENAL_TAB_BACKPACK,\
	IDC_RSCDISPLAYARSENAL_TAB_HEADGEAR,\
	IDC_RSCDISPLAYARSENAL_TAB_GOGGLES,\
	IDC_RSCDISPLAYARSENAL_TAB_NVGS,\
	IDC_RSCDISPLAYARSENAL_TAB_BINOCULARS,\
	IDC_RSCDISPLAYARSENAL_TAB_MAP,\
	IDC_RSCDISPLAYARSENAL_TAB_GPS,\
	IDC_RSCDISPLAYARSENAL_TAB_RADIO,\
	IDC_RSCDISPLAYARSENAL_TAB_COMPASS,\
	IDC_RSCDISPLAYARSENAL_TAB_WATCH,\
	IDC_RSCDISPLAYARSENAL_TAB_FACE,\
	IDC_RSCDISPLAYARSENAL_TAB_VOICE,\
	IDC_RSCDISPLAYARSENAL_TAB_INSIGNIA

#define IDCS_RIGHT\
	IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC,\
	IDC_RSCDISPLAYARSENAL_TAB_ITEMACC,\
	IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE,\
	IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD,\
	IDC_RSCDISPLAYARSENAL_TAB_CARGOMAG,\
	IDC_RSCDISPLAYARSENAL_TAB_CARGOMAGALL,\
	IDC_RSCDISPLAYARSENAL_TAB_CARGOTHROW,\
	IDC_RSCDISPLAYARSENAL_TAB_CARGOPUT,\
	IDC_RSCDISPLAYARSENAL_TAB_CARGOMISC\

#define IDCS	[IDCS_LEFT,IDCS_RIGHT]

#define INITTYPES\
		_types = [];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_UNIFORM,["Uniform"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_VEST,["Vest"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_BACKPACK,["Backpack"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_HEADGEAR,["Headgear"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_GOGGLES,["Glasses"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_NVGS,["NVGoggles"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_BINOCULARS,["Binocular","LaserDesignator"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON,["AssaultRifle","MachineGun","SniperRifle","Shotgun","Rifle","SubmachineGun"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_SECONDARYWEAPON,["Launcher","MissileLauncher","RocketLauncher"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_HANDGUN,["Handgun"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_MAP,["Map"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_GPS,["GPS","UAVTerminal"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_RADIO,["Radio"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_COMPASS,["Compass"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_WATCH,["Watch"]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_FACE,[]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_VOICE,[]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_INSIGNIA,[]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC,[]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_ITEMACC,[]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE,[]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD,[]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_CARGOMAG,[]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_CARGOMAGALL,[]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_CARGOTHROW,[/*"Grenade","SmokeShell"*/]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_CARGOPUT,[/*"Mine","MineBounding","MineDirectional"*/]];\
		_types set [IDC_RSCDISPLAYARSENAL_TAB_CARGOMISC,["FirstAidKit","Medikit","MineDetector","Toolkit"]];

#define GETVIRTUALCARGO\
	_virtualItemCargo =\
		(missionnamespace call bis_fnc_getVirtualItemCargo) +\
		(_cargo call bis_fnc_getVirtualItemCargo) +\
		items _center +\
		assigneditems _center +\
		primaryweaponitems _center +\
		secondaryweaponitems _center +\
		handgunitems _center +\
		[uniform _center,vest _center,headgear _center,goggles _center];\
	_virtualWeaponCargo = [];\
	{\
		_weapon = _x call bis_fnc_baseWeapon;\
		_virtualWeaponCargo set [count _virtualWeaponCargo,_weapon];\
		{\
			private ["_item"];\
			_item = gettext (_x >> "item");\
			if !(_item in _virtualItemCargo) then {_virtualItemCargo set [count _virtualItemCargo,_item];};\
		} foreach ((configfile >> "cfgweapons" >> _x >> "linkeditems") call bis_fnc_returnchildren);\
	} foreach ((missionnamespace call bis_fnc_getVirtualWeaponCargo) + (_cargo call bis_fnc_getVirtualWeaponCargo) + weapons _center + [binocular _center]);\
	_virtualMagazineCargo = (missionnamespace call bis_fnc_getVirtualMagazineCargo) + (_cargo call bis_fnc_getVirtualMagazineCargo) + magazines _center;\
	_virtualBackpackCargo = (missionnamespace call bis_fnc_getVirtualBackpackCargo) + (_cargo call bis_fnc_getVirtualBackpackCargo) + [backpack _center];

#define STATS_WEAPONS\
	["reloadtime","dispersion","maxzeroing","hit","mass","initSpeed"],\
	[true,true,false,true,false,false]

#define STATS_EQUIPMENT\
	["passthrough","armor","maximumLoad","mass"],\
	[false,false,false,false]

#define ADDBINOCULARSMAG\
	_magazines = getarray (configfile >> "cfgweapons" >> _item >> "magazines");\
	if (count _magazines > 0) then {_center addmagazine (_magazines select 0);};

#define CONDITION(LIST)	(_fullVersion || {"%ALL" in LIST} || {{_item == _x} count LIST > 0})
#define ERROR if !(_item in _disabledItems) then {_disabledItems set [count _disabledItems,_item];};
#define MODLIST ["","curator","kart","heli","mark","expansion","expansionpremium"]
#define GETDLC\
	{\
		private _dlc = "";\
		private _addons = configsourceaddonlist _this;\
		if (count _addons > 0) then {\
			private _mods = configsourcemodlist (configfile >> "CfgPatches" >> _addons select 0);\
			if (count _mods > 0) then {\
				_dlc = _mods select 0;\
			};\
		};\
		_dlc\
	}

#define ADDMODICON\
	{\
		private _dlcName = _this call GETDLC;\
		if (_dlcName != "") then {\
			_ctrlList lbsetpictureright [_lbAdd,(modParams [_dlcName,["logo"]]) param [0,""]];\
			_modID = _modList find _dlcName;\
			if (_modID < 0) then {_modID = _modList pushback _dlcName;};\
			_ctrlList lbsetvalue [_lbAdd,_modID];\
		};\
	};

// own defines
#include "controls.sqf"
#define _PLAYER_MONEY (TER_moneyNameSpace getVariable [TER_moneyVariable,0])
#define _CURRENTCOST (_display getVariable ["TER_cost",0])

_fullVersion = missionnamespace getvariable ["BIS_fnc_arsenal_fullArsenal",false];

private ["_ctrlList","_index","_cursel"];
_display = _this select 0;
_ctrlList = _this select 1;
_index = _this select 2;
_cursel = lbcursel _ctrlList;
if (_cursel < 0) exitwith {};
_item = if (ctrltype _ctrlList == 102) then {_ctrlList lnbdata [_cursel,0]} else {_ctrlList lbdata _cursel};
_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);

_ctrlListPrimaryWeapon = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON);
_ctrlListSecondaryWeapon = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYARSENAL_TAB_SECONDARYWEAPON);
_ctrlListHandgun = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYARSENAL_TAB_HANDGUN);

_fncRefundLostItems = {
	params ["_prevItems","_afterItems"];
	{
		_removedItem = _afterItems deleteAt (_prevItems find _x);
		if (isNil "_removedItem") then {//refund
			_xPrice = _x call TER_fnc_itemCostFromTable;
			_display setVariable ["TER_cost",_CURRENTCOST -_xPrice];
			[] call TER_fnc_moneyText;
		};
	} forEach _prevItems;
	_prevItems
};
_fncHandleLoadedMagazine = {
	params ["_magazines"];
	{
		if (
			_center canAddItemToUniform _x OR
			_center canAddItemToVest _x OR
			_center canAddItemToBackpack _x
		) then {//move magazine to container
			_center addMagazine _x;
		} else {//refund magazine
			_magCost = _x call TER_fnc_itemCostFromTable;
			_display setVariable ["TER_cost",_CURRENTCOST -_magCost];
		};
	} forEach _magazines;
};

switch _index do {
	case IDC_RSCDISPLAYARSENAL_TAB_UNIFORM: {
		_items = uniformitems _center;
		if (_item == "") then {
			removeuniform _center;
		} else {
			_center forceadduniform _item;
			while {count uniformitems _center > 0} do {_center removeitemfromuniform (uniformitems _center select 0);}; //--- Remove default config contents
			{_center additemtouniform _x;} foreach _items;
		};
		// refund removed items
		[_items,uniformitems _center] call _fncRefundLostItems;

		//--- Refresh insignia (gets removed when uniform changes)
		['SelectItem',[_display,_display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYARSENAL_TAB_INSIGNIA),IDC_RSCDISPLAYARSENAL_TAB_INSIGNIA]] spawn bis_fnc_arsenal;
	};
	case IDC_RSCDISPLAYARSENAL_TAB_VEST: {
		_items = vestitems _center;
		if (_item == "") then {
			removevest _center;
		} else {
			_center addvest _item;
			while {count vestitems _center > 0} do {_center removeitemfromvest (vestitems _center select 0);}; //--- Remove default config contents
			{_center additemtovest _x;} foreach _items;
		};
		[_items,vestitems _center] call _fncRefundLostItems;
	};
	case IDC_RSCDISPLAYARSENAL_TAB_BACKPACK: {
		_items = backpackitems _center;
		removebackpack _center;
		if !(_item == "") then {
			_center addbackpack _item;
			while {count backpackitems _center > 0} do {_center removeitemfrombackpack (backpackitems _center select 0);}; //--- Remove default config contents
			{_center additemtobackpack _x;} foreach _items;
		};
		[_items,backpackitems _center] call _fncRefundLostItems;
	};
	case IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON: {
		_isDifferentWeapon = (primaryweapon _center call bis_fnc_baseWeapon) != _item;
		if (_isDifferentWeapon) then {
			[primaryWeaponMagazine _center] call _fncHandleLoadedMagazine;
			if (_item == "") then {
				_center removeweapon primaryweapon _center;
			} else {
				_compatibleItems = _item call bis_fnc_compatibleItems;
				_weaponAccessories = primaryweaponitems _center - [""];
				[_center,_item,0] call bis_fnc_addweapon;
				{
					_acc = _x;
					if ({_x == _acc} count _compatibleItems > 0) then {_center addprimaryweaponitem _acc;};
				} foreach _weaponAccessories;
			};
		};
	};
	case IDC_RSCDISPLAYARSENAL_TAB_SECONDARYWEAPON: {
		_isDifferentWeapon = (secondaryweapon _center call bis_fnc_baseWeapon) != _item;
		if (_isDifferentWeapon) then {
			[secondaryWeaponMagazine _center] call _fncHandleLoadedMagazine;
			if (_item == "") then {
				_center removeweapon secondaryweapon _center;
			} else {
				_compatibleItems = _item call bis_fnc_compatibleItems;
				_weaponAccessories = secondaryweaponitems _center - [""];
				[_center,_item,0] call bis_fnc_addweapon;
				{
					_acc = _x;
					if ({_x == _acc} count _compatibleItems > 0) then {_center addsecondaryweaponitem _acc;};
				} foreach _weaponAccessories;
			};
		};
	};
	case IDC_RSCDISPLAYARSENAL_TAB_HANDGUN: {
		_isDifferentWeapon = (handgunweapon _center call bis_fnc_baseWeapon) != _item;
		if (_isDifferentWeapon) then {
			[handgunMagazine _center] call _fncHandleLoadedMagazine;
			if (_item == "") then {
				_center removeweapon handgunweapon _center;
			} else {
				_compatibleItems = _item call bis_fnc_compatibleItems;
				_weaponAccessories = handgunitems _center - [""];
				[_center,_item,0] call bis_fnc_addweapon;
				{
					_acc = _x;
					if ({_x == _acc} count _compatibleItems > 0) then {_center addhandgunitem _acc;};
				} foreach _weaponAccessories;
			};
		};
	};
};

//--- Container Cargo
if (
	_index in [IDC_RSCDISPLAYARSENAL_TAB_UNIFORM,IDC_RSCDISPLAYARSENAL_TAB_VEST,IDC_RSCDISPLAYARSENAL_TAB_BACKPACK]
	&&
	ctrlenabled (_display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _index))
) then {
	_cargo = (missionnamespace getvariable ["BIS_fnc_arsenal_cargo",objnull]);
	GETVIRTUALCARGO

	_itemsCurrent = [];
	_load = 0;
	switch _index do {
		case IDC_RSCDISPLAYARSENAL_TAB_UNIFORM: {
			_itemsCurrent = uniformitems _center;
			_load = if (uniform _center == "") then {1} else {loaduniform _center};
		};
		case IDC_RSCDISPLAYARSENAL_TAB_VEST: {
			_itemsCurrent = vestitems _center;
			_load = if (vest _center == "") then {1} else {loadvest _center};
		};
		case IDC_RSCDISPLAYARSENAL_TAB_BACKPACK: {
			_itemsCurrent = backpackitems _center;
			_load = if (backpack _center == "") then {1} else {loadbackpack _center};
		};
		default {[]};
	};

	_ctrlLoadCargo = _display displayctrl IDC_RSCDISPLAYARSENAL_LOADCARGO;
	_ctrlLoadCargo progresssetposition _load;

	//--- Weapon magazines (based on current weapons)
	private ["_ctrlList"];
	_ctrlList = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYARSENAL_TAB_CARGOMAG);
	_columns = count lnbGetColumnsPosition _ctrlList;
	lbclear _ctrlList;
	_magazines = [];
	{
		_cfgWeapon = configfile >> "cfgweapons" >> _x;
		{
			_cfgMuzzle = if (_x == "this") then {_cfgWeapon} else {_cfgWeapon >> _x};
			{
				private ["_item"];
				_item = _x;
				if (CONDITION(_virtualMagazineCargo)) then {
					_mag = tolower _item;
					if !(_mag in _magazines) then {
						_magazines set [count _magazines,_mag];
						_value = {_x == _mag} count _itemsCurrent;
						_displayName = gettext (configfile >> "cfgmagazines" >> _mag >> "displayName");
						_lbAdd = _ctrlList lnbaddrow ["",_displayName,str _value];
						_ctrlList lnbsetdata [[_lbAdd,0],_mag];
						_ctrlList lnbsetvalue [[_lbAdd,0],getnumber (configfile >> "cfgmagazines" >> _mag >> "mass")];
						_ctrlList lnbsetpicture [[_lbAdd,0],gettext (configfile >> "cfgmagazines" >> _mag >> "picture")];
						_ctrlList lbsettooltip [_lbAdd * _columns,format ["%1\n%2",_displayName,_item]];
					};
				};
			} foreach getarray (_cfgMuzzle >> "magazines");
		} foreach getarray (_cfgWeapon >> "muzzles");
	} foreach (weapons _center - ["Throw","Put"]);
	_ctrlList lbsetcursel (lbcursel _ctrlList max 0);

	//--- Update counts for all items in the list
	{
		_ctrlList = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _x);
		if (ctrlenabled _ctrlList) then {
			for "_l" from 0 to (lbsize _ctrlList - 1) do {
				_class = _ctrlList lnbdata [_l,0];
				_ctrlList lnbsettext [[_l,2],str ({_x == _class} count _itemsCurrent)];
			};
			["SelectItemRight",[_display,_ctrlList,_index]] call bis_fnc_arsenal;
		};
	} foreach [
		IDC_RSCDISPLAYARSENAL_TAB_CARGOMAG,
		IDC_RSCDISPLAYARSENAL_TAB_CARGOMAGALL,
		IDC_RSCDISPLAYARSENAL_TAB_CARGOTHROW,
		IDC_RSCDISPLAYARSENAL_TAB_CARGOPUT,
		IDC_RSCDISPLAYARSENAL_TAB_CARGOMISC
	];
};

//--- Weapon attachments
_modList = MODLIST;
if (
	_index in [IDC_RSCDISPLAYARSENAL_TAB_PRIMARYWEAPON,IDC_RSCDISPLAYARSENAL_TAB_SECONDARYWEAPON,IDC_RSCDISPLAYARSENAL_TAB_HANDGUN]
	&&
	ctrlenabled (_display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _index))
) then {
	private ["_ctrlList"];

	_cargo = (missionnamespace getvariable ["BIS_fnc_arsenal_cargo",objnull]);
	GETVIRTUALCARGO

	{
		_ctrlList = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _x);
		lbclear _ctrlList;
		_ctrlList lbsetcursel -1;
	} foreach [
		IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE,
		IDC_RSCDISPLAYARSENAL_TAB_ITEMACC,
		IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC,
		IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD
	];

	//--- Attachments
	_compatibleItems = _item call bis_fnc_compatibleItems;
	{
		private ["_item"];
		_item = _x;
		_itemCfg = configfile >> "cfgweapons" >> _item;
		_scope = if (isnumber (_itemCfg >> "scopeArsenal")) then {getnumber (_itemCfg >> "scopeArsenal")} else {getnumber (_itemCfg >> "scope")};
		if (_scope == 2 && CONDITION(_virtualItemCargo)) then {
			_type = _item call bis_fnc_itemType;
			_idcList = switch (_type select 1) do {
				case "AccessoryMuzzle": {IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE};
				case "AccessoryPointer": {IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYARSENAL_TAB_ITEMACC};
				case "AccessorySights": {IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC};
				case "AccessoryBipod": {IDC_RSCDISPLAYARSENAL_LIST + IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD};
				default {-1};
			};
			_ctrlList = _display displayctrl _idcList;
			_lbAdd = _ctrlList lbadd gettext (_itemCfg >> "displayName");
			_ctrlList lbsetdata [_lbAdd,_item];
			_ctrlList lbsetpicture [_lbAdd,gettext (_itemCfg >> "picture")];
			_ctrlList lbsettooltip [_lbAdd,format ["%1\n%2",gettext (_itemCfg >> "displayName"),_item]];
			_itemCfg call ADDMODICON;
		};
	} foreach _compatibleItems;

	//--- Magazines
	_weapon = switch true do {
		case (ctrlenabled _ctrlListPrimaryWeapon): {primaryweapon _center};
		case (ctrlenabled _ctrlListSecondaryWeapon): {secondaryweapon _center};
		case (ctrlenabled _ctrlListHandgun): {handgunweapon _center};
		default {""};
	};

	//--- Select current
	_weaponAccessories = _center weaponaccessories _weapon;
	{
		_ctrlList = _display displayctrl (IDC_RSCDISPLAYARSENAL_LIST + _x);
		_lbAdd = _ctrlList lbadd format ["<%1>",localize "str_empty"];
		_ctrlList lbsetvalue [_lbAdd,-1];
		lbsort _ctrlList;
		for "_l" from 0 to (lbsize _ctrlList - 1) do {
			_data = _ctrlList lbdata _l;
			if (_data != "" && {{_data == _x} count _weaponAccessories > 0}) exitwith {_ctrlList lbsetcursel _l;};
		};
		if (lbcursel _ctrlList < 0) then {_ctrlList lbsetcursel 0;};

		_ctrlSort = _display displayctrl (IDC_RSCDISPLAYARSENAL_SORT + _x);
		["lbSort",[[_ctrlSort,lbcursel _ctrlSort],_x]] call bis_fnc_arsenal;
	} foreach [
		IDC_RSCDISPLAYARSENAL_TAB_ITEMMUZZLE,
		IDC_RSCDISPLAYARSENAL_TAB_ITEMACC,
		IDC_RSCDISPLAYARSENAL_TAB_ITEMOPTIC,
		IDC_RSCDISPLAYARSENAL_TAB_ITEMBIPOD
	];
};

//--- Calculate load
_ctrlLoad = _display displayctrl IDC_RSCDISPLAYARSENAL_LOAD;
_ctrlLoad progresssetposition load _center;


if (ctrlenabled _ctrlList) then {
	_itemCfg = switch _index do {
		case IDC_RSCDISPLAYARSENAL_TAB_BACKPACK:	{configfile >> "cfgvehicles" >> _item};
		case IDC_RSCDISPLAYARSENAL_TAB_GOGGLES:		{configfile >> "cfgglasses" >> _item};
		case IDC_RSCDISPLAYARSENAL_TAB_FACE:		{
			_faces = missionnamespace getvariable ["bis_fnc_arsenal_faces",[]];
			_faceID = _faces find tolower _item;
			if (_faceID >= 0) then {
				_faces select (_faceID + 1);
			} else {
				configfile
			};
			//((configfile >> "cfgfaces") select (_ctrlList lbvalue _cursel)) >> _item
		};
		case IDC_RSCDISPLAYARSENAL_TAB_VOICE:		{configfile >> "cfgvoice" >> _item};
		case IDC_RSCDISPLAYARSENAL_TAB_INSIGNIA:	{configfile >> "cfgunitinsignia" >> _item};
		case IDC_RSCDISPLAYARSENAL_TAB_CARGOMAG;
		case IDC_RSCDISPLAYARSENAL_TAB_CARGOMAGALL;
		case IDC_RSCDISPLAYARSENAL_TAB_CARGOTHROW;
		case IDC_RSCDISPLAYARSENAL_TAB_CARGOPUT;
		case IDC_RSCDISPLAYARSENAL_TAB_CARGOMISC:	{configfile >> "cfgmagazines" >> _item};
		default						{configfile >> "cfgweapons" >> _item};
	};

	["ShowItemInfo",[_itemCfg]] call bis_fnc_arsenal;
	["ShowItemStats",[_itemCfg]] call bis_fnc_arsenal;
};