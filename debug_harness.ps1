
$PSStyle.OutputRendering = 'ansi'
Set-Alias 'Json' -Value 'ConvertTo-Json'
Set-Alias 'Json.from' -Value 'ConvertFrom-Json'
Remove-Module 'nin.uni*', 'nin.unicode*'

# Import-Module -PassThru -Force 'nin.Unicode'
import-module -PassThru -Force 'H:\data\2023\pwsh\PsModules\nin.Unicode\nin.Unicode.psm1'
    | Join-String | RenderModuleName


$PSStyle.OutputRendering = 'ansi'
hr

gcm -m nin.Unicode


$path1 = nUni.ResolveItem 'H:\datasource\unicode.specs\extract\UCD\emoji\emoji-data.txt'

# nUni.SpecsFile.ParseHeader -path $Path1 -ea 'ignore'


get-date | nUni.InspectRune|Ft -auto
return