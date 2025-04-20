fx_version 'cerulean'
game 'gta5'

description ''
version '2.0.0'

shared_scripts {"config.lua", '@ox_lib/init.lua'}

server_script "@oxmysql/lib/MySQL.lua"

server_script 'server/**/*.lua'
client_script 'client/**/*.lua'

lua54 'yes'
dependency '/onesync'

client_script '@nyx2_persistent/client/overrides.lua'
server_script '@nyx2_persistent/server/overrides.lua'