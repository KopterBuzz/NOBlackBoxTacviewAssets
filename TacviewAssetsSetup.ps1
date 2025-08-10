param(
    [Parameter(Mandatory)]
    [ValidateSet("Stable","Beta")]
    [string]
    $target
)
$customPaths = @{
    "Stable" = @{
        "terrain" = $env:ProgramData + "\Tacview\Data\Terrain\Custom\"
        "textures" = $env:ProgramData + "\Tacview\Data\Terrain\Textures\"
    }
    "Beta" = @{
        "terrain" = $env:ProgramData + "\Tacview\Data\Terrain\Custom\Nuclear Option\"
        "textures" = $env:ProgramData + "\Tacview\Data\Terrain\Textures\Nuclear Option\"
    }
}
$targetPaths = @{
    "database" = $env:ProgramData + "\Tacview\Data\Database\Default Properties\"
    "meshes" = $env:ProgramData + "\Tacview\Data\Meshes\"
    "terrain" = $customPaths[$target]["terrain"]
    "textures" = $customPaths[$target]["textures"] 
}

if (!(test-path ($env:ProgramData + "\Tacview"))) 
{
    Write-Error "Tacview not installed or not initialized! Please Install Tacview and run at least once to let it initialize ProgramData directory structure!"
    Exit 1
}

foreach ($path in $targetPaths.Values)
{
    if (!(test-path $path)) {
        new-item $path -ItemType Directory -Force
    }
}

Write-Host installing Database XML to $targetPaths["database"] ...
Get-ChildItem ".\database\*.xml" | select -ExpandProperty fullname | foreach {$_;Copy-Item $_ $targetPaths["database"] -Force}
Write-Host installing Meshes to $targetPaths["meshes"] ...
Get-ChildItem ".\meshes\*.obj" | select -ExpandProperty fullname | foreach {$_;Copy-Item $_ $targetPaths["meshes"] -Force}
Write-Host installing Terrain to $targetPaths["terrain"]
Get-ChildItem ".\terrain\*.xml" | select -ExpandProperty fullname | foreach {$_;Copy-Item $_ $targetPaths["terrain"] -Force}
Get-ChildItem ".\terrain\*.raw" | select -ExpandProperty fullname | foreach {$_;Copy-Item $_ $targetPaths["terrain"] -Force}
Write-Host installing Textures to $targetPaths["textures"]
Get-ChildItem ".\textures\*.xml" | select -ExpandProperty fullname | foreach {$_;Copy-Item $_ $targetPaths["textures"] -Force}
Get-ChildItem ".\textures\*.png" | select -ExpandProperty fullname | foreach {$_;Copy-Item $_ $targetPaths["textures"] -Force}