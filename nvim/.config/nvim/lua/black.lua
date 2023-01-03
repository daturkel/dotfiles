vim.api.nvim_create_autocmd(
    "FileType",
    { pattern = "python", command = "map <localleader>b :Black<cr>"}
)
