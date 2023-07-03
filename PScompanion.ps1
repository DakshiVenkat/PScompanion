clear-host
$csvFilePath = "D:\PScompanion.csv"
write-host "`t`t`t`t`t$("*"*25)`n`t`t`t`t`t** POWERSHELL COMPANION**`n`t`t`t`t`t$("*"*25)" -f red
write-host "`t`t`t`t`t1) SERVICE`n`t`t`t`t`t2) PROCESS`n`t`t`t`t`t3) LOG FILES`n`t`t`t`t`t4) FOLDER SIZE`n`t`t`t`t`t$("="*25)" -F Cyan
############input
[int]$opt = read-host -Prompt "`t`t`t`t`tEnter An Option(1-4)"
#############
if($opt -eq 1)
{Write-Host "opted` 1"}
elseif($opt -eq 2)
{Write-Host "opted 2"}
elseif($opt -eq 3)
{Write-Host "opted 3"}
elseif($opt -eq 4)
{Write-Host "opted 4"}
else
{Write-Host "Invalid option"}
if($opt -eq 1)
{
write-host "Selected Option is Get-Service"
$status_name = read-host -Prompt "Enter the Status Property Value[Stopped/Running]"
$dis_name = read-host -Prompt "Enter the Display name Property Value`n`t1.Starts with :: Keyword*`n`t2.Ends with :: *Keyword`n`t3.Contains :: *Keyword*`n`t4.Exact :: Keyword`n$("-"*40)`nEnter Input for DisplayName Property Value::"
$r1 = get-service | Where-Object -FilterScript {$_.Status -eq $status_name -and $_.DisplayName -like $dis_name}
$r1 | Select-Object -Property Name,StartType,Status,DisplayName |ft
$total1 = ($r1).count
write-host "No. of Objects Matched:" $total1 -f red
$r1 | Export-csv -path $csvFilePath -NoTypeInformation
write-host "Result stored in a CSV file in D drive"
}
if($opt -eq 2)
{
write-host "Selected Option is Get-Process" -f yellow
[int32]$H_strvalue = read-host -Prompt "Enter the Handles Starting value[100 to 500]"
[int]$H_endvalue = read-host -Prompt "Enter the Handles Ending value[2000 to 3000]"

#Loading the Result into the Variable(Assignment)
$r2 = Get-Process | Where-Object -FilterScript {$_.handles -gt $H_strvalue -and $_.Handles -lt $H_endvalue}
#Printing on the Screen
$r2 = $r2 | Sort-Object -property Handles |ft
$total2 = ($r2).count
write-host " No. of Objects Matched:" ($r2).count -f yellow
$r2 | Export-csv -path $csvFilePath -NoTypeInformation
write-host "Result stored in a CSV file in D drive"
}
if($opt -eq 3)
{
clear-host
write-host "Selected Option is Get-Eventlog`n$("*"*40)" -f yellow


"1 Application
2 HardwareEvents
3 Internet Explorer
4 Key Management Service
5 OAlerts
6 Security
7 System
8 Windows PowerShell"

#input1
$lname = read-host -Prompt "`n`n`n`t`tEnter the Logname From the above list" #Application
#$lname = read-host -Prompt "Enter the logname Serial Number"

"
- Error
- Information
- FailureAudit
- SuccessAudit
- Warning
"

#Entrytype of the object
$etype = read-host -Prompt "`t`tEnter the Required Entry from the list"

#Starttime of the object(s)
[datetime]$sdate = read-host -Prompt "Enter the Starting Date(including seconds`nExample: 30 June 2023 08:19:00"

#Endttime of the object(s)
[datetime]$edate = read-host -Prompt "Enter the End Date(including seconds`nExample: 30 June 2023 08:19:00"



$r3 = Get-Eventlog -LogName $lname | `
Where-Object -FilterScript {($_.TimeGenerated -ge $sdate)-and `
($_.TimeGenerated -ge $edate)-and `
($_.EntryType -eq $etype) }

#Printing
$r3=$r3 | Format-Table -Wrap

write-host "No.of Objects are" $r3.count -f Magenta
$r3 | Export-csv -path $csvFilePath -NoTypeInformation
write-host "Result stored in a CSV file in D drive"
}
if($opt -eq 4)
{

$dir_name = read-host -Prompt "Enter the Directory/Folder path" #D:\PS

if(test-path -Path $dir_name)
{
$total_size = (Get-ChildItem -Path $dir_name -Recurse |Measure-Object -Property length -sum).sum

$total_size_in_mb = [math]::Round( $total_size/1mb,2)
$total_size_in_gb = [math]::Round( $total_size/1gb,2)
write-host "Size of the Folder/Directory: $dir_name is $total_size_in_gb GB" -f Yellow
write-host "Size of the Folder/Directory: $dir_name is $total_size_in_mb MB" -f Yellow
}
if(!(test-path -Path $dir_name))
{
Write-Host $dir_name is Not Avaialble on the $env:COMPUTERNAME
}
}

if($opt -gt 4 -or $opt -lt 1)
{
write-host Invalid Statement -f Green
}
