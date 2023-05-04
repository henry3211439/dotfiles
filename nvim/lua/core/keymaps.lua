local keymaps = {
    -- Normal Mode --
    n = {
        [ '<Esc>' ] = { '<cmd>noh<CR>', 'Clear highlights' },

        -- Switch Between Windows --
        [ '<C-k>' ] = { '<C-w>k', 'Move up'    },
        [ '<C-j>' ] = { '<C-w>j', 'Move down'  },
        [ '<C-h>' ] = { '<C-w>h', 'Move left'  },
        [ '<C-l>' ] = { '<C-w>l', 'Move right' },

        -- Save --
        [ '<C-s>' ] = { '<cmd>w<CR>', 'Save file' },

        -- Copy --
        [ '<C-c>' ]      = { '<cmd>y+<CR>',  'Copy current line' },
        [ '<C-a><C-c>' ] = { '<cmd>%y+<CR>', 'Copy whole line'   },

        [ '<leader>n'  ] = { '<cmd>set nu!<CR>',  'Toggle line number'          },
        [ '<leader>rn' ] = { '<cmd>set rnu!<CR>', 'Toggle relative line number' },

        -- Terminal Window --
        -- [ '<C-~>' ] = { '<cmd>new +terminal<CR>', 'Toggle terminal window' },

        -- Switch Tabs --
        -- [ '<C-Tab>'  ] = { '<cmd>tabnext',     'Cycle next tab'     },
        -- [ '<C-S-Tab' ] = { '<cmd>tabprevious', 'Cycle previous tab' },

        -- NerdTree
        [ '<C-n>' ] = { '<cmd>NvimTreeToggle<CR>', 'Toggle NerdTree' },
    },

    -- Insert Mode --
    i = {
        -- Navigate within insert mode
        -- [ '<C-k>' ] = { '<Up>',    'Move up'    },
        -- [ '<C-j>' ] = { '<Down>',  'Move down'  },
        -- [ '<C-h>' ] = { '<Left>',  'Move left'  },
        -- [ '<C-l>' ] = { '<Right>', 'Move right' },
    },
}

for mode, key_value in pairs(keymaps) do
    for keybind, mapping_info in pairs(key_value) do
        vim.keymap.set(mode, keybind, mapping_info[1])
    end
end
