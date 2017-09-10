" Sections:
"   -> Plugins (Vundle)
"   -> Plugin Settings
"   -> General
"   -> Colors and Fonts
"   -> Mappings
"   -> Abbreviations/auto-complete


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins (Vundle)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
call plug#begin('~/.vim/plugged')

" Startify: Startup screen with most recent files used and cowsay
Plug 'mhinz/vim-startify'

" Colorschemes:
Plug 'ajmwagar/vim-deus'
Plug 'tomasr/molokai'

" Airline: Status/tabline
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes' " Themes for Airline

" NERDTree: A file explorer
Plug 'scrooloose/nerdtree'

" Tagbar: A class outline viewer
Plug 'majutsushi/tagbar'

" Tabular: Text filtering and alignment
Plug 'godlygeek/tabular'

" Surround: Quoting/parenthesizing made simple
Plug 'tpope/vim-surround'

if has('nvim')
  " Deoplete: Asynchronous auto-completion
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

  " Maybe get some more completion sources later:
  "  https://github.com/Shougo/deoplete.nvim/wiki/Completion-Sources
else
  " Neocomplete: Auto-code-completion
  Plugin 'shougo/neocomplete.vim'

  " Neosnippet: Code snippets!
  Plug 'Shougo/neosnippet'
  Plug 'Shougo/neosnippet-snippets' " Default snippet collection
  Plug 'honza/vim-snippets' " More snippets
endif

" NERDCommenter: Awesome commenting
Plug 'scrooloose/nerdcommenter'

" ALE: Asynchronous lint engine
"Plug 'w0rp/ale'

" EasyMotion: Speedy way to move around your file
Plug 'easymotion/vim-easymotion'

" Fugitive: A Git wrapper
Plug 'tpope/vim-fugitive'

" SearchIndex: Shows number of search results
Plug 'google/vim-searchindex'

" RainbowParentheses: Multi-colored parentheses for distinction
Plug 'luochen1990/rainbow'

" TrailingWhitespace: Causes trailing whitespace to be highlighted in red
Plug 'bronson/vim-trailing-whitespace'
call plug#end()

" Put your non-Plugin stuff after this line


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" *---------*
" | Airline |
" *---------*
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
" Show hidden files (e.g. dotfiles)
let NERDTreeShowHidden = 1
" Change directory to current file
cd %:p:h
" Ignore files of certain types
let NERDTreeIgnore=['\.bin$', '\.exe$', '\.pdf$', '\.doc$', '\.docx$', '\.odt$',
  \ '\.class$', '\.pptx$', '\.pptm$', '\.xls$', '\.xlsx$', '\.xlsm$', '\.gdoc$',
  \ '\.gsheet$', '\.gslides$', '\.psd$', '\.png$', '\.svg$', '\.raw$', '\.mp3$',
  \ '\.jpg$', '\.jpeg$', '\.mp4$', '\.avi$', '\.url$', '\.cap$', 'desktop.ini$',
  \ '\.blf$', 'Thumbs.db$', 'ntuser.ini$', '\.regtrans-ms$', '\.ogg$', '\.mkv$',
  \ '\.flac$', '\.webm$', '\.zip$', '\.tar.gz$', '\.rar$', '\.log1$', '\.log2$',
  \ '\.dat$', '\.gif$', '\.dll$']

" *--------*
" | Tagbar |
" *--------*
" Locate Exuberant Ctags installation (must be installed manually)
if has('win32')
  let g:tagbar_ctags_bin = '~/.vim/plugged/tagbar/ctags58/ctags.exe'
elseif has('unix')
  let g:tagbar_ctags_bin = '~/.vim/plugged/tagbar/ctags-5.8/ctags'
endif
" Fix Tagbar window width to be less intrusive (thinner)
let g:tagbar_width = 30

" *---------------*
" | NERDCommenter |
" *---------------*
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = {
    \ 'c': { 'left': '//','right': '' },
    \ 'java': { 'left': '//','right': '' } }
"let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" *-----*
" | ALE |
" *-----*
let g:ale_open_list = 1 " Show the list of errors
let g:ale_list_window_size = 4 " Resize the error window

let g:ale_lint_on_text_changed = 'never' " Only lint on save (limits CPU use)

" *----------*
" | Fugitive |
" *----------*
set diffopt=vertical " Split screen down the middle during 'git diff'

" *---------------------*
" | Rainbow Parentheses |
" *---------------------*
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle

" *----------*
" | Deoplete |
" *----------*
if has('nvim')
  " Use deoplete
  let g:deoplete#enable_at_startup = 1

  " Tab completion
  inoremap <expr><Tab> pumvisible() ? "\<C-N>" : "\<Tab>"
  inoremap <expr><S-Tab> pumvisible() ? "\<C-P>" : "\<S-Tab>"
endif

" *-------------*
" | Neocomplete |
" *-------------*
if !has('nvim')
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
endif

" *------------*
" | Neosnippet |
" *------------*
if !has('nvim')
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
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('gvim')
  set lines=52 columns=100 " Set the size of the window on startup
endif

set number " Show line numbers
set relativenumber " Make line numbers relative
set laststatus=2  " Always show the status line
set ruler " Always show current position
set mouse=a " Enable mouse

syntax on " Enable syntax highlighting

set history=500 " Sets how many lines of history VIM has to remember

set autoread " Set to auto read when a file is changed from the outside
set modeline " Last lines in document sets vim mode
if !has('nvim')
  set esckeys " Enables recognition of arrow key codes
endif

set backspace=eol,start,indent " Configure backspace so it acts as it should act
set scrolloff=5 " Set x lines to the cursor - when moving vertically using j/k
set whichwrap+=<,>,h,l " Move around lines easier

set hidden " A buffer becomes hidden when it is abandoned

" Enable filetype plugins
"filetype plugin on

" :w!! writes the file when you accidentally opened it w/o the right priveleges
"cmap w!! w !sudo tee % > /dev/null

" Folding code
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2

" Turn on the WiLd menu
set wildmenu
" Ignore files of certain types
set wildignore=*.o,*~,*.pyc,*.bin,*.exe,*.pdf,*.doc,*.docx,*.odt,*.class,*.pptx,
  \*.pptm,*.xls,*.xlsx,*.xlsm,*.gdoc,*.gsheet,*.gslides,*.psd,*.png,*.svg,*.raw,
  \*.mp3,*.jpg,*.jpeg,*.mp4,*.avi,*.url,*.cap,desktop.ini,*.blf,Thumbs.db,
  \ntuser.ini,*.regtrans-ms,*.ogg,*.webm,*.flac,*.mkv,*.zip,*.tar.gz,*.rar,
  \*.dat,*.log1,*.log2,*.gif,*.dll
if has("win16") || has("win32")
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Searching
set ignorecase " Ignore case when searching
set smartcase " When searching try to be smart about cases
set hlsearch " Highlight search results
set incsearch " Makes search act like search in modern browsers
set magic " For regular expressions turn magic on

" Line break & word wrap
set linebreak
set textwidth=80
set wrap " Wrap lines

" Tabbing & indentation
set shiftwidth=2 " 1 tab = x spaces
set softtabstop=2
set tabstop=2
set expandtab " Use spaces instead of tabs
set smarttab
set autoindent
set smartindent

" Python tabbing & indentation configuration
au BufNewFile,BufRead *.py
   \ set tabstop=2 |
   \ set softtabstop=2 |
   \ set shiftwidth=2

" Choose the standard file type
if has('win32')
  set ffs=dos,unix
elseif has('unix')
  set ffs=unix,dos
endif

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set showtabline=2
catch
endtry

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Turn backup off, since most stuff is in SVN, git etc anyway...
set nobackup
set nowb
set noswapfile
set noundofile

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Misc
set showmatch " Show matching brackets when text indicator is over them
set matchtime=2 " How many tenths of a second to blink when matching brackets

set lazyredraw " Don't redraw while executing macros (good performance config)

if has('nvim') " Allow for escape from terminal mode in neovim
  tnoremap <Esc> <C-\><C-n>
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set guifont=DejaVu\ Sans\ Mono:h10

if has('gvim')
  colorscheme deus
  " Make sure background is /very/ black
  highlight Normal guibg=black
endif

" GUI options (gVim)
if has("gui_running")
  set guioptions-=T " gvim remove toolbar
  set guioptions-=m " gvim remove menu bar
  set guioptions-=r " gvim remove rhand scrollbar
  set guioptions-=L " gvim remove lhand scrollbar
  set t_Co=256 " 256 color mode
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set the <leader> key, allowing for more key combinations
let mapleader = ","
let g:mapleader = ","

