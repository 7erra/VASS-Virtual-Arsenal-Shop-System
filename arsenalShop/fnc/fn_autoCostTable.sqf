/* CONFIG START */
// weapons
_weightMP = 1;
_maxHitMP = 1;
_indirectHitMP = 1;
// magazines
_mag_baseCost = 1;
_mag_initSpeedMP = 1;
_mag_bulletsMP = 1;
_mag_damageMP = 1;
_mag_indirectHitMP = 1;
_mag_indirectHitRangeMP = 1;
// items
_opticRangeMP = 1;
// gear
_gear_baseCost = 1;
_protectionMP = 1;
_capacityMP = 1;
_camoMP = 1;
/* CONFIG END */

params ["_startTable"];
_nameCfgArray = ["CfgWeapons","CfgMagazines","CfgVehicles","CfgGlasses"];
_cfgArray = [];
_evalArray = if (count _startTable == 0) then {// get array from configs
	{
		_cfgClasses = "isClass _x" configClasses (configFile >> _x);
		_cfgArray append _cfgClasses;
	} forEach _nameCfgArray;
	_cfgArray
} else {// use passed classnames, has to be in format config first
	{
		_startItem = _x;
		_toCfgArray = {
			_startConfig = configFile >> _x >> _startItem;
			if (isClass _startConfig) exitWith {_startConfig};
			configNull
		} forEach _nameCfgArray;
		_cfgArray pushBackUnique _toCfgArray;
	} forEach _startTable;
	_cfgArray
};
_costArray = _evalArray apply {
	_cfg = _x;
	_item = configName _x;
	_fntype = _item call BIS_fnc_itemType;
	_fntype params ["_category","_type"];
	_price = switch (_category) do {
		///////////////////////////////////
		case "Weapon":{
			_baseCost = switch (_type) do {// set the base costs of the weapon type to which the attibutes will be added
				case "AssaultRifle":{1};
				case "GrenadeLauncher":{2};
				case "Handgun":{3};
				case "Launcher":{4};
				case "MachineGun":{5};
				case "MissileLauncher":{6};
				case "RocketLauncher":{7};
				case "Shotgun":{8};
				case "Throw":{9};
				case "Rifle":{10};
				case "SubmachineGun":{11};
				case "SniperRifle":{12};
				default {false};
			};
			// increase with stats:
			if (_baseCost isEqualType false) exitWith {false};
			// more weight more cost
			_weight = getNumber (_cfg>>"WeaponSlotsInfo">>"mass");
			_baseCost = _baseCost +_weightMP * _weight;

			_muzzles = getArray(_cfg >> "muzzles");
			_magazines = getArray(_cfg >> "magazines");
			{
				_subMags = getArray (_cfg >> _x >> "magazines");
				_subMags apply {_magazines pushBackUnique _x};
			} forEach (_muzzles -["this"]);
			_ammo = _magazines apply {getText(configfile >> "CfgMagazines" >> _x >> "ammo")};
			// add damage attributes
			// stolen from @gc8 ;)
			_maxHit = 0;
			{
				private _ammo = getText (configfile >> "CfgMagazines" >> _x >> "ammo");
				_hit = getNumber(configfile >> "CfgAmmo" >> _ammo >> "hit");
				if(_maxHit < _hit) then {
					_maxHit = _hit;
				};
			} forEach _magazines;
			_baseCost = _baseCost + _maxHitMP * _maxHit;
			// take splash damage into account
			_cfgAmmoPaths = _ammo apply {configFile >> "CfgAmmo" >> _x};
			_indirectHitMax = [_cfgAmmoPaths,["indirectHit","indirectHitRange"]] call BIS_fnc_configExtremes;
			_maxIndirectHitAndRange = _indirectHitMax select 1;
			_maxIndirectHitAndRange apply {_baseCost = _baseCost + _indirectHitMP * _x};

			_baseCost
		};
		///////////////////////////////////
		case "Item": {
			switch (_type) do {
				case "AccessoryMuzzle":{13};
				case "AccessoryPointer":{14};
				case "AccessorySights":{// only takes max zoom into account
					_baseCost = 15;
					_opticCfg = _cfg >> "ItemInfo" >> "OpticsModes";
					_opticCfgClasses = "true" configClasses _opticCfg;
					_ranges = _opticCfgClasses apply {getNumber(_x >> "distanceZoomMax")};
					_maxRange = selectMax _ranges;
					_baseCost = _baseCost + _maxRange * _opticRangeMP;
					_baseCost;
				};
				case "AccessoryBipod":{16};
				case "Binocular":{
					switch _item do {// binoculars and rangefinder share the same type
						case "Rangefinder":{200};
						default {100};
					};
				};
				case "Compass":{18};
				case "FirstAidKit":{19};
				case "GPS":{20};
				case "LaserDesignator":{250};
				case "Map":{22};
				case "Medikit":{23};
				case "MineDetector":{24};
				case "NVGoggles":{25};
				case "Radio":{26};
				case "Toolkit":{27};
				case "UAVTerminal":{28};
				case "Unknown":{29};
				case "UnknownEquipment":{30};
				case "UnknownWeapon":{31};
				case "Watch":{32};
				default {false};
			};
		};
		///////////////////////////////////
		case "Equipment":{
			switch (_type) do {
				case "Glasses":{33};
				// calc by: protection + capacity + camouflage
				case "Headgear";
				case "Vest";
				case "Uniform";
				case "Backpack":{
					_baseCost = _gear_baseCost;
					// camo
					_classUnit = getText(_x >> "ItemInfo" >> "uniformClass");
					_camo = getNumber(configFile >> "CfgVehicles" >> _classUnit >> "camouflage");
					if (_camo > 0) then {
						_baseCost = _baseCost +(_camoMP/_camo);
					};
					// protection
					_cfgHitpoints = "true" configClasses (_cfg >> "ItemInfo" >> "HitpointsProtectionInfo");
					_cfgHitpoints apply {
						_armor = getNumber(_x >> "armor");
						_pass = getNumber(_x >> "passThrough");
						_baseCost = _baseCost + (_protectionMP/_pass * _armor);
					};
					// capacity
					_baseCost = if (getNumber(_cfg >> "scope") > 0) then {
						_capacity = getContainerMaxLoad _item;
						_addCost = _baseCost + _capacityMP * _capacity;
						_addCost
					} else {nil};
					// is assemblable //<- nice word
					if (getText(_cfg >> "assembleInfo" >> "assembleTo") != "") then {
						_baseCost = 1000;
					};
					_baseCost
				};
				default {false};
			};
		};
		///////////////////////////////////
		case "Magazine":{
			// calc: bulletcount + damage + speed
			switch (_type) do {
				case "Grenade";
				case "Missile";
				case "Rocket";
				case "Shell";
				case "ShotgunShell";
				case "Bullet":{
					_baseCost = _mag_baseCost;
					// bullet count
					_bullets = getNumber(_cfg >> "count");
					_baseCost = _baseCost +(_bullets * _mag_bulletsMP);
					// start speed
					_initSpeed = getNumber(_cfg >> "initSpeed");
					_baseCost = _baseCost + (_initSpeed * _mag_initSpeedMP);
					// damage
					_ammoClass = getText(_cfg >> "ammo");
					_ammoCfg = configFile >> "CfgAmmo" >> _ammoClass;
					_damage = getNumber(_ammoCfg >> "hit");
					_baseCost = _baseCost + (_damage * _mag_damageMP);
					// indirect
					_indirectHit = getNumber(_ammoCfg >> "indirectHit");
					_baseCost = _baseCost + (_indirectHit * _mag_indirectHitMP);
					_indirectHitRange = getNumber(_ammoCfg >> "indirectHitRange");
					_baseCost = _baseCost + (_indirectHitRange * _mag_indirectHitRangeMP);
					_baseCost
				};
				case "SmokeShell":{46};
				case "UnknownMagazine";
				default {false};
			};
		};
		///////////////////////////////////
		case "Mine":{
			switch (_type) do {
				case "Mine":{48};
				case "MineBounding":{49};
				case "MineDirectional":{50};
				default {false};
			};
		};
		///////////////////////////////////
		default {false};
	};
	_return = if (_price isEqualType 1234) then {
		[_item,ceil _price]
	} else {
		nil
	};
	_return
};
_costArray = _costArray -[nil];
_costTable = [];
{
	//if !((_x) in _startTable) then {
		for "_i" from 0 to 1 do {
			_costTable pushBack (_x select _i);
		};
	//};
} forEach _costArray;

_costTable
