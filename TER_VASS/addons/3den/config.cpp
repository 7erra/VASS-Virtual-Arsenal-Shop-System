#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(COMPONENT);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"3den", "A3_Ui_F"};
        author = "Terra";
        VERSION_CONFIG;
    };
};

#include "\a3\3DEN\UI\macros.inc"
#include "CfgScriptPaths.hpp"
#include "CfgFunctions.hpp"
#include "Cfg3den.hpp"
