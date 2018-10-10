/* Config part, change to your liking */
TER_moneyNameSpace = player; // where the money variable is saved
TER_moneyVariable = "TER_money"; // name of the money variable
TER_moneyUnit = "$"; // added behind all numbers which represent currency (duh)
//eg >player getVariable "TER_money";< will return the current amount of money the (local) player has
//>TER_moneyNameSpace getVariable TER_moneyVariable;< will do the same

_costArray = [// add your entries in the format >"classname",cost<
	"arifle_AK12_F",100,
	"arifle_AKM_F",50,
	"arifle_MX_F",75,
	"hgun_P07_F",20,
	"optic_DMS",10,
	"optic_ACO_grn",5,
	"B_AssaultPack_mcamo",25,
	"U_B_CombatUniform_mcam",15,
	"30Rnd_762x39_Mag_F",5,
	"30Rnd_65x39_caseless_mag",13
];

/* end of config */

  ///////////////////////////////////////////////////////////////////////////////
 ////			 		Set up system, pls dont change 						////
///////////////////////////////////////////////////////////////////////////////
// adjust the cost table
_costArray = _costArray +["",0];
_costArray = _costArray apply {
	if (_x isEqualType "STRING") then {
		toLower _x
	} else {
		_x
	};
};
TER_costArray = compileFinal str _costArray;//make unchangeable

_fncPath = "arsenalShop\fnc\fn_%1.sqf";
TER_fnc_addArsenal = compileFinal preprocessFileLineNumbers format [_fncPath,"addArsenal"];
TER_fnc_itemCostFromTable = compileFinal preprocessFileLineNumbers format [_fncPath,"itemCostFromTable"];
TER_fnc_arrayChange = compileFinal preprocessFileLineNumbers format [_fncPath,"arrayChange"];
TER_fnc_compareLoadout = compile preprocessFileLineNumbers format [_fncPath,"compareLoadout"];

// this is where the magic happens:
TER_fnc_arsenalEH = compile preprocessFileLineNumbers "arsenalShop\arsenalEH.sqf";
TER_arsenalOpenedEHID = [missionNamespace, "arsenalOpened", TER_fnc_arsenalEH] call BIS_fnc_addScriptedEventHandler;