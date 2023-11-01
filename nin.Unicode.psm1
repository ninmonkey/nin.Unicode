using namespace System.Collections.Generic

# [Collections.Generic.List[Object]]$script:Bv_LastBinArgs = @()

[hashtable]$global:nUni_AppConfig = @{
    # BinRClone = gi 'G:/2023-git/git_bin/rclone-v1.64.2-windows-amd64/rclone.exe'
}
# [string]$script:Bv_BinInvokeHistory = ''
# h:\data\client_bdg\2023.10-bdg s3 files sync proto
function nUni.SpecsFile.ParseHeader {
# function nUni.SpecsFile.GetHeader {
    param(
        [string]$Path
    )

    $info = @{}
    return $info
}
function nUni.Write-DimText {
    <#
    .SYNOPSIS
        # sugar for dim gray text,
    .EXAMPLE
        # pipes to 'less', nothing to console on close
        get-date | Dotils.Write-DimText | less

        # nothing pipes to 'less', text to console
        get-date | Dotils.Write-DimText -PSHost | less
    .EXAMPLE
        > gci -Name | Dotils.Write-DimText |  Join.UL
        > 'a'..'e' | Dotils.Write-DimText  |  Join.UL
    #>
    [OutputType('String')]
    [Alias('nUni.DimText')]
    param(
        # write host explicitly
        [switch]$PSHost
    )
    $Ratio60 = 256 * .6 -as 'int'
    $Ratio20 = 256 * .2 -as 'int'

    $Fg = @{
        Gray60 = $PSStyle.Foreground.FromRgb( $Ratio60, $Ratio60, $Ratio60 )
        Gray20 = $PSStyle.Foreground.FromRgb( $Ratio20, $Ratio20, $Ratio20 )
    }
    $Bg = @{
        Gray60 = $PSStyle.Background.FromRgb( $Ratio60, $Ratio60, $Ratio60 )
        Gray20 = $PSStyle.Background.FromRgb( $Ratio20, $Ratio20, $Ratio20 )
    }

    $ColorDefault = @{
        ForegroundColor = 'gray60'
        BackgroundColor = 'gray20'
    }
    [string]$render =
        $Input
            | Join-String -op $(
                $Fg.Gray60,
                $Bg.Gray20 -join '') -os $( $PSStyle.Reset )

    return $render | Write-Information -infa 'Continue'


    # if($PSHost) {

    #         # | Pansies\write-host @colorDefault
    # }

    # return $Input
    #     | New-Text @colorDefault
    #     | % ToString
}

function nUni.ResolveItem {
    <#
    .SYNOPSIS
        return paths, otherwise return the original string
    #>
    [OutputType('System.IO.FileSystemInfo', 'String')]
    [CmdletBinding()]
    param(
        # Pass path as FileInfo or strings
        [Alias('InputObject', 'PSPath')]
        [Parameter(Mandatory, Position=0)]
        [string]$Path
    )
    if( -not (Test-Path $Path)) {
        write-verbose "Path does not exist yet, falling back to string: $Path"
        return $Path
    }
    return Get-Item -ea 'stop' $Path # shouldn't error
}

function nUni.Init.AddPaths {
    <#
    .SYNOPSIS
        create an return initial path config
    #>
    [OutputType('Hashtable')]
    param()
    $Config = @{
        UCD_Root = nUni.ResolveItem 'H:/datasource/unicode.specs/extract/UCD'
    }

    return $Config
}

