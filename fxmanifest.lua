fx_version 'cerulean'

game 'gta5'

author 'eMILSOMFAN'
description 'emfan custom coding framwork'

version '1.0.0'

lua54 'yes'

shared_scripts {
    'config.lua',
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    -- '@async/async.lua',               
	-- '@mysql-async/lib/MySQL.lua',
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

escrow_ignore {
    'locales/*.*',
    'html/*.*',
    'config.lua',
}