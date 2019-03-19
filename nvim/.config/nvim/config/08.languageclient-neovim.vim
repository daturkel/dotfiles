" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
    \ 'python': ['${py3_bin_loc}pyls'],
    \ }

let g:LanguageClient_settingsPath="${home_dir}.config/nvim/ls_settings.json"
