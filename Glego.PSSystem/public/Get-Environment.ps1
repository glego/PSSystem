function Get-Environment () {
    <#
    .SYNOPSIS
        Get the value of an environment variable

    .DESCRIPTION
        Get the value of an environment variable

    .PARAMETER Variable
        Specifies the variable name to be retrieved.

    .PARAMETER Target
        Specify the target scope where to retreive the environment variable from.

    .EXAMPLE
        Get-Environment

        Will provide all the environment variables of the current process

    .EXAMPLE
        Get-Environment -Variable Path

        Will provide the Path variable of the current process

    .EXAMPLE 
        Get-Environment -Variable Path -Target Machine

        Will provide the Path variable of the Machine

    .LINK
        https://github.com/glego/PSGlego/Glego.PSSystem

    #>
    [CmdletBinding()]
    Param
    (
        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        [string]$Variable,

        [parameter(ValueFromPipelineByPropertyName=$True)]
        [ValidateSet('Machine','User','Process')]
        [string]$Target="Process"
    )

    Write-Verbose "Variable: $Variable"
    Write-Verbose "Target: $Target"

    $EnvironmentVariables = @{}
    
    if (!$Variable) {
        $EnvironmentVariables = $([System.Environment]::GetEnvironmentVariables([System.EnvironmentVariableTarget]::$Target))
    }

    if ($Variable) {
        $EnvironmentVariables = @{
            $Variable = $([System.Environment]::GetEnvironmentVariable($Variable, [System.EnvironmentVariableTarget]::$Target))
        }
    }

    $Environment = New-Object PSObject -Property $EnvironmentVariables
    $Environment.PSObject.TypeNames.Insert(0, "Glego.PSSystem.Environment")
    Write-Output $Environment
}