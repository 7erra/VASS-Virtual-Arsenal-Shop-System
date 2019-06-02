VARIABLES (xNamespace):
	TER_VASS_shopObject [OBJECT] (x = mission/ui)
		Available while the shop is open, returns the currently used object to which the action is added. It contains the TER_VASS_cargo array.
	TER_VASS_cargo [ARRAY of numbers and strings] (object variable)
		An array in format ["class0", price0, amount0, ..., "classN", priceN, amountN]. The function TER_fnc_addShopCargo uses this array to add the classnames to the arsenal while VASS uses it to determine the price and quantities of the item. All classnames must be lowercase.
	TER_VASS_cargo_default [same as TER_VASS_cargo]
		A copy of the cargo array after it was set for the first time.
	TER_VASS_changedItems [ARRAY of arrays of a string and a number] (x = ui)
		Keeps track of the changes to the loadout. Format: [["class0", change0], ..., ["classN", changeN]]. Change is positive for added items and negative for removed ones. Classnames are lowercase. Created upon entering shop and deleted after leaving it.
	TER_VASS_actionID [NUMBER] (object variable)
		The action ID of the addaction added from the call of "addShop" with the TER_fnc_shop function
		
FUNCTIONS:
	TER_fnc_shop
		Internal function which handles most of VASS.
	
	TER_fnc_addShopCargo
		Description:
			Change the inventory of a shop.
		Parameter(s):
			0: OBJECT - The shop object whose inventory will be changed.
			1: ARRAY - List of items, prices and amounts to add
				Format: ["class0", price, amount, "class1", price, amount,..., "classN", price, amount]
				Price and amount are optional. In this case they will default to 0 (free) and -1 (unlimited).
			2: NUMBER - Overwrite mode:
				0 - Don't overwrite, only add new things
				1 - Overwrite soft, only adjust prices and add new things
				2 - Hard overwrite, the passed array becomes the new inventory
				3 - Overwrite old, don't add new entries, only modify old ones
		Returns:
			ARRAY - New inventory
	
	TER_fnc_getItemValues
		Description:
			Function searches the cargo array of an object for the specified item class name and returns it's values as they are used in the shop.
		Parameter(s):
			0: OBJECT - Shop object
			1: STRING - Class name of the requested item
			2: (optional) NUMBER - Type of return: class (0), price (1), amount (2) or array of those (-1)
				Default: -1, returns all values
			3: (optional) ARRAY - Returned array when item is not part of the shop
				Default: [param 1, 0, -1]
		Returns:
			ARRAY - ["class", price, amount]

	TER_fnc_VASSHandler
		Description:
			VASS calls this function when certain events happen. Add your own code to change behaviour. List of sub functions:
				- getMoney: VASS needs to know the money of a unit.
				- setMoney: VASS changes the money of a unit.
		Parameter(s):
			0: STRING - Mode in which the functions is called
			1: ARRAY - Passed arguments
		Returns:
			See sub functions
			
	TER_fnc_addShop
		Description:
			Add shop action to an object. Any previous actions of this type are removed. VASS is only activated when the arsenal is opened via this function.
		Parameter(s):
			0: OBJECT - Object to which the action is added.
			(optional) 1: STRING - Title of the action
				default: "Shop"
			(optional) 2: NUMBER - Priority of the action, see BIKI: addAction
				default: 1.5
			(optional) 3: STRING - Condition which has to be fullfilled for shop to be accessible, see BIKI: addAction
				default: "alive _this && alive _target"
			(optional) 4: NUMBER - Distance from which the action is activatable
				default: 5
		Returns:
			NUMBER - ID of the action, alos saved as "TER_VASS_actionID" on the object.
	
	TER_fnc_resetTimer
		Description:
			Function to change the items of a shop after a certain amount of time.
		Parameter(s):
			0: OBJECT - Shop object.
			1: ARRAY or TRUE - List of items to readd/remove OR true to reset the inventory to default.
			(optional) 2: NUMBER - Time until reset. Negative values will use the "TER_VASS_refresh" variable from the object.
				default: -1
			(optional) 3: BOOL - Passed items will become the only ones after reset. If items is true then it is automatically set to reset.
				default: false
		Returns:
			Bool - True when done