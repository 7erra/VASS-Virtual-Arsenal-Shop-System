// This script can be ignored its only purpose is to clarifiy things ingame
waituntil {time > 1};
if (isclass (configfile >> "CfgPatches" >> "TER_VASS")) then {
    hintc "You don't have the @VASS mod loaded! The mission just got compromised and is not functional anymore because all 3den attributes were deleted. Please load the mod and download the mission again.";
};
[missionnamespace, "arsenalOpened",{
    params ["_display"];
    _header = "";
    _message = switch TER_VASS_shopObject do {
        case traderQuantities:{
            _header = "Quantities";
            "This trader only sells a certain amount of items. As an example there are four different kinds of chemlights. You are in possesion of all colors. The trader only has a certain amount of them: Blue - 0, Green - 1, Red - -1 (infinite), Yellow - -2 (not present). -2 (indicated by a ""-"" sign in 3den) will remove the item from the inventory. If the amount of items is set to -1 (indicated in the 3den section with the infinite symbol) the trader will have an infinte amount of items. If the amount was set to 0 the trader can not sell any items of this kind but can buy the specified item. Every other number will specifiy the amount of items the trader has at the start of the mission. Modifiying amounts during mission runtime is possible with the TER_fnc_addShopCargo function and the overwrite mode 1 (see the function description for more info). The TER_fnc_resetTimer function allows you to readd or remove items which changed during the mission."
        };
        case traderPrices:{
            _header = "Prices";
            "You can modify the prices of a trader with the edit box below the item table. Simply select an item from the list, add it to the cargo and then set the price with the edit box. Setting a price but not adding the item (any value greated than -2 adds the item) will not save the item price as it gets removed automatically. This example has set the price of the MX rifle to 250$ and its ammunition to 30$ each with a maximum quantitiy of six. Modifiying prices during mission runtime is possible with the TER_fnc_addShopCargo function and the overwrite mode 1 (see the function description for more info)."
        };
        case traderReset:{
            _header = "Reset Timer";
            "Setting a (positive) number in the reset edit box adds a timer to the trader after which time in seconds the trader regains the removed or added items again. In this example the trader has 6 6.5mm magazines. Buying 2 of them leaves 4 in the shop (quick maths). Waiting 10 seconds will readd those two magazines bringing the count back to 6 as it was first. If you were to buy 1 magazine, leave the shop and then reenter the shop after 1 second again to buy another magazine then the system would first readd the first magazine after the 10 seconds and then readd the second magazone after 11 seconds (10 seconds after the second buy action). The whole operation also goes the other way around, so if a player sold an item to the trader this item would get removed after 10 seconds."
        };
        default {""};
    };
    [parsetext format ["<t size='0.8'>%1",_message], _header, "OK", false, _display, true] spawn BIS_fnc_GUImessage;
}] call BIS_fnc_addScriptedEventHandler;