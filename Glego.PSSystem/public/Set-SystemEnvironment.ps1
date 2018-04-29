function Set-Environment () {
    <#
    .SYNOPSIS
        Set the value of an environment variable

    .DESCRIPTION
        Set the value of an environment variable

    .PARAMETER Variable
        Specifies the variable name to be set.

    .PARAMETER Value
        Specifices the variable value to be set.

    .PARAMETER Target
        Specify the target scope where to set the environment variable to.

    .PARAMETER Append
        To append on the current variable. If the variable is path it will automatically add the semi-colon ";".

    .EXAMPLE
        Get-Environment -Variable Path -Value

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
        [parameter(Mandatory=$True,
            ValueFromPipeline=$True,
            ValueFromPipelineByPropertyName=$True)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$Variable,

        [parameter(Mandatory=$True,
            ValueFromPipelineByPropertyName=$True)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(0,32760)]
        [string]$Value,

        [parameter(ValueFromPipelineByPropertyName=$True)]
        [boolean]$Append,

        [parameter(ValueFromPipelineByPropertyName=$True)]
        [ValidateSet('Machine','User','Process')]
        [string]$Target="Process"
    )

    Write-Verbose "Variable: $Variable"
    Write-Verbose "Value: $Value"
    Write-Verbose "Append: $Append"
    Write-Verbose "Target: $Target"

    [System.Environment]::GetEnvironmentVariable($Variable, [System.EnvironmentVariableTarget]::$Target)
    
    # Append value to existing value
    if ($Append) {
        # Get the current environment variable value
        $EnvironmentVariableValue = $([System.Environment]::GetEnvironmentVariable($Variable, [System.EnvironmentVariableTarget]::$Target))

        # If the environment variable is Path then append with semi-colon ";"
        if ($Variable -eq "Path") {
            $LastCharacter = $EnvironmentVariableValue.Substring($EnvironmentVariableValue.Lenght -1)
            if ($LastCharacter -eq ";"){
                $Value = $EnvironmentVariableValue + $Value
            } else {
                $Value = $EnvironmentVariableValue + ";" + $Value
            }

        # In all other cases, simply append
        } else { 
            $Value = $EnvironmentVariableValue + $Value
        }
    }

    # Set environment variable
    [System.Environment]::SetEnvironmentVariable($Variable, $Variable, [System.EnvironmentVariableTarget]::$Target)

    # Get environment variable
    $EnvironmentVariables = @{
        $Variable = $([System.Environment]::GetEnvironmentVariable($Variable, [System.EnvironmentVariableTarget]::$Target))
    }
    
    # Output changes
    $Environment = New-Object PSObject -Property $EnvironmentVariables
    $Environment.PSObject.TypeNames.Insert(0, "Glego.PSSystem.Environment")
    Write-Output $Environment
}