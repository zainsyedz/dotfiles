-- Detect Dockerfile with custom naming yet standard conventions
vim.cmd [[ augroup DockerfileDetection autocmd! autocmd BufRead,BufNewFile Dockerfile.* set filetype=dockerfile augroup END ]]
-- Detect properties files with env
vim.cmd [[ augroup EnvFileDetection autocmd! autocmd BufRead,BufNewFile .env.* set filetype=properties augroup END ]]
