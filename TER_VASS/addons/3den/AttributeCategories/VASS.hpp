class VASS
{
	displayName = "VASS";
	collapsed = 1;
	class Attributes
	{
		// class addAction
		// {
		// 	displayName = "";
		// 	tooltip = "";
		// 	property = "VASS_addAction";
		// 	control = "VASS_addAction";
		// 	expression = "\
		// 		_value = parseSimpleArray _value;\
		// 		if (_value#0 && !is3DEN) then {[_this,_value#1,parseNumber (_value#4),_value#2,parseNumber (_value#3)] call TER_fnc_addShop};\
		// 	";
		// 	defaultValue = """[false,'Shop','alive _this && alive _target','5','1.5']""";
		// };
		class cargo
		{
			displayName = "Shop Inventory";
			tooltip = "Define the items which the trader can sell and buy.\n""-"" means the item is not part of the shop, so not buyable or sellable. Script: -2.\n""∞"" means that the item will never run out. Script: -1.\n""0"" means that the item is not sold by the shop but can be sold to the trader. Script: 0.\nAny other number restricts the amonut of sellable items to the specified amount. If all items are sold out it is treated just as ""0"". Script: N.";
			property = "TER_VASS_cargo";
			control = "TER_VASS_AmmoBox2";
			expression = "[_this, parseSimpleArray _value, 2] call TER_fnc_addShopCargo;";
		};
		// class refresh
		// {
		// 	displayName = "Refresh";
		// 	tooltip = "Sets the time in seconds which the shop will take to add/remove the items that were removed/added during mission. -1 disables refreshing.";
		// 	property = "VASS_refesh";
		// 	control = "EditShort";
		// 	expression = "_this setVariable ['TER_VASS_refresh', _value];";
		// 	defaultValue = "-1";
		// 	validate = "number";
		// };
		// class shared
		// {
		// 	displayName = "Global";
		// 	tooltip = "If checked the inventory's shop will broadcast its changes over the network and make it the same for everyone.";
		// 	property = "VASS_shared";
		// 	control = "Checkbox";
		// 	expression = "_this setVariable ['TER_VASS_shared', _value];";
		// 	defaultValue = "true";
		// };
	};
};
