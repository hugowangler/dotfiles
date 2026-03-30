return {
    "echasnovski/mini.icons",
    lazy = true,
    config = function()
        require("mini.icons").setup()
        MiniIcons.mock_nvim_web_devicons()
    end,
}
