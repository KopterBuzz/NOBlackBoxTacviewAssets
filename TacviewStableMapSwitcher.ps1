param(
    [string]
    $target
)

$targetPaths = @{
    "terrain" = $env:ProgramData + "\Tacview\Data\Terrain\Custom\"
    "textures" = $env:ProgramData + "\Tacview\Data\Terrain\Textures\"
}

$terrainXmlList = Get-ChildItem .\terrainxml_stable\*.xml
$textureXmlList = Get-ChildItem .\texturesxml_stable\*.xml

$terrainTargets = @{}
$textureTargets = @{}

foreach ($item in $terrainXmlList)
{
    [xml]$xml = Get-Content $item.fullname

    if($xml.Resources.CustomHeightmapList.CustomHeightmap.Id) {

        $terrainTargets[$xml.Resources.CustomHeightmapList.CustomHeightmap.Id] = $item
    }
    
}

foreach ($item in $textureXmlList)
{
    [xml]$xml = Get-Content $item.fullname

    if($xml.Resources.CustomTextureList.CustomTexture.Id) {

        $textureTargets[$xml.Resources.CustomTextureList.CustomTexture.Id] = $item
    }
    
}

if (!$target)
{
    Write-Host The Following Terrains are available:
    $terrainTargets.Keys
    Write-Host "Re-Run this tool with -target "Target Terrain ID" to switch the default Tacview Terrain!"
    Write-Host 'Example: .\TacviewStableMapSwitcher.ps1 -target "NuclearOption.Terrain1"'
} 

if ($null -eq $terrainTargets[$target]) {
    Write-Error "Invalid Target Terrain ID!!"
    Write-Host "Re-Run this tool with Valid -target "Target Terrain ID" to switch the default Tacview Terrain!"
    Write-Host 'Example: .\TacviewStableMapSwitcher.ps1 -target "NuclearOption.Terrain1"'
    Write-Host The Following Terrains are available:
    $terrainTargets.Keys
}

if ($terrainTargets[$target])
{
    Copy-Item -Path $terrainTargets[$target].fullname -Destination ($targetPaths["terrain"] + "\CustomHeightmapList.xml") -Force
    if ($textureTargets[$target])
    {
        Copy-Item -Path $textureTargets[$target].fullname -Destination ($targetPaths["textures"] + "\CustomTextureList.xml") -Force
    }
}