# Copyright (c) .NET Foundation and contributors. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.

@{
    # Version number of this module.
    ModuleVersion        = '0.0.1'
    RootModule           = 'nin.Unicode.psm1'

    # Supported PSEditions
    CompatiblePSEditions = @('Core')

    # ID used to uniquely identify this module
    GUID                 = 'bd0dc741-1ab0-4ee8-b347-dc6bf7b02483'

    # Author of this module
    Author               = 'Jake Bolton <Jake.Bolton.314@gmail.com>)'

    # Company or vendor of this module
    CompanyName          = 'Jake Bolton <Jake.Bolton.314@gmail.com>)'

    # Copyright statement for this module
    Copyright            = 'Copyright (c) 2023'

    # Description of the functionality provided by this module
    # Description = ''

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion    = '7.2.0'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules      = @()

    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies   = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    ScriptsToProcess     = @()

    # Type files (.ps1xml) to be loaded when importing this module
    TypesToProcess       = @()

    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess     = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    NestedModules        = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport    = @(
        'nUni.*'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport      = @(
        'nUni.*'
    )

    # Variables to export from this module
    VariablesToExport    = @(
        'nUni_AppConfig'
    )

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport      = @(

    )

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData          = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @('Unicode', 'Text', 'Db')

            # A URL to the license for this module.
            # LicenseUri = ''

            # A URL to the main website for this project.
            # ProjectUri = ''

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            ReleaseNotes = '# v0.0.1

Initial release.
'

            # Prerelease string of this module
            # Prerelease = ''
        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}
