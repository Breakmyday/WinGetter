function WinGetter {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$SearchString
    )
    
    class Software {
        [string]$Name
        [string]$Id
        [string]$Version
        [string]$Match
        [string]$Source
    }
    
    $SearchResults = winget.exe search $SearchString
    if ($SearchResults -contains "No package found matching input criteria.") {
        return
    }
    
    $lines         = $SearchResults.Split([Environment]::NewLine)
    $headerLine = $lines | Where-Object { $_.StartsWith("Name") }
    $regex      = '[^\u0000-\u007F]+'
    $list       = $lines | Where-Object { $_ -notmatch $regex }
    
    $idStart      = $headerLine.IndexOf("Id")
    $versionStart = $headerLine.IndexOf("Version")
    $matchStart   = $headerLine.IndexOf("Match")
    $sourceStart  = $headerLine.IndexOf("Source")

    $wingetList = $list | ForEach-Object {
        if ($_.Length -gt 1 -and -not $_.StartsWith('-')) {
            if ($idStart -lt $_.Length -and $versionStart -lt $_.Length -and $matchStart -lt $_.Length -and $sourceStart -lt $_.Length) {
                $name    = $_.Substring(0, $idStart).Trim()
                $id      = $_.Substring($idStart, $versionStart - $idStart).Trim()
                $version = $_.Substring($versionStart, $matchStart - $versionStart).Trim()
                $match   = $_.Substring($matchStart, $sourceStart - $matchStart).Trim()
                $source  = $_.Substring($sourceStart).Trim()
    
                $software         = [Software]::new()
                $software.Name    = $name
                $software.Id      = $id
                $software.Version = $version
                $software.Match   = $match
                $software.Source  = $source
                $software
            }
        }
    }

    $winSelection = $wingetList | Sort-Object @{Expression = "Source"; Descending = $true },
    @{Expression = "Name"; Descending = $false } | Out-GridView -PassThru

    if ($winSelection) {
        $winSelection | ForEach-Object {
            winget.exe install --Id $_.Id --Source $_.Source
        }
    }
}