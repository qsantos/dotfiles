" Vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

" appearance
Plugin 'vim-airline/vim-airline'  " tab and status bars
Plugin 'vim-airline/vim-airline-themes'  " themes for airline
Plugin 'airblade/vim-gitgutter'  " git hunks in left gutter
Plugin 'ryanoasis/vim-devicons'  " filetype icons in airline, CtrlP NERDTree

" commands
Plugin 'tpope/vim-unimpaired'  " ()-based item navigation (error, hunk, conflict)
Plugin 'tpope/vim-fugitive'  " git commands, gb=Git blame
Plugin 'preservim/nerdcommenter'  " comment/uncomment blocks of code, commands start with <leader>c
Plugin 'preservim/nerdtree'  " file browsing, start with C-k
Plugin 'ctrlpvim/ctrlp.vim'  " fuzzy file search window

" syntax
Plugin 'preservim/vim-markdown'  " nice Markdown
Plugin 'ycm-core/YouCompleteMe'  " C, C++, Python, Rust, TypeScript, file paths
Plugin 'leafgarland/typescript-vim'  " TypeScript
Plugin 'wellle/context.vim'  " sticky scroll

call vundle#end()

let mapleader = " "

" appearance
set linebreak showbreak=\\ colorcolumn=100 number norelativenumber background=dark
set nowrap
" Show line endings
set showbreak=↪
" Show non-breaking spaces, tabs, trailing spaces and line wraps
set list listchars=nbsp:~,tab:>-,eol:↲,trail:·,extends:›,precedes:‹
" Update the terminal title to the current file name
set title
" Make that work through tmux as well
if exists('$TMUX')
    autocmd BufEnter * call system("tmux rename-window '" . expand("%:t") . "'")
    autocmd VimLeave * call system("tmux setw automatic-rename")
endif

" this is mostly annoying
" let g:rustfmt_autosave = 1
" a bad interaction with ycm_open_loclist_on_ycm_diags causes the cursor to jump to the last line
" let g:rustfmt_fail_silently = 0
" in any case, it just does not work https://github.com/rust-lang/rust.vim/issues/192

" Syntax highlighting
" Enable spell checking
set spell
" Enable spell checking for CJK languages in addition to the current one
set spelllang+=cjk
" Don’t count e.g. “camelCase” as a spelling error
set spelloptions=camel
syntax on
" Enable TypeScript linting on JavaScript files
au BufNewFile,BufRead *.js setlocal filetype=typescript syntax=javascript
" Use the recommended commit title and text wrapping for git commit messages
au Filetype gitcommit setlocal colorcolumn=51 textwidth=72
" Markdown code blocks <https://www.reddit.com/r/vim/comments/2x5yav/markdown_with_fenced_code_blocks_is_great/>
let g:markdown_fenced_languages = ['c', 'css', 'javascript', 'js=javascript', 'json=javascript', 'html', 'python']
let g:pandoc#syntax#codeblocks#embeds#langs = ['json=javascript', 'ruby', 'python', 'bash=sh']
" <https://tex.stackexchange.com/questions/55397/vim-syntax-highlighting-of-partial-tex-file-used-with-include-is-incorrect>
" <http://www.alecjacobson.com/weblog/?p=1858>
let g:tex_flavor = "latex"

" Fix broken highlighting in large files; see https://vi.stackexchange.com/a/20990
au BufNewFile,BufRead * syntax sync fromstart

" YouCompleteMe
let g:ycm_enable_inlay_hints = 1
" Dumb search-and-replace for the word under the cursor
nnoremap <F1> :%s/\<<C-r><C-w>\>/<C-r><C-w>
" Smart search-and-replace for the word under the cursor
nnoremap <F2> :YcmCompleter RefactorRename<Space>
" Fix the error under the cursor
nnoremap <F3> :YcmCompleter FixIt<CR>
" Go to the definition of the word under the cursor
map ù :YcmCompleter GoTo<CR>
" Go to the definition of the type of the word under the cursor
map gt :YcmCompleter GoToType<CR>
" Display the type of the word under the cursor
map g? :YcmCompleter GetType<CR>
" Go back to the previous location
map ! <C-O>
" nnoremap ù <C-]>
" nnoremap ! <C-t>
" Display the documentation of the word under the cursor
map <F9> :YcmCompleter GetDoc<CR>
" Probably fixes some weird behaviors with YCM
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_always_populate_location_list = 1
" let g:ycm_open_loclist_on_ycm_diags = 1 " no effect?
set completeopt-=preview  " disable scratch window
set completeopt+=longest  " put longest common part of the matches

