<#
.SYNOPSIS
    Writes customized output to a host.

.DESCRIPTION
    The Print-FirstRecurringCharacter cmdlet accept a string parameter and returns first recurring charater in the string. 
    The script validates for both cases of a character. This cmdlet returns returns non-zero return code if 
    the array validation operations fails.

.EXAMPLE
    Print-FirstRecurringCharacter.PS1 -InputString "abcdedcba"


.PARAMETERS
    Commandlet accepts a single inputString

.AUTHOR
    Gaurav Mishra

#>

[CmdletBinding()]
param(

    [Parameter(Position=0, 
			   Mandatory=$false, 
			   ValueFromPipeline=$true,
			   ValueFromPipelineByPropertyName=$true)
    ]
    [string] $InputString
) #



$ValidationArray = $NULL
$RepeatedChars = @()
$Return = @{}


function validate-Repeatedcharacter {

    param(

        [Parameter(Position=0, 
			       Mandatory=$false)
        ]
        [string]$SampleString,

        [Parameter(Position=1, 
			       Mandatory=$false)
        ]
        [string]$ValidationChatacter
    ) #


    $ReturnResponse = @{}
    $CharLower = $ValidationChatacter.ToLower()
    $CharUpper = $ValidationChatacter.ToUpper()
    
    ### Validate if Char exists in input string
    try{
        $CountLower = ([regex]::matches($SampleString, $CharLower)).count
        $CountUpper = ([regex]::matches($SampleString, $CharUpper)).count

        if(($CountLower -eq 0) -AND ($CountUpper -eq 0)){

            $ReturnResponse.status = 0
            $ReturnResponse.response = "FALSE"

        } else {

            $ReturnResponse.status = 0
            $ReturnResponse.response = "TRUE"

        } ## if-else ends
    } catch {
            
        $ReturnResponse.status = 1
        $ReturnResponse.response = "$_"

    } ## Catch ends


    ### Return response
    return $ReturnResponse

}  ## Function validate-Repeatedcharacter ends



Function insert-Newcharacter  {

    param(

        [Parameter(Position=0, 
			       Mandatory=$false)
        ]
        [string]$InputArray,

        [Parameter(Position=1, 
			       Mandatory=$false)
        ]
        [string]$ValidationChatacter
    ) #

    $ReturnResponse = @{}
    try{
        
        $InputArray += $char
        $ReturnResponse.status = 0
        $ReturnResponse.response = $InputArray

    } catch {
    
        $ReturnResponse.status = 1
        $ReturnResponse.response = "$_"
    }## Catch ends


    ### Return response
    return $ReturnResponse

}  ## Function insert-Newcharacter ends



#### Main () #####

Foreach($char in $InputString.ToCharArray()) {

    <# 
        Validation Step 1 : Character already exists in the string 
        Case 1 : Charector Upper Case 
        Case 2 : Charactor Lower Case

    #>
        
    $Return = validate-Repeatedcharacter -SampleString $ValidationArray -ValidationChatacter $char


    if(($Return.Status -eq 0 ) -AND ($Return.Response -eq "FALSE")){
        
        <# 
            Validation Step 2 : Response Validation 
               Case1 : Push the character in array if it is not already part of array
        #>

        $Return = insert-Newcharacter -InputArray $ValidationArray -ValidationChatacter $char


       <# 
            Validation Step 2 : Response Validation 
            Validate response of Case 1
        #>
        if($Return.Status -eq 0 ){
        
            $ValidationArray = $Return.response

        }
        else{
            
            Write-Output "ERROR : Operation Failed : $Return.Response "
            Exit 1 #### Exit on Failure

        }
    
    } 
    elseif(($Return.Status -eq 0 ) -AND ($Return.Response -eq "TRUE")) {
    
       <# 
            Validation Step 2 : Response Validation 
            Case2 : Print the repeating charactar
        #>

        return $char

    }
    else{
    
        if($Return.Status -eq 1 ) {
        
            Write-Output "ERROR : Operation Failed : $Return.Response "
            Exit 1 #### Exit on Failure
        }
    }
}

# End of cmdlet