  #Author: Vince Vardaro
  $a = @"
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html><head><title>Active Directory User Report</title>
<style type="text/css">
<!--
body {
font-family: Verdana, Arial;
padding: 10px;
}
  table
    {
      
        margin-right:auto;
        border: 1px solid rgb(190, 190, 190);
        font-Family: Helvetica, Tahoma;
        font-Size: 10pt;
        text-align: left;
    }
th
    {
        Text-Align: Left;
        font-size: 8pt;
        font-weight: bold;
        Color:#4682B4;
              background-color: white;
        Padding: 1px 4px 1px 4px;
    }
tr:hover td
    {
        background-color: DodgerBlue ;
        Color: #F5FFFA;
             
    }
tr:nth-child(even)
    {
        Background-Color: #D3D3D3;
    }
tr:nth-child(odd)
       {
              background-color:#F8F8FF;
       }     
      
td
    {
        Vertical-Align: Top;
        Padding: 5px;
    }
  
h1{
       clear: both;
       font-size: 12pt;
       font-weight: bold;
       }
h2{
       clear: both;
      
      
       font-size: 17px;
       font-weight: 300;
       Margin-bottom: 10px;
      
}
p{
    font-size: 10pt;
    font-weight: 300;   
    text-align: left;
    margin-bottom: 10px;
}
}
-->
</style>
</head>
"@
ImportSystemModules ActiveDirectory #Needed for PS < 4.0
$Users = Get-ADUser -Filter * -Properties * 

$UserCnt = $Users.Count
$Date = Get-Date -Format g

$UsrObj = @()
foreach ($user in $Users)
{
$usr = New-Object -TypeName PSObject -Property @{

"Canonical Name" = $User.CanonicalName
"SAM Account Name" = $User.SamAccountName
"Enabled" = if ($User.Enabled -eq $true){"Yes"} else{"No"}
"Password Expired" = if ($user.PasswordExpired -eq $true){"Expired"}else{"Not Expired"}
"Date Created" = $User.Created
"Last Logon" = $User.LastLogonDate
"Days Elapsed Since Last Logon" = if ($user.LastLogonDate -ne $null){if($User.lastLogon -ne 0){(new-TimeSpan([datetime]::FromFileTimeUTC($User.lastLogon)) $(Get-Date)).days}else{0}}else{"Never Logged On"}
"Last Failed Logon" = $User.LastBadPasswordAttempt
"Account Age - Days" = (New-TimeSpan([datetime]$User.createTimeStamp) $(Get-Date)).Days 
}

$UsrObj += $usr

}

$UsrObj|sort-object -property "Days Elapsed Since Last Logon" -Descending|ConvertTo-Html "Canonical Name","SAM Account Name","Enabled","Password Expired","Date Created","Last Logon","Days Elapsed Since Last Logon","Last Failed Logon","Account Age - Days"`
 -head $a -body "<body><h2>Active Directory Users Last Login Times</h2><p>Date: $date</p><p>User Count: $UserCnt</p></body>"|
Out-File "Active Directory User Report.html"
