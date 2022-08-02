$tools_dir = Get-Item $PSScriptRoot # Path to this file
$vass_dir = Get-Item $tools_dir.PSParentPath # VASS root is one directory above the tools directory
Set-Location -Path $vass_dir\TER_VASS
hemtt.exe build