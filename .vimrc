"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sections:
"    -> Windows
"    -> Plugins (Vundle)
"    -> Plugin Settings & Bindings
"    -> General
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Moving around, tabs and buffers
"    -> Status line
"    -> Editing mappings
"    -> Spell checking
"    -> Misc
"    -> Helper functions
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Windows
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('win32')
  source $VIMRUNTIME/vimrc_example.vim
  source $VIMRUNTIME/mswin.vim
  behave mswin

  set diffexpr=MyDiff()
  function! MyDiff()
    let opt = '-a --binary '
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    if $VIMRUNTIME =~ ' '
      if &sh =~ '\<cmd'
        if empty(&shellxquote)
          let l:shxq_sav = ''
          set shellxquote&
        endif
        let cmd = '"' . $VIMRUNTIME . '\diff"'
      else
        let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
      endif
    else
      let cmd = $VIMRUNTIME . '\diff'
    endif
    silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
    if exists('l:shxq_sav')
      let &shellxquote=l:shxq_sav
    endif
  endfunction
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins (Vundle)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible              " be iMproved, required
filetype off                  " required
" Set the runtime path to include Vundle and initialize
" Set where Vundle installs plugins:
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/bundle')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Startify: Startup screen with most recent files used and cowsay
Plugin 'mhinz/vim-startify'

" Themes: Molokai, Base16 set, Onedark; (in vim80/colors)
Plugin 'tomasr/molokai'
Plugin 'chriskempson/base16-vim'
Plugin 'joshdick/onedark.vim'

" Airline: Status/tabline
Plugin 'bling/vim-airline'
" Themes for Airline
Plugin 'vim-airline/vim-airline-themes'

" NERDTree: A file explorer
Plugin 'scrooloose/nerdtree'

" Tagbar: A class outline viewer
Plugin 'majutsushi/tagbar'

" Tabular: Text filtering and alignment
Plugin 'godlygeek/tabular'

" Surround: Quoting/parenthesizing made simple
Plugin 'tpope/vim-surround'

" Neocomplete: Auto-code completion
Plugin 'shougo/neocomplete.vim'

" Neosnippet: Code snippets!
Plugin 'Shougo/neosnippet'
" Default snippet collection
Plugin 'Shougo/neosnippet-snippets'
" More snippets
Plugin 'honza/vim-snippets'

" Syntastic: Syntax checking
"Plugin 'scrooloose/syntastic'

" CtrlP: Fuzzy file, buffer, mru, tag, etc. finder
Plugin 'kien/ctrlp.vim'

" NERDCommenter: Awesome commenting
Plugin 'scrooloose/nerdcommenter'

" EasyMotion: Speedy way to move around your file
Plugin 'easymotion/vim-easymotion'

" Fugitive: A Git wrapper
Plugin 'tpope/vim-fugitive'

" VimJavascript: Improved JS indentation & support in Vim
Plugin 'pangloss/vim-javascript'

" SearchIndex: Shows number of search results
Plugin 'google/vim-searchindex'

" RainbowParentheses: Multi-colored parentheses for distinction
Plugin 'luochen1990/rainbow'

" TrailingWhitespace: Causes trailing whitespace to be highlighted in red
Plugin 'bronson/vim-trailing-whitespace'
" Call :FixWhitespace to fix the error


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Settings & Bindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" *---------*
" | Airline |
" *---------*
set laststatus=2  " Let statusline sppear all the time
" Automatically display all buffers when there's only one tab open
let g:airline#extensions#tabline#enabled = 1
" Show just the filenames (not abbreviated directories)
let g:airline#extensions#tabline#fnamemod = ':t'
" Choose theme for Airline
let g:airline_theme='onedark' "simple'  " or onedark?

" *----------*
" | NERDTree |
" *----------*
" Close Vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Show bookmarks whenever NERDTree is open
let NERDTreeShowBookmarks = 1
" Change directory to current file
cd %:p:h
" Map NerdTree to CTRL+n
map <C-n> :NERDTreeToggle<CR>
" F2 opens NerdTree to current buffer's directory
map <F2> :NERDTree %:p:h<CR>

" *--------*
" | Tagbar |
" *--------*
let g:tagbar_ctags_bin = '~/.vim/bundle/tagbar/dependencies/ctags58/ctags.exe'
nmap <F9> :TagbarToggle<CR>

" *-----------*
" | Syntastic |
" *-----------*
" syntax check
"let g:syntastic_c_checkers = ['gcc']
" Recommended settings ... Refer to :help syntastic
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

" *-------*
" | CtrlP |
" *-------*
" Change the default mapping and the default command to invoke CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
" Show buffer list - allows for selection using arrow keys
map <F6> :CtrlPBuffer<CR>
" When invoked, unless a starting directory is specified, CtrlP will set its
"  local working directory according to this variable
let g:ctrlp_working_path_mode = 'ra'
" Exclude files and directories using Vim's wildignore and CtrlP's
"  own g:ctrlp_custom_ignore
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }
" Use a custom file listing command
let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'  " Windows

