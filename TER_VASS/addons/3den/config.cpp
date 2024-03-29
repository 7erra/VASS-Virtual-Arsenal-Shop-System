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

#include "CfgScriptPaths.hpp"
#include "ui\BaseControls.hpp"
#include "ui\Display3DENVASS.hpp"
#include "Cfg3den.hpp"
