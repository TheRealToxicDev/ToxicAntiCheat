[![Developer](https://img.shields.io/badge/Developer-andripwnDevelopment-darkgreen)](https://github.com/TheRealToxicDev)
[![Discord](https://img.shields.io/badge/Discord-TσxιƈDҽʋ%#7308-purple)](https://redirect.toxicdev.me/discord)
[![Version](https://img.shields.io/badge/Version-1.0.0-darkgreen)](https://github.com/TheRealToxicDev/ToxicAntiCheat/blob/master/version)
[![Version](https://img.shields.io/badge/License-MIT-darkgreen)](https://github.com/TheRealToxicDev/ToxicAntiCheat/blob/master/LICENSE)

ToxicAntiCheat is a resource for FiveM to detect hackers and ban them from your server.

⚠️ Not following all the instructions will result in a possible ban, this resource cannot work correctly without proper installation.
Also, using this resource is at your own risk and is not a magical resource that will stop all hackers.

### Requirement
- None

### Get Started
To use this anticheat, all `esx:`, `esx_` etc. must be renamed.
The anticheat replaces `esx_...` server calls to perm bans.

Change e.g. `esx_drugs` to `tox_drugs` (leave resource folder just the orignal resource name example: `esx_drugs`).

⚠️ Everything that needs to be replaced

Search | Replace
:-------------|:--------------
`TriggerEvent('esx` | `TriggerEvent('tac`
`TriggerClientEvent('esx` | `TriggerClientEvent('tac`
`TriggerServerEvent('esx` | `TriggerServerEvent('tac`
`TriggerServerEventInternal('esx` | `TriggerServerEventInternal('tac`
`TriggerEventInternal('esx` | `TriggerEventInternal('tac`
`RegisterServerEvent('esx` | `RegisterServerEvent('tac`
`AddEventHandler('esx` | `AddEventHandler('tac`
`RegisterNetEvent('esx` | `RegisterNetEvent('tac`
`RegisterServerCallback('esx` | `RegisterServerCallback('tac`
`TriggerServerCallback('esx` | `TriggerServerCallback('tac`
`TriggerEvent("esx` | `TriggerEvent("tac`
`TriggerClientEvent("esx` | `TriggerClientEvent("tac`
`TriggerServerEvent("esx` | `TriggerServerEvent("tac`
`TriggerServerEventInternal("esx` | `TriggerServerEventInternal("tac`
`TriggerEventInternal("esx` | `TriggerEventInternal("tac`
`RegisterServerEvent("esx` | `RegisterServerEvent("tac`
`AddEventHandler("esx` | `AddEventHandler("tac`
`RegisterNetEvent("esx` | `RegisterNetEvent("tac`
`RegisterServerCallback("esx` | `RegisterServerCallback("tac`
`TriggerServerCallback("esx` | `TriggerServerCallback("tac`

`tox` is an example and does not necessarily need to be used. You can put anything you want here. 
As long as `esx` is changed to something else

### Overview of other events without prefix with `esx`
⚠️ You should rename it or take it out of the list. If you don't do this, your players will be banned.
⚠️ Everything that your scripts called and is listed here, must be renamed or removed from the list

[![Client List](https://img.shields.io/badge/Client%20List-fake_events.lua-blue)](https://github.com/TheRealToxicDev/ToxicAntiCheat/blob/master/client/anticheat/fake_events.lua)
[![Server List](https://img.shields.io/badge/Server%20List-fake_events.lua-red)](https://github.com/TheRealToxicDev/ToxicAntiCheat/blob/master/server/anticheat/fake_events.lua)

Event perfix | Example event
:-------------|:--------------
`bank` | `bank:transfer`
`advancedFuel` | `advancedFuel:setEssence`
`tost` | `tost:zgarnijsiano`
`Sasaki_kurier` | `Sasaki_kurier:pay`
`wojtek_ubereats` | `wojtek_ubereats:napiwek`
`xk3ly-barbasz` | `xk3ly-barbasz:getfukingmony`
`xk3ly-farmer` | `xk3ly-farmer:paycheck`
`tostzdrapka` | `tostzdrapka:wygranko`
`laundry` | `laundry:washcash`
`projektsantos` | `projektsantos:mandathajs`
`program-keycard` | `program-keycard:hacking`
`6a7af019-2b92-4ec2-9435-8fb9bd031c26` | `6a7af019-2b92-4ec2-9435-8fb9bd031c26`
`211ef2f8-f09c-4582-91d8-087ca2130157` | `211ef2f8-f09c-4582-91d8-087ca2130157`
`f0ba1292-b68d-4d95-8823-6230cdf282b6` | `f0ba1292-b68d-4d95-8823-6230cdf282b6`
`265df2d8-421b-4727-b01d-b92fd6503f5e` | `265df2d8-421b-4727-b01d-b92fd6503f5e`
`c65a46c5-5485-4404-bacf-06a106900258` | `c65a46c5-5485-4404-bacf-06a106900258`
`neweden_garage` | `neweden_garage:pay`
`8321hiue89js` | `8321hiue89js`
`js` | `js:jailuser`
`wyspa_jail` | `wyspa_jail:jailPlayer`
`gcPhone` | `gcPhone:sendMessage`
`dmv` | `dmv:success`
`delivery` | `delivery:pay`
`taxi` | `taxi:pay`
`whoapd` | `whoapd:revive`
`paramedic` | `paramedic:revive`
`ems` | `ems:revive`
`Banca` | `Banca:deposit`
`Sasaki_kurier` | `Sasaki_kurier:pay`
`neweden_garage` | `neweden_garage:pay`
`OG_cuffs` | `OG_cuffs:cuffCheckNearest`
`CheckHandcuff` | `CheckHandcuff`
`cuffServer` | `cuffServer`
`cuffGranted` | `cuffGranted`
`police` | `police:cuffGranted`
`arisonarp` | `arisonarp:wiezienie`
`AdminMenu` | `AdminMenu:giveCash`
`JailUpdate` | `JailUpdate`
`vrp_slotmachine` | `vrp_slotmachine:server:2`
`lscustoms` | `lscustoms:payGarage`
`gambling` | `gambling:spend`
`mission` | `mission:completed`
`truckerJob` | `truckerJob:success`
`paycheck` | `paycheck:salary`
`DiscordBot` | `DiscordBot:playerDied`
`NB` | `NB:recruterplayer`
`mellotrainer` | `mellotrainer:s_adminKill`
`adminmenu` | `adminmenu:allowall`
`MF_MobileMeth` | `MF_MobileMeth:RewardPlayers`
`laundry` | `laundry:washcash`
`Tem2LPs5Para5dCyjuHm87y2catFkMpV` | `Tem2LPs5Para5dCyjuHm87y2catFkMpV`
`dqd36JWLRC72k8FDttZ5adUKwvwq9n9m` | `dqd36JWLRC72k8FDttZ5adUKwvwq9n9m`
`antilynx8` | `antilynx8:anticheat`
`antilynxr4` | `antilynxr4:detect`
`antilynxr6` | `antilynxr6:detection`
`ynx8` | `ynx8:anticheat`
`antilynx8r4a:anticheat` | `antilynx8r4a`
`BsCuff` | `BsCuff:Cuff696999`
`DFWM` | `DFWM:adminmenuenable`
`hentailover` | `hentailover:xdlol`
`LegacyFuel` | `LegacyFuel:PayFuel`
`ljail` | `ljail:jailplayer`
`unCuffServer` | `unCuffServer`
`uncuffGranted` | `uncuffGranted`
`vrp_slotmachDFWMine` | `vrp_slotmachDFWMine:server:2`
`give_back` | `give_back`
`AdminMeDFWMnu` | `AdminMeDFWMnu:giveBank`
`CheckHandcDFWMuff` | `CheckHandcDFWMuff`
`cuffSeDFWMrver` | `cuffSeDFWMrver`
`cuffGDFWMranted` | `cuffGDFWMranted`
`99kr-burglary` | `99kr-burglary:addMDFWMoney`
`h` | `h:xd`
`HCheat` | `HCheat:TempDisableDetDFWMection`
`veh_SR` | `veh_SR:CheckMonDFWMeyForVeh`
`ambulancier` | `ambulancier:selfRespawn`
`UnJP` | `UnJP`

### Enable `/anticheat` for players
If you want `/anticheat` command available for example your Admin's than you can add this line to your `server.cfg`
```cfg
add_ace group.admin andripwnanticheat.commands allow
```
Console is always allowed to execute `/anticheat` command.
Use `/anticheat` or `/anticheat help` to show all available commands.

### Bypass
If you have players like Admin's who should never be banned, you should add the following to their group
⚠️ You have to add these to the group of people who are allowed to use spectates, noclip, godmode, and other bannable functionalities.
```cfg
add_ace group.admin andripwnanticheat.bypass allow
```

### Server.cfg
A number of variables must be added in your `server.cfg`

Code | Values | Type
:---|:---|:---:
`set toxicanticheat.godmode true` | `true` Check and ban players if godmode has been detected | `boolean`
`set toxicanticheat.updateidentifiers true` | `true` If a player is banned and joined with new identifiers, those identifiers will banned immediately. | `boolean`
`set toxicanticheat.bypassenabled false` | `true` All players with `andripwnanticheat.bypass` will not be checked or banned. | `boolean`
`set toxicanticheat.webhook "https://discordapp.com/api/webhooks/.../..."` | Webhook url from discord to log bans there | `string`
`set toxicanticheat.VPNCheck` | `true` If VPN check needs to be enabled, `false` If VPN check needs to be disabled | `boolean`
`set toxicanticheat.VPNKey "UXZyszcyjZ8KYQeDPyfUTs83mj2Nagdd9EVWWtVSk9GJEHpZne=="` | The API key you have from [IPHub](https://iphub.info/) - https://iphub.info/ | `string`

### VPN Checker
Because hackers often use a VPN or change their IP after being banned from the server, there is a VPN blocker in andripwnAntiCheat. This VPN blocker use information from [IPHub](https://iphub.info/). To use this VPN blocker you must create an account on [IPHub](https://iphub.info/) and create a (free) API Key. After creating an account, you get 1.000 requests every day for free, if you use more then a 1.000 every day then you need to upgrade your free API, you will get charged for this. andripwnAntiCheat has a built-in IP cache, which means that it stores all IPs from the earlier request. The cache is completely empty after restarting the server or andripwnAntiCheat resource himself.


### Disclamer
---
This resource was created by me with all the knowledge at the time of writing. It doesn't mean cheating becomes impossible. Updates will be done if there are time and reason to do so. The request for new functionality is allowed but it does not mean that it will be released.
