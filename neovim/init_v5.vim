" Copy this file to ~/.config/nvim/init.vim
" Neovim version must be >= 0.5

" some options for polyglot have to be at the top
set nocompatible
let g:polyglot_disabled = ['markdown']


" ===============================================
" Plugins
" ===============================================

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

" NerdTree directory browser
" git and dev icons for NerdTree (need special font)
" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete
Plug 'preservim/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin' |
            \ Plug 'ryanoasis/vim-devicons'
            " \ Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" color schemes
"Plug 'flazz/vim-colorschemes'
" enhanced c++ syntax highlighting
Plug 'octol/vim-cpp-enhanced-highlight'
" lualine status bar
Plug 'nvim-lualine/lualine.nvim'
" fuzzy finder (fzf)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" easier commenting
Plug 'tpope/vim-commentary'
" fugitive git wrapper
Plug 'tpope/vim-fugitive'
" rust
Plug 'rust-lang/rust.vim'
" GoLang
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" javascript highlighting
Plug 'pangloss/vim-javascript'
" javascript formatter
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }
" Python formatter
Plug 'psf/black', { 'branch': 'stable' }
" language server
Plug 'neovim/nvim-lspconfig'
" plugin for LSP highlight groups
Plug 'folke/lsp-colors.nvim'
" snippet engine
Plug 'hrsh7th/vim-vsnip'
"Plug 'hrsh7th/vim-vsnip-integ'
" snippets
Plug 'rafamadriz/friendly-snippets'
" onedark color scheme for nvim >= 0.5
Plug 'mikasaurus2/onedark.nvim'
" git diff indicaters in gutter
Plug 'airblade/vim-gitgutter'
" indicate marks in gutter
Plug 'kshenoy/vim-signature'
" syntax highlighting for various files
Plug 'sheerun/vim-polyglot'
" Markdown viewer
" If you don't have nodejs and yarn
" use pre build, add 'vim-plug' to the filetype list so vim-plug can update this plugin
" see: https://github.com/iamcco/markdown-preview.nvim/issues/50
"Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
" Trouble allows better viewing of LSP errors
Plug 'nvim-tree/nvim-web-devicons'
Plug 'folke/trouble.nvim'
" completion engine
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/nvim-cmp'


" ============
" Rust plugins
" ============
" Completion framework
" Plug 'hrsh7th/nvim-cmp'
" LSP completion source for nvim-cmp
" Plug 'hrsh7th/cmp-nvim-lsp'
" Snippet completion source for nvim-cmp
" Plug 'hrsh7th/cmp-vsnip'
" Other useful completion sources
" Plug 'hrsh7th/cmp-path'
" Plug 'hrsh7th/cmp-buffer'
" To enable more of the features of rust-analyzer, such as inlay hints and more!
" Plug 'simrat39/rust-tools.nvim'

" Initialize plugin system
call plug#end()



" ================================================
" Controls
" ================================================

" leader key
let mapleader = "\<Space>"

" ctrl-n to toggle NERDTree
map <C-n> :NERDTreeToggle<CR>

" map screen scroll to match cursor scroll
nnoremap <C-j> <C-e>
nnoremap <C-k> <C-y>

" checkmark and x for checklists
nnoremap <Leader>ck r<C-k>OK
nnoremap <Leader>cx r<C-k>XX

" TODO: think about which keys to map if I want this feature
" add emptry lines above and below (and remain in normal mode)
"nnoremap <silent><C-?> :set paste<CR>m`o<Esc>``:set nopaste<CR>
"nnoremap <silent><C-?> :set paste<CR>m`O<Esc>``:set nopaste<CR>

" formatting
"map <C-l> :pyf /usr/local/Cellar/clang-format/2016-01-05/share/clang/clang-format.py<cr>
autocmd Filetype cpp map <buffer> <C-l> :py3f /usr/share/clang/clang-format-12/clang-format.py<cr>
autocmd Filetype rust nmap <buffer> <C-l> :RustFmt<cr>
autocmd Filetype rust vmap <buffer> <C-l> :RustFmt<cr>
autocmd Filetype python map <buffer> <C-l> :!black %<cr>

" ripgrep
nnoremap <Leader>r :Rg 
" fugitive git commands
nnoremap <Leader>g :G 
" neovim terminal
nnoremap <Leader>z :vnew<CR>:terminal<CR>isource $HOME/.zprofile<CR>
" quick :q
nmap <silent> <Leader>q :q<CR>

" function to move to specific window
function! WindowJump(i) abort
    " if number of windows is greater than or equal to i
    if winnr('$') >= a:i
        " execute # wincmd w to go to that window
        exe a:i . 'wincmd w'
    endif