" Fast saving
nmap <leader>w :update!<CR>

" Copy and paste selections into operating system's register
if has('win32') " and maybe gvim?
  map <leader>y "*y
  map <leader>Y "*Y
  map <leader>p "*p
  map <leader>P "*P
else " if has('unix')
  map <leader>y "+y
  map <leader>Y "+Y
  map <leader>p "+p
  map <leader>P "+P
endif

" 0 moves to first non-blank character
map 0 ^
" 9 moves to the last character in a line
map 9 $

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<CR>:pwd<CR>

" Open vimrc for editing
map <leader><F12> :e $MYVIMRC<CR>

" Refresh vimrc using F5 (when open and in focus)
autocmd Filetype vim nnoremap <buffer> <F5> :so %<CR>

" Compile files using F5 (when open and in focus)
autocmd Filetype c,cpp  nnoremap <buffer> <F5> :update
  \<Bar>execute '!make     '.shellescape(expand('%:r'), 1)<CR>
autocmd Filetype python nnoremap <buffer> <F5> :update
  \<Bar>execute '!python   '.shellescape(@%, 1)<CR>
autocmd Filetype java   nnoremap <buffer> <F5> :update
  \<Bar>execute '!javac    '.shellescape(@%, 1)<CR>
autocmd Filetype tex    nnoremap <buffer> <F5> :update
  \<Bar>cd %:p:h
  \<Bar>execute '!pdflatex '.shellescape(@%, 1)<CR>

" *---------*
" | BUFFERS |
" *---------*
" Open a new buffer
map <leader>bn :enew<CR>

" Move between buffers
map <leader>l :bnext<CR>
map <leader>h :bprevious<CR>

" Close the current buffer
map <leader>bd :Bclose<CR>

command! Bclose call <SID>BufcloseCloseIt() " Don't close window when deleting buffer
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

" *--------------*
" | TABS/WINDOWS |
" *--------------*
" Window management
map <F10> :split<CR>
map <F11> :vsplit<CR>
map <F12> :close<CR>

" Window navigation
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Window resize (based on upper-left-most window)
map <C-S-Right> :vertical resize +1<CR>
map <C-S-Left> :vertical resize -1<CR>
map <C-S-Down> :resize +1<CR>
map <C-S-Up> :resize -1<CR>

" *---------*
" | FOLDING |
" *---------*
" Close folds with 7
map 7 zc
" Open folds with 8
map 8 zo
" Close all folds with F7
map <F7> zM
" Open all folds with F8
map <F8> zR

" *-----------*
" | SEARCHING |
" *-----------*
" Disable highlight when <leader><CR> is pressed
map <silent> <leader><CR> :noh<CR>

" Pressing * or # searches for the current selection
" Super useful! Idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

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

function! CmdLine(str)
  exe "menu Foo.Bar :" . a:str
  emenu Foo.Bar
  unmenu Foo
endfunction

" *-------------*
" | PLUGIN MAPS |
" *-------------*
" Startify
map <leader>e :Startify<CR>

" NERDTree (F2 opens to current buffer's directory)
map <C-n> :NERDTreeToggle<CR>
map <F2> :NERDTree %:p:h<CR>

" Tagbar
nmap <F3> :TagbarToggle<CR>

" NERDCommenter (\ toggles comments)
map \ <Plug>NERDCommenterToggle

" Fugitive
map <leader>gs :Gstatus<CR>
map <leader>gd :Gdiff<CR>
map <leader>gc :Gcommit -m
map <leader>gp :Gpush<CR>

" TrailingWhitespace
map <leader><Space> :FixWhitespace<CR>

" *-------------*
" | SPELL CHECK |
" *-------------*
" Pressing ,sc will toggle and untoggle spell checking
map <leader>sc :setlocal spell!<CR>
" Go to next misspelled word
map <leader>sn ]s
" Go to previous misspelled word
map <leader>sp [s
" Add word to dictionary
map <leader>sa zg
" Make a correction to a misspelled word
map <leader>s? z=

" *------*
" | MISC |
" *------*
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><CR>//ge<CR>'tzt'm

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Abbreviations/auto-complete
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto-curly-brackets
inoremap {<CR>  {<CR>}<Esc>O

" Insert date and time
iab xdate <C-r>=strftime("%a %b %d %H:%M:%S %Y %Z")<CR>

