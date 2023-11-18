err -Clear
$PSStyle.OutputRendering = 'ansi'
Set-Alias 'Json' -Value 'ConvertTo-Json'
Set-Alias 'Json.from' -Value 'ConvertFrom-Json'
Remove-Module 'nin.uni*', 'nin.unicode*'

# Import-Module -PassThru -Force 'nin.Unicode'
import-module -PassThru -Force -DisableNameChecking 'H:\data\2023\pwsh\PsModules\nin.Unicode\nin.Unicode.psm1' -ea 'stop'
    | Join-String | RenderModuleName

if($Error.count -gt 0){
    'exit early, error' | write-host -back red
    return
}


$PSStyle.OutputRendering = 'ansi'
hr

gcm -m nin.Unicode


$path1 = nUni.ResolveItem 'H:\datasource\unicode.specs\extract\UCD\emoji\emoji-data.txt'

# nUni.SpecsFile.ParseHeader -path $Path1 -ea 'ignore'


hr
nUni.__GetNamedUniMetadata | Ft -auto # private
hr
get-date | nUni.InspectRune|Ft -auto


write-warning @'
todo:
[NamedUnicodeCompletionsAttribute( CompleteAs = 'Name|Value' )]
    params are not passing yet

Pwsh> uni Space.CrLf

    Exception: ExactMatchNotFound:

Pwsh>
    uni -InputRune Stx.Symbol
        <tab>
        re

    uni Null.Symbol
        should tab completes to 'NullSymbol'

    uni Null.Symbol
        should tab completes to '␀'

- todo: pass query string filter
    always uses -match '' right now

'@


return