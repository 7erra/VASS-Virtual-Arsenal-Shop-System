class VASS
{
	displayName = "VASS";
	collapsed = 1;
	class Attributes
	{
		class addAction
		{
			displayName = "";
			tooltip = "";
			property = "VASS_addAction";
			control = "VASS_addAction";
			expression = "\
				if (_value isEqualType [] && {_value#0 && !is3DEN}) then {[_this, _value#1, _value#4,_value#2, _value#3] call TER_fnc_addShop};\
			";
		};
		class cargo
		{
			displayName = "Shop Inventory";
			tooltip = "Array in format [""class0"", price, amount, ""class1"", price, amount, ...].";
			property = "VASS_cargo";
			control = "TER_VASS_AmmoBox2";
			expression = "\
				if (\
					_value select [0,1] == '[' &&\
					_value select [count _value -1,1] == ']'\
				) then {\
					[_this, parseSimpleArray _value, 2] call TER_fnc_addShopCargo;\
				};";
		};
		class refresh
		{
			displayName = "Refresh";
			tooltip = "Sets the time in seconds which the shop will take to add/remove the items that were removed/added during mission. -1 disables refreshing.";
			property = "VASS_refesh";
			control = "EditShort";
			expression = "_this setVariable ['TER_VASS_refresh', _value];";
			defaultValue = "-1";
			validate = "number";
		};
		class shared
		{
			displayName = "Global";
			tooltip = "If checked the inventory's shop will broadcast its changes over the network and make it the same for everyone.";
			property = "VASS_shared";
			control = "Checkbox";
			expression = "_this setVariable ['TER_VASS_shared', _value];";
			defaultValue = "true";
		};
	};
};
