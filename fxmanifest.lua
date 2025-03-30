fx_version 'cerulean'
game 'gta5'

author 'Lima'
description 'FPS Booster para FiveM'
version '1.0.0'

ui_page 'client/nui/index.html'

shared_scripts {
    '@vrp/lib/utils.lua',
    'config.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

files {
    'client/nui/index.html',
    'client/nui/**/*',
    'client/nui/assets/*.js',
    'client/nui/assets/*.css'
} 