games { 'rdr3'}

fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

client_scripts {
'config.lua',
 'warmenu.lua',
   'client/main.lua',
 }

server_scripts {
	 'config.lua',
	  'server/main.lua',
	'@oxmysql/lib/MySQL.lua',
}

