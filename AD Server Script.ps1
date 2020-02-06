#To display the expiration date rather than the password last set date, use this command
Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" |
Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

#To display the expiration date rather than the password last set date, use this command.
get-aduser -filter * -properties passwordlastset, passwordneverexpires |ft userPrincipalName,Name, passwordlastset, Passwordneverexpires
#passwordneverexpires -like "*false"' 
get-aduser -filter  *  -properties passwordlastset, passwordneverexpires |ft userPrincipalName,Name, passwordlastset, Passwordneverexpires

#search like -Filter 'passwordneverexpires -like "*false"'

#search based ou
Get-ADUser -Filter * -SearchBase "OU=fad,DC=data,DC=wpsmanado,DC=COM"   -properties passwordlastset, passwordneverexpires | Format-Table userprincipalName,passwordlastset,Passwordneverexpires | Where-Object {$_.passwordneverexpires}

#search based ou w/ filter object "true"
Get-ADUser -Filter * -SearchBase "OU=fad,DC=data,DC=wpsmanado,DC=COM"   -properties passwordlastset,passwordneverexpires | Where-Object {$_.passwordneverexpires -eq "true"} | Format-Table userprincipalName,passwordlastset,Passwordneverexpires

#search based ou w/ filter object "true" + export 
Get-ADUser -Filter * -SearchBase "OU=fad,DC=data,DC=wpsmanado,DC=COM"   -properties passwordlastset,passwordneverexpires | Where-Object {$_.passwordneverexpires -eq "true"} | Format-Table userprincipalName,passwordlastset,Passwordneverexpires | export-csv X:\powershell\export\password_expiring_test.csv -NoTypeInformation