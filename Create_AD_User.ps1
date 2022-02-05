param([parameter(Mandatory=$true)] [String]$FileCSV)
$listOU=Import-CSV $FileCSV -Delimiter ";"
ForEach($OU in $listOU){
 
try{
#Get Variable from the source file
$OUName  = $OU.UserName
$OUPath  = $OU.Path
$UOPwd   = $OU.Pwd
$UODesc  = $OU.Desc
$OUGroup = $OU.Group

#Create New user and add to group
New-ADUser `
	-Name "$OUName" `
	-SamAccountName "$OUName" `
	-UserPrincipalName "$OUName@domain.local" `
	-Description "$UODesc" `
	-Path "$OUPath" `
	-AccountPassword (convertto-securestring "$UOPwd" -AsPlainText -Force) `
	-Enabled $true `
	-CannotChangePassword $True `
	-ChangePasswordAtLogon $False `
	-PasswordNeverExpires $True
Add-AdGroupMember -Identity $OUGroup -Members "$OUName"
 
#Display check confirmation
Write-Host -ForegroundColor Green "New User $OUName created and add into $OUGroup"
}catch{
 
Write-Host $error[0].Exception.Message
}
 
}
