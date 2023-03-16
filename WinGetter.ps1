function WinGetter {
    [CmdletBinding()]
    param(
        [Parameter()]
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
            
    $lines = $SearchResults.Split([Environment]::NewLine)
        
        
    # Find the line that starts with Name, it contains the header
    $fl = 0
    while (-not $lines[$fl].StartsWith("Name")) {
        $fl++
    }
        
    $regex = '[^\u0000-\u007F]+'
    $list = @()
    # Iterate over the original list and add lines that do not contain non-English characters to the new list
    foreach ($line in $lines) {
        if ($line -notmatch $regex) {
            $list += $line
        }
    }
        
        
    # Line $i has the header, we can find char where we find ID and Version
    $idStart = $list[$fl].IndexOf("Id")
    $versionStart = $list[$fl].IndexOf("Version")
    $matchStart = $list[$fl].IndexOf("Match")
    $sourceStart = $list[$fl].IndexOf("Source")
            
    # Now cycle in real package and split accordingly
    $wingetList = @()
        
    For ($i = $fl + 1; $i -le $list.Length; $i++) {
        $line = $list[$i]
        
        $name = $id = $version = $match = $source = $null
        if ($line.Length -gt 1 -and -not $line.StartsWith('-')) {
                
        
            $name = $line.Substring(0, $idStart).TrimEnd()
            $id = $line.Substring($idStart, $versionStart - $idStart).TrimEnd()
            if ($matchStart -gt 1) {
                $version = $line.Substring($versionStart, $matchStart - $versionStart).TrimEnd()
                $match = $line.Substring($matchStart, $sourceStart - $matchStart).TrimEnd()
            }
            else {
                $version = $line.Substring($versionStart, $sourceStart - $versionStart).TrimEnd()
                $match = ""
            }
            $source = $line.Substring($sourceStart).TrimEnd()
        
            $software = [Software]::new()
            $software.Name = ($name.TrimStart()).TrimEnd()
            $software.Id = ($id.TrimStart()).TrimEnd()
            $software.Version = ($version.TrimStart()).TrimEnd()
            $software.Match = ($match.TrimStart()).TrimEnd()
            $software.Source = ($source.TrimStart()).TrimEnd()
            
            $wingetList += $software
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