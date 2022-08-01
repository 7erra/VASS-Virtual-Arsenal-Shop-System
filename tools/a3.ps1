param(
    [string]$mode="host"
)

# CONFIG START
$a3_version = "arma3_x64"
$a3_exe = Get-Item "D:\SteamLibrary\steamapps\common\Arma 3\$a3_version.exe"
# CONFIG END

# Set some variables
$tools_dir = Get-Item $PSScriptRoot # Path to this file
$vass_dir = Get-Item $tools_dir.PSParentPath # VASS root is one directory above the tools directory
$user = "VASS-$mode"
$par_file = "$tools_dir\$mode.params"
$args = "-debug", "-par=$par_file"
# Write the directory of VASS into a file as a define to later be used in the parameter files
$dir_file = "$tools_dir\logs\dir.hpp"
if (-Not (Test-Path $dir_file)) {
    "#define VASS_DIR $vass_dir" | Out-File -FilePath $dir_file -Encoding utf8
}
if ($mode -eq "host") {
    # Check and kill the last Arma 3 instance
    $old_a3_instance = Get-Process arma3_x64 -ErrorAction SilentlyContinue
    if ($old_a3_instance) {
        $old_a3_instance.CloseMainWindow() # Ask friendly
        Sleep 5 # Wait
        if ($old_a3_instance.HasExited) {
            $old_a3_instance | Stop-Process -Force # Kill
        }
    }
} else {
    # client
    $args += "-profiles=$tools_dir\logs\$user", "-name=$user"
}
Write-Output "Starting Arma 3 with the following parameters:", $args, (Get-Content -Path $par_file)
Start-Process $a3_exe -ArgumentList $args