" indent
filetype plugin indent on
" avoid double indent in parentheses
let g:pyindent_open_paren = '&sw'
let g:pyindent_nested_paren = '&sw'
let g:pyindent_continue = '&sw'
set expandtab shiftwidth=4 tabstop=4 softtabstop=4 autoindent  "indentexpr=

" behavior
set mouse=a " Allow using the mouse to move the cursor, scroll, select visual mode, etc.
set clipboard=unnamedplus " Integrate with the normal clipboard
set modeline  " detect /* vim: noai:ts=4:sw=4 */
set matchpairs+=<:>  " match < and > as well
set nojoinspaces  " single space when joining sentences
set undofile undodir=$HOME/.vim/undo  " persistent undo history
set nobackup nowritebackup noswapfile dir=/tmp  " no temporary files
set wildmode=longest,list,full  " complete paths like Bash
" breaks VS Code
vnoremap p pgvy " keep copy buffer when pasting over in visual mode

" key maps
" Exit insert mode by typing “kj” instead of hitting Escape
" Note: I used “jk” at first as I saw recommended online, by I immediately had
" to type “Dijkstra” many times. I never encountered an issue with “kj” over
" many years.
inoremap kj <Esc>
inoremap Kj <Esc>
inoremap kJ <Esc>
inoremap KJ <Esc>
" navigate buffers (they show as tabs in Airline, but they are not _Vim_ tabs)
map <C-H> :bprev!<CR>
map <C-L> :bnext!<CR>
" navigate tabs
" Vim tabs are actually somewhat weird, you probably don’t want to use that
map <C-G> :tabprev<CR>
map <C-M> :tabnext<CR>
" close buffer but do not close split window
nmap ,d :bn<bar>bd#<CR>
" insert date/time for work log
nnoremap <F5> G$"=strftime("\n\n# %F\n\n- %T ")<CR>pGA
inoremap <F5> <Esc>G$"=strftime("\n\n# %F\n\n- %T ")<CR>pGA
nnoremap <F6> G$"=strftime("\n- %T ")<CR>pGA
inoremap <F6> <Esc>G$"=strftime("\n- %T ")<CR>pGA
nnoremap <F8> :<C-u>call NextError()<CR>

function! NextError()
    try
        lnext
    catch /^Vim\%((\a\+)\)\=:E553:/
        " No more items
        lfirst
    catch /^Vim\%((\a\+)\)\=:E\(42\|776\):/
        " 42: No errors
        " 776: No location list
        try
            cnext
        catch /^Vim\%((\a\+)\)\=:E553:/
            " No more items
            cfirst
        catch /^Vim\%((\a\+)\)\=:E42:/
            echo 'No errors'
        endtry
    endtry
endfunction

" search
set hlsearch incsearch ignorecase smartcase
map <Backspace> :noh<CR>

" folding
set foldmethod=indent nofoldenable foldnestmax=1
set foldopen-=block  " do not unfold when navigating with { or }

" vim-airline
set laststatus=2  " show status bar
let g:airline#extensions#tabline#enabled = 1  " show bar with name of buffers NOTE: slight delay
set lazyredraw  " mitigate slow down due to tabline
let g:airline_powerline_fonts = 1
let g:airline_theme = 'deus'

syntax on
filetype plugin on

" vim-unimpaired
nmap ( [
omap ( [
xmap ( [
nmap ) ]
omap ) ]
xmap ) ]

" NERD Commenter
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1

" NERDTree
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
nmap <C-k> :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=1

" fugitive
nmap gb :Git blame<CR>

" paste mode when terminal-pasting
" https://coderwall.com/p/if9mda/automatically-set-paste-mode-in-vim-when-pasting-in-insert-mode
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
function! XTermPasteBegin()
  set paste pastetoggle=<Esc>[201~
  return ""
endfunction
