" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch incsearch
endif

"默认关闭鼠标，方便Terminal下操作
if has('mouse')
  set mouse-=a
endif

"当有termguicolors特性时开启GUI配色
if has("termguicolors")
    set termguicolors
endif

" With a map leader it's possible to do extra key combinations
let mapleader=","
" let maplocalleader="\\"

" edit vimrc file quicklly
nnoremap <leader>ev :vsplit $HOME/.vim/vimrc.vim<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

"使用 jk 代替 esc 键 
inoremap jk <esc>

" operation map

" funciton GrepOperator {{{
function! s:GrepOperator(type)
    let saved_unnamed_register = @@
    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif
    
    silent execute "grep! -R " . shellescape(@@) . " ."
    copen

    let @@ = saved_unnamed_register
endfunction " }}}

nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>

" function FoldColumnToggle {{{
function! FoldColumnToggle()
    if &foldcolumn
        setlocal foldcolumn=0
    else
        setlocal foldcolumn=4
    endif
endfunction
" end FoldColumnToggle }}}
nnoremap <leader>f :call FoldColumnToggle()<cr>

onoremap p i(
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap il( :<c-u>normal! F(vi(<cr>

nnoremap <leader>N :setlocal number!<cr>

"代码缩进设置
set smarttab      "开启时，在行首按TAB将加入sw个空格，否则加入ts个空格
set tabstop=4     "编辑时一个TAB字符占多少个空格的位置
set softtabstop=4 "方便在开启了et后使用退格（backspace）键，每次退格将删除X个空格
set shiftwidth=4  "使用每层缩进的空格数
set expandtab     "是否将输入的TAB自动展开成空格。开启后要输入TAB，需要Ctrl-V<TAB>

" Only do this part when compiled with support for autocommands.------{{{
if has("autocmd")
    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on
    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
    autocmd!
    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78
    autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType make setlocal noexpandtab
    autocmd FileType python setlocal expandtab smarttab shiftwidth=4 softtabstop=4
    autocmd FileType c,cpp setlocal shiftwidth=2 tabstop=8 smarttab
    autocmd FileType c,cpp nnoremap <buffer> <localleader>c I//<esc>
    autocmd FileType python nnoremap <buffer> <localleader>c #//<esc>
    autocmd FileType vim setlocal foldmethod=marker
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
    augroup END
else
    set autoindent		" always set autoindenting on
endif " has("autocmd") ------}}}

set history=1024
set number                                       " 显示行号
set autoread                                     " 文件在Vim之外修改过，自动重新读入
set showbreak=↪                                  " 显示换行符
set completeopt=longest,menu                     " 更好的insert模式自动完成
set modeline                                     " 允许被编辑的文件以注释的形式设置Vim选项
set hidden                                       " switching buffers without saving
set ruler                                        " show the cursor position all the time
set showcmd                                      " display incomplete commands
set wildmenu                                     " show enhanced completion
set wildmode=list:longest                        " together with wildmenu
set wildignore+=.git,.svn                    " Version control
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.orig                           " Merge resolution files
set visualbell                                   " flash screen when bell rings
set cursorline                                   " highline cursor line
set ttyfast                                      " indicate faster terminal connection
set laststatus=2                                 " always show status line
set cpoptions+=J
set linebreak                                    " break the line by words
set scrolloff=4                                  " show at least 3 lines around the current cursor position
set sidescroll=1
set sidescrolloff=10
set virtualedit+=block
set lazyredraw
set nolist
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
set splitbelow
set splitright
set fillchars=diff:⣿
" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"

" Resize splits when the window is resized
au VimResized * :wincmd =


"使用F6开关list字符
noremap <F6> :set invlist<CR>:set list?<CR>

"使用F7更新ctags
fun! UpdateCtags()
    !ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .
    echo "Create ctags OK"
endfunction

noremap <F7> :call UpdateCtags()<CR>


"开关YankRing剪贴板缓冲区
nnoremap <F10> :YRShow<CR>

" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

"快速退出vim
nnoremap <C-c> :qall!<CR>

"搜索相关的设置
set showmatch  " show matching brackets/parenthesis
set magic      " 根据vim说明默认开启此参数
set ignorecase " 忽略大小写
set smartcase  " case sensitive when uc present

"清空搜索结果高亮显示
nnoremap <leader>/ :nohlsearch<CR>

"Tab navigation mappings
map tn :tabn<CR>
map tp :tabp<CR>
map tm :tabm
map tt :tabnew<cr>
map ts :tab split<CR>

"Code View Mode
fun! ToggleCodeViewMode()
    if !exists("s:codeviewmode")
        let s:codeviewmode = "0"
    endif

    if s:codeviewmode == "0"
        nmap j jzz
        nmap k kzz
        let s:codeviewmode = "1"
        echo "Code View Mode"
    else
        unmap j
        unmap k
        let s:codeviewmode = "0"
        echo "Code Edit Mode"
    endif
endfunction

command! CodeReview :call ToggleCodeViewMode()

" set text wrapping toggles
nmap <silent> <leader>tw :set invwrap<CR>:set wrap?<CR>

" find merge conflict markers
nmap <silent> <leader>c <ESC>/\v^[<=>]{7}( .*\|$)<CR>

" 在命令行里面, 用%%表示当前文件路径
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>

" 使用系统剪贴板复制粘帖(仅用于Mac)
map <leader>y "+y
map <leader>p "+p

" command mode, ctrl-a to head， ctrl-e to tail
cnoremap <C-j> <t_kd>
cnoremap <C-k> <t_ku>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

"代码折叠相关配置
"    set foldmethod=syntax       "代码折叠 共有6中方式如下
        "1. manual 手工定义折叠
        "2. indent 用缩进表示折叠
        "3. expr　 用表达式来定义折叠
        "4. syntax 用语法高亮来定义折叠
        "5. diff   对没有更改的文本进行折叠
        "6. marker 用标志折叠

"设置菜单和帮助的语言，默认改为英语
set fileencodings=utf-8,gbk "使用utf-8或gbk打开文件
set encoding=utf8
set langmenu=en_us.utf-8
language message en_US.UTF-8
let $LC_ALL='en_US.UTF-8'
let $LANG='en_US.UTF-8'
    
"插件设置

" NERDTree ----------------------------
packadd nerdtree


" Airline ------------------------------
let g:airline_powerline_fonts = 1
let g:airline_detect_paste=1
let g:airline_theme = 'powerlineish'
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#symbol = '!'
let g:airline#extensions#syntastic#enabled = 0
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
"let g:airline#extensions#wordcount#formatter#default#fmt_short = '%sW'
let g:airline#extensions#wordcount#enabled = 0
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.whitespace = 'Ξ'

