class CfgPatches
{
	class TER_VASS
	{
		author="Terra";
		name="Virtual Arsenal Shop System - 3den Editing";
		url="";
		requiredAddons[]={3den, A3_Ui_F};
		requiredVersion=0.1;
		units[]={};
		weapons[]={};
	};
};
class CfgFunctions
{
	class TER
	{
		class VASS
		{
			class vasscargo {file = "VASS_3den\gui\scripts\fn_vasscargo.sqf";};
		};
	};
};
#include "Cfg3den.hpp"