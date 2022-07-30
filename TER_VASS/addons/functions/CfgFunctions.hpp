/*
	Header: CfgFunctions.hpp

	Description:
		https://community.bistudio.com/wiki/Arma_3:_Functions_Library

	Authors:
		Terra

	Includes:
		None

	Included by:
		- functions\config.cpp
*/
class CfgFunctions
{
	class TER_VASS
	{
		class Configs
		{
			file = QPATHTOF(Configs);
			class itemConfig;
		};
		class Items
		{
			file = QPATHTOF(Items);
			class compatibleWeapons;
		};
		class Strings
		{
			file = QPATHTOF(Strings);
			class validNumber;
		};
	};
};
