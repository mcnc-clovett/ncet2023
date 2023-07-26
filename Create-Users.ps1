$newOu = New-ADOrganizationalUnit -Name "Dream Team" -Path "DC=ad,DC=emsiensi,DC=org" -ProtectedFromAccidentalDeletion $false -PassThru

foreach ( $g in "Google","Zscaler" ) {
    New-ADGroup -Name $g -Path $newOu.DistinguishedName -GroupCategory Security -GroupScope Global
}

$users = Import-Csv C:\Users\Administrator\Downloads\cne_users.csv

foreach ( $u in $users ) {
    $groups = $u.groups -split ','
    
    $givenName = $u.givenname
    $surname = $u.surname
    $name = "$($u.givenname) $($u.surname)"
    $displayName = $name
    $samAccountName = $u.givenname.Substring(0,1) + $u.surname
    $userPrinName = $samAccountName + "@ad.emsiensi.org"
    $emailAddress = $samAccountName + "@emsiensi.org"
    $path = $newOu
    $changePwdLogon = $true
    $cannotChgPwd = $false
    $pwdNeverExp = $false
    $accountPwd = (ConvertTo-SecureString -AsPlainText -String 'B!gc00t!3' -Force)

    New-ADUser `
        -Name $name `
        -GivenName $givenName `
        -Surname $surname `
        -DisplayName $displayName `
        -SamAccountName $samAccountName `
        -UserPrincipalName $userPrinName `
        -EmailAddress $emailAddress `
        -Path $newOu `
        -ChangePasswordAtLogon $changePwdLogon `
        -CannotChangePassword $cannotChgPwd `
        -PasswordNeverExpires $pwdNeverExp `
        -AccountPassword $accountPwd `
        -Enabled $true

    if ( $groups ) {
        foreach ( $r in $groups ) {
            Add-ADGroupMember -Identity $r -Members $samAccountName
        }
    }
}