local map = vim.keymap.set

-- Clear search highlight with enter
map("n", "<CR>", "<cmd>noh<CR><CR>", { silent = true })

-- Disable command-line window (too easy to mispress instead of :q)
map("n", "q:", "<nop>", { desc = "Disable command-line window" })

-- Make macro recording explicit
map("n", "q", "<nop>", { desc = "Disable macro recording" })
map("n", "<leader>um", "q", { desc = "Record macro" })

-- Easier terminal navigation
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Reload config
map("n", "<leader>R", "<cmd>source $MYVIMRC<CR>", { desc = "Reload config" })

-- Run current file
map("n", "<leader>rf", function()
    local file = vim.fn.expand("%:p")
    local cwd = vim.fn.getcwd()
    local cmd
    local runners = {
        go = { "go", "run" },
        javascript = { "node" },
        lua = { "lua" },
        sh = { "sh" },
        typescript = { "tsx" },
        zsh = { "zsh" },
    }

    if file == "" then
        vim.notify("No file to run", vim.log.levels.WARN)
        return
    end

    if vim.bo.filetype == "python" then
        local root = vim.fs.root(file, { "uv.lock", "pyproject.toml" })
        if root then
            cwd = root
            cmd = { "uv", "run", "python", file }
        else
            cmd = { "python3", file }
        end
    elseif runners[vim.bo.filetype] then
        cmd = vim.list_extend(vim.deepcopy(runners[vim.bo.filetype]), { file })
    elseif vim.fn.executable(file) == 1 then
        cmd = { file }
    end

    if not cmd then
        vim.notify("No runner configured for " .. vim.bo.filetype, vim.log.levels.WARN)
        return
    end

    vim.cmd("write")
    vim.cmd("botright split")
    vim.cmd("enew")
    vim.bo.buflisted = false
    vim.bo.bufhidden = "wipe"
    vim.bo.swapfile = false
    map("n", "q", function()
        vim.api.nvim_win_close(0, true)
    end, { buffer = true, silent = true, nowait = true, desc = "Close runner" })

    local job = vim.fn.jobstart(cmd, { cwd = cwd, term = true })
    if job <= 0 then
        vim.notify("Failed to run file", vim.log.levels.ERROR)
        return
    end

    vim.cmd("startinsert")
end, { desc = "Run file" })

-- Resize splits
map("n", "<C-w>H", "<C-w>5<", { desc = "Resize left" })
map("n", "<C-w>L", "<C-w>5>", { desc = "Resize right" })
map("n", "<C-w>J", "<C-w>5+", { desc = "Resize down" })
map("n", "<C-w>K", "<C-w>5-", { desc = "Resize up" })

-- tmux sessionizer
map("n", "<C-f>", function()
    vim.system({
        "tmux",
        "display-popup",
        "-E",
        "-w",
        "80%",
        "-h",
        "80%",
        vim.env.HOME .. "/.local/bin/tmux-sessionizer",
    }, { detach = true })
end, { desc = "tmux sessionizer" })