endfunction

" space # to jump to specified window
for i in range(1, 9)
    "example: nnoremap <Leader>1 :call WindowJump(1)<CR>
    execute 'nnoremap <silent> <Leader>' .i. ' :call WindowJump('.i.')<CR>'
endfor

" toggle quickfix window
function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
  endif
  let winnr = winnr()
  " 'botright copen' will open quifkcix (full-width bottom)
  exec('botright'.' '.a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction


" easier navigation in quickfix window
nnoremap <silent> [q :cp<CR>
nnoremap <silent> ]q :cn<CR>

" easier navigation for list window
nnoremap <silent> [l :lprevious<CR>
nnoremap <silent> ]l :lnext<CR>

" NVim in recent versions made Shift-Space a control character when in
" terminal. When I'm using unix pipes | and space afterwards, I still
" sometimes hold shift, and this screws up the command line.
" This remap makes Shift-Space simply Space in terminal.
tnoremap <S-Space> <Space>

" fzf options
" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" fzf fuzzy find mappings
nnoremap <silent> <Leader>t :Tags<CR>
nnoremap <silent> <Leader>f :Files<CR>
nnoremap <silent> <Leader>b :Buffers<CR>
nnoremap <silent> <Leader>l :BLines<CR>
nnoremap <silent> <Leader>h :History:<CR>

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'
" Preview window on the right with 70 col width
let g:fzf_preview_window = 'right:70'

" ===============================================
" Configs
" ===============================================

" disable swap files
set noswapfile

" line numbers
set number

" highlight cursor line
set cursorline

" indentation (use spaces instead of tabs, each tab is 4 spaces)
set softtabstop=4 shiftwidth=4 expandtab
set autoindent

" don't autowrap comments; don't auto append comment prefix on new lines
autocmd FileType * set formatoptions-=c formatoptions-=r formatoptions-=o

" turn off incremental search
set noincsearch

" highlight extra whitespace
highlight ExtraWhitespace ctermbg=red
autocmd WinNew * :match ExtraWhitespace '\s\+$'

" color
syntax on
set background=dark
let g:onedark_style = 'mike'
let g:onedark_darker_diagnostics = v:false
colorscheme onedark
"mike_onedark
"mike_bat
"monokain
"heroku
"onedark

" extended cpp highlight options
"let g:cpp_class_scope_highlight=1
let g:cpp_member_variable_highlight=1
"let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_template_highlight=1

" airline status bar color theme and separators
let g:airline_theme='bubblegum'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'

" CTags Path
set tags=./tags;~/devel

" use rusty-tags.vi tags file when opening Rust files
autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/

" gitgutter mappings to stage and unstage hunks in file
nmap ghs <Plug>(GitGutterStageHunk)
nmap ghu <Plug>(GitGutterUndoHunk)
nmap ghp <Plug>(GitGutterPreviewHunk)
" this controls how quick gitgutter shows diff signs
set updatetime=250

" better golang highlighting
" To change syntax class, see vim-go/syntax/go.vim
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
"let g:go_highlight_variable_declarations = 1

" ===============================================
" Language Server Config
" https://github.com/neovim/nvim-lspconfig
" ===============================================
 
lua << EOF
local nvim_lsp = require('lspconfig')

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
--vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', '<c-]>', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>n', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    --vim.keymap.set('n', '<space>f', function()
    --  vim.lsp.buf.format { async = true }
    --end, opts)
  end,
})

-- -- Add additional capabilities supported by nvim-cmp
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- Rust: rust_analyzer
-- Python: pylsp
--     pip3 install python-lsp-server
--     pip3 install ruff (fast python linter)
--     pip3 install python-lsp-ruff (python lsp plugin for ruff)
--     pip3 install pylsp-mypy (mypy static checker, .mypy.ini file in $HOME)
-- Golang: gopls
local servers = { 'pylsp', 'gopls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  }
end
EOF

" ===============================================
" nvim-cmp
" https://github.com/hrsh7th/nvim-cmp
" ===============================================
lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['pylsp'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['gopls'].setup {
    capabilities = capabilities
  }
EOF

" ===============================================
" snippet controls
" https://github.com/hrsh7th/vim-vsnip
" ===============================================
" Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" ===============================================
" lualine config
" https://github.com/navarasu/onedark.nvim
" ===============================================
lua <<EOF
require('lualine').setup {
  options = {
    theme = 'onedark'
    -- ... your lualine config
  }
}
EOF

" ===============================================
" trouble
" https://github.com/folke/trouble.nvim
" ===============================================
lua << EOF
  require("trouble").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF
