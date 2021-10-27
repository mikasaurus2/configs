" Copy this file to ~/.config/nvim/init.vim

" ===============================================
" Plugins
" ===============================================

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

" NerdTree directory browser
" git and dev icons for NerdTree (need special font)
Plug 'preservim/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin' |
            \ Plug 'ryanoasis/vim-devicons' |
            \ Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" color schemes
Plug 'flazz/vim-colorschemes'
" enhanced c++ syntax highlighting
Plug 'octol/vim-cpp-enhanced-highlight'
" airline status bar
Plug 'vim-airline/vim-airline'
" airline status bar themes
Plug 'vim-airline/vim-airline-themes'
" fuzzy finder (fzf)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" easier commenting
Plug 'tpope/vim-commentary'
" fugitive git wrapper
Plug 'tpope/vim-fugitive'
" rust
Plug 'rust-lang/rust.vim'
" syntax checker
Plug 'vim-syntastic/syntastic'
" Track the snippet engine.
Plug 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'
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
autocmd Filetype python map <buffer> <C-l> :Black<cr>

" ripgrep
nnoremap <Leader>r :Rg
" fugitive git commands
nnoremap <Leader>g :G
" neovim terminal
nnoremap <Leader>z :vnew<CR>:terminal<CR>isource $HOME/.bash_profile<CR>
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
nnoremap <silent> <Leader>s :Snippets<CR>

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
colorscheme mike_onedark
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

" syntax checker
" ctrl-s to run checker
map <C-s> :SyntasticCheck<CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_mode_map = {
    \ "mode": "passive",
    \ "active_filetypes": [],
    \ "passive_filetypes": [] }
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

" ===============================================
" Language Server Config
" https://github.com/neovim/nvim-lspconfig
" ===============================================

lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  --buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  --buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  --buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  --buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  --buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  --buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pylsp' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF
