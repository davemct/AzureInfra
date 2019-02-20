# Lab 06 script - Using Microsoft Azure Active Directory Module for Windows PowerShell 
 
New-MsolUser -UserPrincipalName john@<#Copy your Azure Directory domain name here#>.onmicrosoft.com -DisplayName 'John Garland' -FirstName 'John' -LastName 'Garland' -Password '@Pa55w.rd' -ForceChangePassword $false -UsageLocation 'US' 
New-MsolGroup -DisplayName 'Azure team' -Description 'Wintellect Azure team users' 
$group = Get-MsolGroup | Where-Object DisplayName -eq 'Azure team' 
$user = Get-MsolUser | Where-Object DisplayName -eq 'John Garland' 
Add-MsolGroupMember -GroupObjectId $group.ObjectId -GroupMemberType 'User' -GroupMemberObjectId $user.ObjectId 
Get-MsolGroupMember -GroupObjectId $group.ObjectId