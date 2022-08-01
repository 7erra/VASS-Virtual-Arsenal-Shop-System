:: CONFIG
@echo off
set a3_exe="D:\SteamLibrary\steamapps\common\Arma 3\arma3_x64.exe"

:: NO EDITING BELOW HERE
:: Go up one directory relative to this file
FOR %%A IN ("%~dp0.") DO SET vass_dir=%%~dpA
:: Remove trailing backslash
:: https://stackoverflow.com/questions/2952401/remove-trailing-slash-from-batch-file-input
SET vass_dir=%vass_dir:~0,-1%
SET tools_dir=%vass_dir%\tools
SET user=VASS-%1
:: Write as macro to file
echo #define VASS_DIR %vass_dir% > "%tools_dir%\dir.hpp"
:: Start the game
echo testing: %1
IF (%1=="") ECHO yes
:: start "Arma 3 (%1)" %a3_exe% -par="%vass_dir%\tools\%1.params" -debug -profiles=%tools_dir%\logs\%user% -name=%user%
