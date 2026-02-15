return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>tt",
        function()
          local buf = vim.api.nvim_create_buf(false, true)
          local ns = vim.api.nvim_create_namespace("nvim_help")
          
          local lines = {
            "┌──────────────────── Neovim Essentials ───────────────────┐",
            " File Operations",
            "│ ├ :w                      Save",
            "│ ├ :q                      Quit",
            "│ ├ :wq                     Save and quit",
            "└ └ :q!                     Quit without saving",
            "",
            " Modes",
            "│ ├ i/a                     Insert before/after cursor",
            "│ ├ I/A                     Insert start/end of line",
            "│ ├ o/O                     New line below/above",
            "│ ├ v/V                     Visual/line mode",
            "└ └ Esc                     Back to normal mode",
            "",
            " Search & Replace",
            "│ ├ /pattern                Search forward",
            "│ ├ ?pattern                Search backward",
            "│ ├ n                       Next match",
            "│ ├ N                       Previous match",
            "│ ├ :%s/old/new/g           Replace all in file",
            "└ └ :s/old/new/g            Replace in line",
            "",
            "󰦂 Navigation",
            "│ ├ $                       End of line",
            "│ ├ 0                       Start of line",
            "│ ├ gg                      Start of file",
            "│ ├ G                       End of file",
            "│ ├ w                       Next word",
            "└ └ b                       Previous word",
            "",
            " Delete & Edit",
            "│ ├ dd                      Delete line",
            "│ ├ dw                      Delete word",
            "│ ├ d$                      Delete to end of line",
            "│ ├ x                       Delete character",
            "│ ├ u                       Undo",
            "└ └ Ctrl+r                  Redo",
            "",
            " Copy/Paste",
            "│ ├ yy                      Yank (copy) line",
            "│ ├ y                       Yank selection",
            "│ ├ p/P                     Paste after/before",
            "└ └ \"+y                     Copy to clipboard",
            "",
            " Text Objects",
            "│ ├ ciw                     Change inside word",
            "│ ├ ci\"/ci'/ci`             Change inside quotes",
            "│ ├ ci(/ci{/ci[             Change inside brackets",
            "│ ├ diw/daw                 Delete inside/around word",
            "└ └ cit                     Change inside tag (HTML)",
            "",
            "󰆾 Multiple Cursors",
            "│ ├ <C-n>                   Select word (repeat for more)",
            "│ ├ <C-d>                   Skip current, select next",
            "└ └ <C-x>                   Skip current match",
            "",
            " Window Management",
            "│ ├ <C-h/j/k/l>             Navigate windows",
            "│ ├ <C-w>s                  Split horizontal",
            "│ ├ <C-w>v                  Split vertical",
            "│ ├ <C-w>q                  Close window",
            "│ ├ <C-arrows>              Resize windows",
            "└ └ <leader>-/|             Split horiz/vert",
            "└──────────────────────────────────────────────────────────┘",
            "┌─────────────────── LazyVim Essentials ───────────────────┐",
            " LazyVim",
            "│ ├ <leader>ff              Find files",
            "│ ├ <leader>sg              Search grep",
            "│ ├ <leader>e               Toggle explorer",
            "│ ├ <leader>/               Toggle comment",
            "└ └ <leader>ll              Setup layout",
            "└──────────────────────────────────────────────────────────┘",
          }
          
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

          -- borders red
          vim.api.nvim_buf_add_highlight(buf, ns, "DiagnosticError", 0, 0, -1)
          vim.api.nvim_buf_add_highlight(buf, ns, "DiagnosticError", 63, 0, -1)
          vim.api.nvim_buf_add_highlight(buf, ns, "DiagnosticError", 64, 0, -1)
          vim.api.nvim_buf_add_highlight(buf, ns, "DiagnosticError", 71, 0, -1)

          -- color entire sections (not just headers)
          local sections = {
            { start = 1, end_line = 5, hl = "String" },       -- File Operations (green #a6e3a1)
            { start = 7, end_line = 12, hl = "Type" },        -- Modes (yellow #f9e2af)
            { start = 14, end_line = 20, hl = "Function" },   -- Search & Replace (blue #89b4fa)
            { start = 22, end_line = 28, hl = "Keyword" },    -- Navigation (mauve #cba6f7)
            { start = 30, end_line = 36, hl = "Special" },    -- Delete & Edit (pink #f5c2e7)
            { start = 38, end_line = 42, hl = "Character" },  -- Copy/Paste (teal #94e2d5)
            { start = 44, end_line = 49, hl = "Constant" },   -- Text Objects (peach #fab387)
            { start = 51, end_line = 54, hl = "Operator" },   -- Multiple Cursors (sky #89dceb)
            { start = 56, end_line = 62, hl = "Label" },      -- Window Management (sapphire #74c7ec)
            { start = 65, end_line = 70, hl = "rainbow6" },   -- LazyVim (lavender #b4befe)
          }

          for _, section in ipairs(sections) do
            for line = section.start, section.end_line do
              vim.api.nvim_buf_add_highlight(buf, ns, section.hl, line, 0, -1)
            end
          end

          vim.bo[buf].modifiable = false
          vim.bo[buf].buftype = "nofile"

          local width = 62
          local height = 64
          local win = vim.api.nvim_open_win(buf, true, {
            relative = "editor",
            width = width,
            height = height,
            col = (vim.o.columns - width) / 2,
            row = (vim.o.lines - height) / 2,
            style = "minimal",
            border = "rounded",
          })

          vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf })
          vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf })
        end,
        desc = "Neovim Help",
      },
    },
  },
}
