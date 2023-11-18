using namespace System.Collections.Generic
using namespace System.Collections
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

$script:moduleConfig = @{
    hardPath = Join-Path 'g:\temp' -ChildPath '2023_11_13' 'nin.Unicode.log'
    SuperVerbose = $true
}
# New-Item -ItemType File -Path (Join-Path 'g:\temp' -ChildPath '2023_11_13' 'ArgumentCompleter.log') -Force
if( -not (Test-Path $moduleConfig.hardPath) ) {
    New-Item -ItemType File -Path $moduleConfig.hardPath -Force
}
$ModuleConfig.hardPath | Join-String -f 'Using Log: {0}' | write-host -BackgroundColor 'darkred'
$script:moduleConfig.SuperVerbose | Join-String -f 'using $ModuleConfig.SuperVerbose = {0}' | write-host -back 'darkred'

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
    [Alias(
        'nUni.DimText',
        'uni.Dim'
    )]
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

class InspectRuneResult {
    [string]$Hex = ''
    [string]$Text = ''
    hidden [string]$RawText = ''
    [int]$Codepoint = 0x0

    InspectRuneResult( [Text.Rune]$Rune ) {
        if($null -eq $Rune) {
            throw "NullParameter: Rune"
        }
        # Initialize the object
        $this.Hex       =
            Join-String -f '0x{0:x}' -in $Rune.Value
        $this.Text      = $Rune.ToString() | fcc
        $this.RawText   = $Rune.ToString()
        $this.Codepoint = $Rune.Value
    }
}
function nUni.InspectRune {
    <#
    .EXAMPLE
        'asdf' | nUni.InspectRune
        Get-Date | nUni.InspectRune
    #>
    [Alias(
        'Inspect.Rune'
    )]
    param(
        [AllowNull()]
        [AllowEmptyString()]
        [Parameter(Mandatory, ValueFromPipeline)]
        [Alias(
            'Text', 'String', 'Rune'
        )]
        $InputObject
    )
    process {
        if($Null -eq $InputObject) {
            return
        }
        [bool]$typeIsOk = $InputObject -is 'string' -or
            $InputObject -is 'char' -or
            $InputObject -is 'Text.Rune'
            $typeIsOk = $true

        if(-not $typeIsOk) { return }
        $Target = ($InputObject)?.ToString() ?? '␀'
        $Target.EnumerateRunes() | %{
            $Rune = $_
            [InspectRuneResult]::new( $Rune )
        }

    }
}
function nUni.New-Rune {
    [CmdletBinding(DefaultParameterSetName = 'FromInt')]
    [Alias(
        'Rune',
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
            $rune = [Text.Rune]::new(
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
    if( $AsPwshLiteral ) {
        return @(
            '"`u{'
            $Rune.Value.ToString('x')
            '}"'
        ) -join ''
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

class NamedRuneRecord {
    [string]$Text = ''
    [string[]]$Names = @()
    [string]$ShortName # future: convert to a ScriptProperty
    hidden [string]$Name # alias of ShortName
    [string]$Description = ''

    NamedRuneRecord( [hashtable]$Options ) {
        $This.Text = ($Options)?.Text
        $This.Names = ($Options)?.Names ?? @()
        $This.Description = ($Options)?.Description ?? '<no description>'
        $This.ShortName =
            ($Options)?.ShortName ??
            ($Options)?.Name ??
            @( $this.Names )[0]

        if( $null -eq $This.Text ) {
            throw $(
                "This.Text was null! Options = {0}" -f  @(  $Options |ConvertTo-Json -depth 2 ) )
        }
        $This.Name = $This.ShortName
    }
    [CompletionResult] AsCompletionResult () {
        [string]$render = @(
            $This.ShortName
            "`n"
            $This.Names | Join-String -sep ', ' -op 'Aliases: '
            "`n`n"
            $THis.Description
        ) -join ''
        $ce = [CompletionResult]::new(
            <# completionText: #> $this.Text,
            <# listItemText  : #> $this.ShortName,
            <# resultType    : #> ([CompletionResultType]::ParameterValue),
            <# toolTip       : #> $render )
        return $ce
    }
    [String] ToString() {
        return '[NameText< Name: {0}, Aliases: {1} Codepoint: {2}>]' -f @(
            $This.ShortName
            $This.Names | Join-String -sep ' ' -SingleQuote -op ' [ ' -os ' ] '
            $This.AsHexList()
            # $This.Text.EnumerateRunes() | Join-String -sep ' ' -f '{0:x}' -sep
            # $This.Text.EnumerateRunes() |  Join-String -sep ' ' -f '{0:x}' Value -op '[ ' -os ' ]'
        )
    }
    [string] AsHexList () {
        return ($This.Text)?.EnumerateRunes() |  Join-String -sep ' ' -f '{0:x}' Value -op '[ ' -os ' ]'
    }
}

function nUni.__SearchNamedMetadata {
    <#
    .EXAMPLE
    Pwsh> nUni.__GetNamedUniMetadata | Join-String -sep "`n"

        [NameText< Name: Null, Aliases:  [ 'Null' ]  Codepoint: [ 0 ]>]
        [NameText< Name: SOH, Aliases:  [ 'SOH' 'StartOf.Heading' ]  Codepoint: [ 1 ]>]
        [NameText< Name: STX, Aliases:  [ 'STX' 'StartOf.Text' ]  Codepoint: [ 2 ]>]
    #>
    [CmdletBinding()]
    param(
        [Alias('Query', 'Text', 'String')]
        [Parameter()]
        [string]$InputText
    )

    $all = nUni.__GetNamedUniMetadata
    $found = $all | ?{
        @( $_.Names ) -contains $InputText
    }
    if($found.count -gt 0) {
        return $found
    }
    $found = $all | ?{
        @( $_.Names ) -match $InputText
    }
    if($found.count -gt 0) {
        return $found
    }

    'No matches found for: {0}' -f $InputText | Write-Verbose
    return $found
}

function nUni.__GetNamedUniMetadata {
    <#
    .EXAMPLE
        nUni.__GetNamedUniMetadata | ft -auto
    .EXAMPLE
        nUni.__GetNamedUniMetadata -KeysOnly | ft -auto
    .LINK
        https://en.wikipedia.org/wiki/C0_and_C1_control_codes#STX
    #>
    param(
        # Return keys only
        [switch]$KeysOnly,
        [Alias('Completions', 'As.Completion')]
        [switch]$AsCompletionResult
    )
    [List[Object]]$Items = @()

    $Items.AddRange(@(
        [NamedRuneRecord]@{
            Text = Rune 0x0
            Names = 'Null'
        }
        [NamedRuneRecord]@{
            Text = Rune 0x1
            Names = 'SOH', 'StartOf.Heading'
            Description = 'In message transmission, delimits the start of a message header. The format of this header may be defined by an applicable protocol, such as IPTC 7901 for journalistic text transmission, and it is usually terminated by STX.[2] In Hadoop and FIX, it is often used as a field separator.'
        }
        [NamedRuneRecord]@{
            Text = Rune 0x2
            Names = 'STX', 'StartOf.Text'
            Description = 'First character of message text, and may be used to terminate the message heading.'
        }
    ))
    if( $KeysOnly ) {
        return $Items.Names | Sort-object -unique
    }
    return $Items
}

function WriteJsonLog {
    param(
        # [ALias('.Log')]
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]]$InputObject,

        [Alias('Line', 'Message')]
        [string]$Text,

        [switch]$PassThru
    )
    begin {
        [List[Object]]$Items = @()
    }
    process {
        $Items.AddRange(@(
            $InputObject ))
    }
    end {
        if( -not $script:moduleConfig.SuperVerbose) {
            return
        }
        $Now = [Datetime]::Now
        $Data =
            $items | ConvertTo-Json -Depth 2

        # $logLine =
            # Join-String -inp @( $Data )  -op 'JSON:{ ' -os ' }:JSON'
            #     | Join-String -op "[$Now] " -sep ' '
        $logLine =
            $Data
                | Join-String -op 'JSON:{ ' -os ' }:JSON'
                | Join-String -op "${Text} "
                | Join-String -op "[$Now] " -sep ' '

        Add-Content -Path $moduleConfig.hardPath -Value $logLine -PassThru:$PassThru
    }
}


class NamedUnicodeCompleter : IArgumentCompleter {

    # hidden [hashtable]$Options = @{}
    # [bool]$ExcludeDateTimeFormatInfoPatterns = $false
    # [bool]$IncludeFromDateTimeFormatInfo = $true
    # NamedUnicodeCompleter([int] $from, [int] $to, [int] $step) {
    NamedUnicodeCompleter( ) {
        $This.Options = @{
            # ExcludeDateTimeFormatInfoPatterns = $true
        }

        $this.Options
            | WriteJsonLog -Text '🚀 [NamedUnicodeCompleter]::ctor'
    }
    # NamedUnicodeCompleter( $options ) {
    NamedUnicodeCompleter( $ExcludeDateTimeFormatInfoPatterns = $false ) {
        $this.ExcludeDateTimeFormatInfoPatterns = $ExcludeDateTimeFormatInfoPatterns
        $This.Options.ExcludeDateTimeFormatInfoPatterns = $ExcludeDateTimeFormatInfoPatterns

        $this.Options
            | WriteJsonLog -Text '🚀 [NamedUnicodeCompleter]::ctor'

        $PSCommandPath | Join-String -op 'not finished: Exclude property is not implemented yet,  ' | write-warning

        # $this.Options = $Options ?? @{}
        # $Options
            # | WriteJsonLog -Text '🚀 [NamedUnicodeCompleter]::ctor'
        # if ($from -gt $to) {
        #     throw [ArgumentOutOfRangeException]::new("from")
        # }
        # $this.From = $from
        # $this.To = $to
        # $this.Step = $step -lt 1 ? 1 : $step

    }
    <#
    .example

    > try.Named.Fstr yyyy'-'MM'-'dd'T'HH':'mm':'ssZ
    GitHub.DateTimeOffset  ShortDate (Default)    LongDate (Default)

        Git Dto ⁞ 2023-11-11T18:58:42Z
        yyyy'-'MM'-'dd'T'HH':'mm':'ssZ
        Github DateTimeZone
        Github DateTimeOffset UTC
    #>

    [IEnumerable[CompletionResult]] CompleteArgument(
        [string] $CommandName,
        [string] $parameterName,
        [string] $wordToComplete,
        [CommandAst] $commandAst,
        [IDictionary] $fakeBoundParameters) {

        [List[CompletionResult]]$resultList = @()
        # $DtNow = [datetime]::Now
        # $DtoNow = [DateTimeOffset]::Now
        # [bool]$NeverFilterResults = $false
        $Config = @{
            # IncludeAllDateTimePatterns = $true
            # IncludeFromDateTimeFormatInfo = $true
        }



        # [Globalization.DateTimeFormatInfo]$DtFmtInfo = (Get-Culture).DateTimeFormat


        # if($script:moduleConfig.SuperVerbose) {
        #         '.'
        #         | WriteJsonLog -t 'NamedUnicodeCompleter::CompleteArgument'
        # }


        # if( $This.IncludeFromDateTimeFormatInfo) {
        #     $DtFmtInfo | Find-Member -MemberType Property *Pattern* | % Name | %{
        #         $curMemberName = $_
        #         $PatternName = $curMemberName -replace 'Pattern$', ''
        #         $curFStr = $DtFmtInfo.$PatternName
        #         $tlate = [NamedRuneRecord]@{
        #             # CompletionName = $PatternName
        #             # Delim = ' ⁞ '
        #             # Fstr = $curFStr
        #             # ShortName = $patternName
        #             # BasicName = ''
        #             # Description = @(
        #             #     'Culture.DateTimeFormatInfo.{0}' -f $curMemberName
        #             # ) -join "`n"
        #         }
        #         $resultList.Add( $tlate.AsCompletionResult() )

        #         $tlate | WriteJsonLog -Text 'NamedUnicodeCompleter::CompleteArgument 🐒'
        #     }
        # }

        #   # $DtFmtInfo.GetAllDateTimePatterns()
        # if( -not $This.ExcludeDateTimeFormatInfoPatterns ) {
        #     foreach($fstr in $DtFmtInfo.GetAllDateTimePatterns()) {
        #         $tlate = [NamedRuneRecord]@{
        #             CompletionName = $Fstr
        #             Delim = ' ⁞ '
        #             Fstr = $fstr
        #             ShortName = ''
        #             BasicName = ''
        #             Description = @(
        #                 'From: DtFmtInfo.GetAllDateTimePatterns()'
        #             ) -join "`n"
        #         }
        #         $resultList.Add( $tlate.AsCompletionResult() )
        #     }
        # }










        #     # New-TypeWriterCompletionResult -Text 'LongDate' -listItemText 'LongDate2' -resultType Text -toolTip 'LongDate (default)'
        #     # New-TypeWriterCompletionResult -Text 'ShortDate' -listItemText 'ShortDate2' -resultType Text -toolTip 'ShortDate (default)'
        #     #
        # 'next: filter results?: =  {0}' -f $NeverFilterResults
        #     | out-host


        # if($NeverFilterResults) {
        #     return $resultList
        #  }

        return $ResultList
    }

}


function nUni.GetNamedText {
    <#
    .SYNOPSIS
        saved aliases that map directly to text or a sequence
    .description
        aliass 'Uni.Str' and 'UniStr' automatically add -AsText as a default arg

    #>
    [Alias(
        'nUni.Named',
        'nUni.Query',
        'Uni',
        'Uni.Str',
        'UniStr'
    )]
    [OutputType('string', 'System.Text.Rune')]
    param(
        [ArgumentCompletions(
            'STX', 'StartOf.Text',
            'STX.Symbol', 'StartOf.Text.Symbol',

            'ETX', 'EndOf.Text'
        )]
        [Alias('Name', 'Query')]
        [Parameter(Mandatory, Position = 0)]
        $InputName,

        [Alias('AsString', 'String', 'ToString', 'Str')]
        [switch]$AsText

    )
    if($PSCmdlet.MyInvocation.InvocationName -match 'Uni.*Str') {
        $AsText = $True
    }
    $mapping = @{
        # wait,
        'Null'       = [Text.Rune]::new( 0x0 )
        'Null.Symbol' = [Text.Rune]::new( 0x2400 + 0x0 )

        'STX' = [Text.Rune]::new( 0x2 )
        'STX.Symbol' = [Text.Rune]::new( 0x2400 + 0x2 )

        'ETX' = [Text.Rune]::new( 0x3 )
        'ETX.Symbol' = [Text.Rune]::new( 0x2400 + 0x3 )

        # 'SOH' = [Text.Rune]::new( 0x3 )
        # 'StartOf.Heading.Symbol' = [Text.Rune]::new( 0x2400 + 0x3 )

    }
    $Mapping.'StartOf.Text' = $Mapping.'STX'
    $Mapping.'StartOf.Text.Symbol' = $Mapping.'STX.Symbol'

    $Mapping.'EndOf.Text' = $Mapping.'ETX'
    $Mapping.'EndOf.Text.Symbol' = $Mapping.'ETX.Symbol'

    if(  -not $Mapping.ContainsKey($InputName) ) {
        throw "ExactMatchNotFound: $_"
    }

    $found = $Mapping[ $InputName ]
    if( $AsText ) { return $Found.ToString() }
    return $found
}
function nUni.Find.UnicodeVersionNumbers {
    # if( -not ())
    # $GetAllVersionNumbersUrl = 'https://www.unicode.org/Public/'
    # $response ??= iwr $GetAllVersionNumbersUrl
    # $tables = PSParseHtml\ConvertFrom-HtmlTable -Content $response.Content
    # $tables.Name -match '^\d+\.\d+\.\d+/'
    throw 'parse web response for dynamic listing'
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
    [Alias(
        'Uni.Web',
        'Uni.WebQuery'
    )]
    param(

    )

    [List[Object]]$QueryMetada = @()

    $Query.Metadata.Add(
        [pscustomobject]@{
            PSTypeName = 'nin.uni.UrlTemplate'
            'ShortName' = 'Block'
            'Description' = 'View an entire unicode block'
            'ExampleFullUrl' = 'https://www.compart.com/en/unicode/block/U+0000'
            'Template' = @{
                Format = 'https://www.compart.com/en/unicode/block/U+{{}}'
            }
        }
    )

    return $Query
}
Get-Date | WriteJsonLog -Text 'Module::Initialized'