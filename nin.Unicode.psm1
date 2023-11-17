using namespace System.Collections.Generic

# [Collections.Generic.List[Object]]$script:Bv_LastBinArgs = @()

[hashtable]$global:nUni_AppConfig = @{
    # BinRClone = gi 'G:/2023-git/git_bin/rclone-v1.64.2-windows-amd64/rclone.exe'
}
# [string]$script:Bv_BinInvokeHistory = ''
# h:\data\client_bdg\2023.10-bdg s3 files sync proto
function Assert.NotTrueNull {
    <#
    .EXAMPLE
        Assert.NotTrueNull ''
    .EXAMPLE
        Assert.NotTrueNull $foo 'Should never occur unless X'
    #>
    param(
        $InputObject,
        [string]$Reason = ''
    )
    if($null -eq $InputObject ) {
        throw "Assert.NotTrueNull failed: $Reason !"
    }
}
function nUni.SpecsFile.ParseHeader {
# function nUni.SpecsFile.GetHeader {
    param(
        [string]$Path
    )
    # throw NotImplemented exception
    throw 'NotImplementedException'

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
function nUni.New-Rune {
    [CmdletBinding(DefaultParameterSetName = 'FromInt')]
    [Alias(
        'nUni.New-Char',
        'uni.New-Rune'
    )]
    [OutputType('Text.Rune', 'String')]
    param(
        [Alias('FromInt', 'FromNumber', 'Number')]
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'FromInt')]
        $Codepoint,

        [Alias('Name', 'Query')]
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'FromQuery')]
        $FromName,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'FromSurrogateChars')]
        # [object] not char, I might accept fancy strings, coercing numbers
        $HighSurrogate,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory, Position = 1, ParameterSetName = 'FromSurrogateChars')]
        # [object]not char, I might accept fancy strings, coercing numbers
        $LowSurrogate,

        # rather than a Rune
        [switch]$AsString,
        [switch]$AsPwshLiteral
    )
    if($PSBoundParameters.ContainsKey('Codepoint')) {
        $rune = [Text.Rune]::new( $Codepoint )
        # or for PS5 support, [Char]::ConvertFromUtf32( $Codepoint )
        # I'm going pure Pwsh7 for this module, so that text can be fully used.
    }
    switch ($PSCmdlet.ParameterSetName) {
        'FromInt' {
            $rune = [Text.Rune]::new( $Codepoint )
            break
        }
        'FromSurrogateChars' {
            [Text.Rune]::new(
                <# highSurrogate: #> [char]$highSurrogate,
                <# lowSurrogate: #> [char]$lowSurrogate)
            break
        }

        default {
            throw "Unhandled ParameterSet: $($PSCmdlet.ParameterSetName)"
        }
    }

    if( $AsString ) {
        return $Rune.ToString()
    }
    IF( $AsPwshLiteral ) {
        '`u{'
        
        '}'

    }



        return $Rune

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
function nUni.Find.UnicodeVersionNumbers {
    # if( -not ())
    # $GetAllVersionNumbersUrl = 'https://www.unicode.org/Public/'
    # $response ??= iwr $GetAllVersionNumbersUrl
    # $tables = PSParseHtml\ConvertFrom-HtmlTable -Content $response.Content
    # $tables.Name -match '^\d+\.\d+\.\d+/'
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

    $Urls = @{
        'DownloadLatestDB' = 'https://www.unicode.org/Public/UCD/latest/'
        'ByVersion' = @{
            'v15.0' = 'https://www.unicode.org/Public/15.0.0/'
            'v15.1' = 'https://www.unicode.org/Public/15.1.0/'
        }

    }

    return $Config
}

function nUni.BuildWebQuery {
    param(

    )

    [List[Object]]$QueryMetada = @()

    $Query.Metadata.Add(
        [pscustomobject]@{
            'ShortName' = 'Block'
            'Description' = 'View an entire unicode block'
            'ExampleFullUrl' = 'https://www.compart.com/en/unicode/block/U+0000'
            'Template' = @{
                Format = 'https://www.compart.com/en/unicode/block/U+{{}}'
            }
        }
    )
}