
## ** typedata**

- `nUni.GetNamedText -Name` should accept `[string[]]` and then return an array of those chars, separately, not as a joined string
- `nUni.Named` should use argument completer with tooltips
- rewrite `InspectRuneResult` as `Update-FormatData`

- `Rune.Category` from [GetUnicodeCategory](https://learn.microsoft.com/en-us/dotnet/api/system.char.getunicodecategory?view=net-8.0)
- impl [StringInfo](https://learn.microsoft.com/en-us/dotnet/api/system.globalization.stringinfo?view=net-8.0)
- [ReadOnlySpan<char>](https://learn.microsoft.com/en-us/dotnet/api/system.text.rune?view=net-8.0#query-properties-of-a-rune)