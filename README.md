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

////// COPY FROM FORUMS ////////

Virtual Arsenal Shop System

by 7erra





https://github.com/7erra/Arsenal-Shop

http://www.armaholic.com/page.php?id=34506



Information

This script turns the Arsenal into a shop where each defined item costs money. The whole system is customizable to a certain extent. Open the config.sqf for more information.



Setup

Add the following lines to your description.ext:
class CfgFunctions
{
	#include "arsenalShop\cfgFunctions.hpp"
};


Move the arsenalShop folder to your mission folder
Modify the config.sqf to your likeing
Add an arsenal via [this] call TER_fnc_addArsenal in the init line of the object


Functions

There are some functions which the system uses. The most useful ones are documented in their respective files (arsenalShop\fnc\fn_X.sqf) and the functions viewer.
Currently available functions:

TER_fnc_addArsenal
TER_fnc_itemCostFromTable
TER_fnc_compareLoadout
TER_fnc_arrayChange

Download

https://github.com/7erra/Arsenal-Shop



Changelog

Spoiler
v1.4 - cfgFunctions (14.10.2018)

! IMPORTANT ! The setup of the system has changed. Please refer to the readme.

+ TER_fnc_addArsenal can now be called from the init of an object

+ Credit link when ui is hidden

+ Functions library

~ Backpack names are now displayed correctly in the purchase detail listbox

~ Buy button moved to the purchase detail listbox

~ You no longer can buy undefined items or shop unrelated items

~ Color of the price is now green
~ File structure with better overview



v1.3 - Safety and UI (10.10.2018)

+ New functions:

   + TER_fnc_compareLoadout

   + TER_fnc_arrayChange

+ Purchase details

~ All functions and the cost array are now unchangeable during mission

~ The controls bar will now stay hidden

- Seperate control for displaying the cost of an item it is now displayed on the listbox instead



v1.2 - Better Refunding (07.10.2018)

+ Refunding of items in containers (uniform, vest, backpack)

~ Selecting a new weapon won't add 4 free magazines, neither does removing a weapon delete the compatible mags



v1.1 - Refunding (06.10.2018) 

+ Refunding

~ more versatile TER_fnc_addArsenal (see config.sqf)



v1 - Release (05.10.2018)

You can make suggestions and report bugs here in the forums or open an issue on GitHub here. There you can also find all planned features.



Have fun,

7erra
