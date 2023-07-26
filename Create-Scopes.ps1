# Set the global options for the server
Set-DhcpServerv4OptionValue -DnsDomain 'ad.emsiensi.org' -DnsServer '192.168.100.108'

# Get the scope data from the CSV file
$dhcpData = Import-Csv C:\Users\Administrator\Downloads\DHCP_Mess.csv

# Create the scopes
<#
foreach ( $d in $dhcpData ) {
    Add-DhcpServerv4Scope -Name $d.name -StartRange $d.start -EndRange $d.end -State Active -SubnetMask $d.netmask -LeaseDuration $d.lease -Type Dhcp
    
    Set-DhcpServerv4OptionValue -ScopeId $d.scopeid -Router $d.gateway
}
#>
<#
foreach ( $d in $dhcpData ) {
    Add-DhcpServerv4Scope `
        -Name $d.name `
        -StartRange $d.start `
        -EndRange $d.end `
        -State Active `
        -SubnetMask $d.netmask `
        -LeaseDuration $d.lease `
        -Type Dhcp

    Set-DhcpServerv4OptionValue `
        -ScopeId $d.scopeid `
        -Router $d.gateway
}
#>
<#
foreach ( $d in $dhcpData ) {
    $scope = [pscustomobject]@{
        Name = $d.Name
        StartRange = $d.start
        EndRange = $d.end
        State = 'Active'
        SubnetMask = $d.netmask
        LeaseDuration = $d.lease
        Type = 'Dhcp'
    }
    $scope | Add-DhcpServerv4Scope

    Set-DhcpServerv4OptionValue `
        -ScopeId $d.scopeid `
        -Router $d.gateway
}
#>