" *---------------*
" | NERDCommenter |
" *---------------*
" Set \ to toggle comment
map \ <Plug>NERDCommenterToggle
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '//','right': '' } }
"let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" *---------------------*
" | Rainbow Parentheses |
" *---------------------*
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle

" *--------------------*
" | TrailingWhitespace |
" *--------------------*
" See 'Editing mappings' section

" *-------------*
" | Neocomplete |
" *-------------*
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" *------------*
" | Neosnippet |
" *------------*
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set how large the window is on startup
set lines=52 columns=100

" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
"filetype plugin on
"filetype indent on

set autoread " Set to auto read when a file is changed from the outside
set relativenumber " Make line numbers relative
set number " Show line numbers
set modeline " last lines in document sets vim mode
set ek "Enables recognition of arrow key codes

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>
" Fast escape
map <c-c> <Esc>

" :w!! writes the file when you accidentally opened it without the right root priveleges
cmap w!! w !sudo tee % > /dev/null

" Folding
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2
" Close folds with 7
map 7 zc
" Open folds with 8
map 8 zo
" Close all folds with F7
map <F7> zM
" Open all folds with F8
map <F8> zR


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 5 lines to the cursor - when moving vertically using j/k
set so=5

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Turn on the WiLd menu
set wildmenu
" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"Always show current position
set ruler

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase
" When searching try to be smart about cases
set smartcase
" Highlight search results
set hlsearch
" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Add a bit extra margin to the left
"set foldcolumn=1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark

" Enable syntax highlighting
syntax enable

" Colorscheme
colorscheme molokai

" Set font
set guifont=DejaVu\ Sans\ Mono:h10

" GUI options (gVim)
if has("gui_running")
  set guioptions-=T  " gvim remove toolbar
  set guioptions-=m  " gvim remove menu bar
  set guioptions-=r  " gvim remove rhand scrollbar
  set guioptions-=L  " gvim remove lhand scrollbar
  set t_Co=256  " 256 color mode
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Choose the standard file type
if has('win32')
  set ffs=dos,unix
elseif has('unix')
  set ffs=unix,dos
endif

" Turn backup off, since most stuff is in SVN, git etc anyway...
set nobackup
set nowb
set noswapfile
set noundofile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == x spaces
set shiftwidth=2
set tabstop=2

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
set textwidth=80

" Python configurations
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" *-----------*
" | SEARCHING |
" *-----------*
" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" *---------*
" | BUFFERS |
" *---------*
" Open a new buffer
map <leader>bn :enew<CR>

" Move between buffers
map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" List all current buffers
":nnoremap <F6> :buffers<CR>:buffer<Space>

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>

" *--------------*
" | TABS/WINDOWS |
" *--------------*
" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Useful mappings for managing tabs
map <F10> :vsplit<CR>
map <F11> :split<CR>
map <F12> :close<CR>
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" *------*
" | MISC |
" *------*
" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Copy selection into operating system's register
map <leader>y "*y

" Clear whitespace at the end of lines
map <leader><Space> :FixWhitespace<CR>

" Open vimrc for editing
map <leader><F12> :e $MYVIMRC<CR>
" Refresh vimrc
noremap <F5> :so %<CR>

" Remap VIM 0 to first non-blank character
map 0 ^
" 9 moves to the last character in a line
map 9 $

" Insert date and time
iab xdate <c-r>=strftime("%a %b %d %H:%M:%S %Y %Z")<cr>

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,sc will toggle and untoggle spell checking
map <leader>sc :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"function! CmdLine(str)
"   exe "menu Foo.Bar :" . a:str
"   emenu Foo.Bar
"   unmenu Foo
"endfunction

function! VisualSelection(direction, extra_filter) range
   let l:saved_reg = @"
   execute "normal! vgvy"

   let l:pattern = escape(@", "\\/.*'$^~[]")
   let l:pattern = substitute(l:pattern, "\n$", "", "")

   if a:direction == 'gv'
       call CmdLine("Ag '" . l:pattern . "' " )
   elseif a:direction == 'replace'
       call CmdLine("%s" . '/'. l:pattern . '/')
   endif

   let @/ = l:pattern
   let @" = l:saved_reg
endfunction


" Returns true if paste mode is enabled
function! HasPaste()
   if &paste
       return 'PASTE MODE  '
   endif
   return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")

  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif

  if bufnr("%") == l:currentBufNum
    new
  endif

  if buflisted(l:currentBufNum)
    execute("bdelete! ".l:currentBufNum)
  endif
endfunction

" Make VIM remember position in file after reopen
" if has("autocmd")
"   au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif
