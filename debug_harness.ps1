Remove-Module 'nin.uni*', 'nin.unicode*'

Import-Module -PassThru -Force 'nin.Unicode'
    | Join-String | RenderModuleName

hr

gcm -m nin.Unicode


$path1 = nUni.ResolveItem 'H:\datasource\unicode.specs\extract\UCD\emoji\emoji-data.txt'

nUni.SpecsFile.ParseHeader -path $Path1