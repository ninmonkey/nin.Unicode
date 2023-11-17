beforeAll {
    # $ModPath = Join-Path $PSScriptRoot '../source/nin.Unicode.psm1'
    # $ModPath | Join-String -op'try: ' -DoubleQuote | write-verbose -verb
    # Import-module $ModPath -PassThru -Force
    #     | Join-String -p { $_.Name, $_.Version } | out-host

    import-module -PassThru -Force 'H:\data\2023\pwsh\PsModules\nin.Unicode\nin.Unicode.psm1'
}

describe 'New-Rune' {
    context 'FromInt' {
        it '<In> Is <Expected>' -ForEach @(
            @{
                In = 0x0
                Expected = [Text.Rune]::new( 0x0 ).ToString()
            }
            @{
                In = 0x2400
                Expected = [Text.Rune]::new( 0x2400 )
            }
        ) {
            try {
                nUni.New-Rune -FromInt $In
                | Should -BeExactly $Expected
            }
            catch {
                throw "Failed with input: $($_.Exception.Message)"
            }
        }
    }
    context 'FromSurrogate' -Pending -ForEach @() {
        it 'test nyi' {
            # Set-ItRes
        }
    }
}