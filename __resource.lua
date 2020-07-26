
--[[
	Bundled from:
		HG-Anticheat: https://github.com/HackerGeo-sp1ne/HG_AntiCheat
		FiveM-BanSql: https://github.com/RedAlex/FiveM-BanSql
]]

description 'ToxicAntiCheat'

client_scripts {
    '@es_extended/locale.lua',
    'locales/en.lua',
    'config.lua',
    'toxic-anticheat-cl.lua'
}

server_scripts {
    '@es_extended/locale.lua',
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'locales/en.lua',
	'config.lua',
        'toxic-anticheat-sv.lua'
        'system/versioncheck.lua'
}

dependencies {
    'essentialmode',
    'async'
}
