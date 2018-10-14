## System  
This script turns the Arsenal into a shop where each item costs money. The whole system is customizable to a certain extent. See Setup for more information.  
  
## Setup  
1. Add the following lines to your description.ext:  
`class CfgFunctions`  
`{`  
`	#include "arsenalShop\cfgFunctions.hpp"`  
`};`  
2. Move the arsenalShop folder to your mission folder  
3. Modify the config.sqf to your likeing  
4. To add an arsenal to an object add the following line to the init:  
`[this] call TER_fnc_addArsenal`  
  
The system is automatically initialzed on mission start and applies to __all__ opened arsenals
## Functions  
There are some functions which the system uses. The most useful ones are documented in the files of the fnc folder.  
Currently available functions:  
* TER_fnc_addArsenal  
* TER_fnc_itemCostFromTable  
* TER_fnc_arrayChange
* TER_fnc_compareLoadout
