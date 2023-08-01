vim9script

var home = fnamemodify('.', ':p:h')
command! -nargs=1 LoardScript  execute("so " .. home .. "/" .. <args>)


# ------------------------------plugin------------------
call plug#begin('~/.vim/plugged')
# 美化
Plug 'whatyouhide/gotham'
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
# 字典
Plug 'skywind3000/vim-dict'
# 字典级补全
# keymap 待配置
Plug 'skywind3000/vim-auto-popmenu'
# 行级格式化
Plug 'skywind3000/vim-rt-format'
# build-run 任务系统
# keymap 待配置
Plug 'skywind3000/asynctasks.vim'
# 编译运行
# keymap 待配置
Plug 'skywind3000/asyncrun.vim'
# lsp 
# keymap 待配置
Plug 'neoclide/coc.nvim', {'branch': 'release'}

# 根据文件改动自动生成 ctags 数据，自动更新 gtags 数据，
Plug 'ludovicchabant/vim-gutentags'

#(gtags) 在每次 GscopeFind 前处理数据库加载问题，已经加载过的数据库不会重复加载，非本项目的数据库会得到即时清理
#	<leader>cg - 查看光标下符号的定义
#	<leader>cs - 查看光标下符号的引用
#	<leader>cc - 查看有哪些函数调用了该函数
#	<leader>cf - 查找光标下的文件
#	<leader>ci - 查找哪些文件 include 了本文件
Plug 'skywind3000/gutentags_plus'

#(gtags) 在 quickfix 中先快速预览所有符号查询的结果
# keymap 待配置
Plug 'skywind3000/vim-preview'
# 语义检查
Plug 'dense-analysis/ale'

call plug#end()

   

# -----------------------------config.colorscheme---------------------------------
  colorscheme gotham256

  # -----------------------------config.are---------------------------------

g:ale_linters_explicit = 1
g:ale_completion_delay = 500
g:ale_echo_delay = 20
g:ale_lint_delay = 500
g:ale_echo_msg_format = '[%linter%] %code: %%s'
g:ale_lint_on_text_changed = 'normal'
g:ale_lint_on_insert_leave = 1
g:airline#extensions#ale#enabled = 1

g:ale_c_gcc_options = '-Wall -O2 -std=c11'
g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
g:ale_c_cppcheck_options = ''
g:ale_cpp_cppcheck_options = ''

g:ale_linters = {
	'rust': ['analyzer']
}

# -----------------------------config.nerdtree---------------------------------
var NERDTreeShowHidden = 1



# -----------------------------config.coc--------------------------------------

g:coc_global_extensions = [
	'coc-marketplace', 
	'coc-vimlsp',
	'coc-json',
	'coc-clangd',
	'coc-rust-analyzer',
	'coc-toml',
	]

# 允许coc在为保存的情况下跳转，通过buffer实现
set hidden

# " May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
# " utf-8 byte sequence
# set encoding=utf-8
# " Some servers have issues with backup files, see #649
# set nobackup
# set nowritebackup
# 
# " Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
# " delays and poor user experience
 set updatetime=100
# 
# " Always show the signcolumn, otherwise it would shift the text each time
# " diagnostics appear/become resolved
set signcolumn=yes
# 
# 使用TAB补全
# " Use tab for trigger completion with characters ahead and navigate
# " NOTE: There's always complete item selected by default, you may want to enable
# " no select by `"suggest.noselect": true` in your configuration file
# " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
# " other plugin before putting this into your config
# def CheckBackspace(): bool
#    var col = col('.') - 1
#    return !col || getline('.')[col - 1]  =~# '\s'
# enddef
# inoremap <silent><expr> <TAB>
#        coc#pum#visible() ? coc#pum#next(1) :
#        CheckBackspace() ? "\<Tab>" :
#        coc#refresh()
 inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

# 按回车选择
# " Make <CR> to accept selected completion item or notify coc.nvim to format
# " <C-g>u breaks current undo, please make your own choice
 inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>"
# inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r> = coc#on_enter()\<CR>"
# 
# " Use <c-space> to trigger completion
  inoremap <silent><expr> <leader>go coc#refresh()
# 
# 在报错信息间跳转
# " Use `[g` and `]g` to navigate diagnostics
# " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> <leader>gp <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>gn <Plug>(coc-diagnostic-next)
# 
# 跳转
# " GoTo code navigation
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)
# 
# " Use K to show documentation in preview window
# nnoremap <silent> <leader>gs :vim9cmd ShowDocumentation()<CR>
# 
# def ShowDocumentation()
#   if CocAction('hasProvider', 'hover')
#     call CocActionAsync('doHover')
#   else
#     call feedkeys('K', 'in')
#   endif
# enddef
# 
# 高亮与光标下相同的词
# " Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')
# 
# " Symbol renaming
# nmap <leader>rn <Plug>(coc-rename)
# 
# " Formatting selected code
# xmap <leader>f  <Plug>(coc-format-selected)
# nmap <leader>f  <Plug>(coc-format-selected)
# 
# augroup mygroup
#   autocmd!
#   " Setup formatexpr specified filetype(s)
#   autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
#   " Update signature help on jump placeholder
#   autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
# augroup end
# 
# " Applying code actions to the selected code block
# " Example: `<leader>aap` for current paragraph
# def CocActionOpenFromSelected(type: string)
# 	execute 'CocCommand actions.open' .. type
# enddef
# xmap <silent> <leader>a :<c-u> execute 'CocCommand actions.open' .. visualmode()<CR>
# nmap <silent> <leader>a :<c-u> set operatorfunc=<SID>CocActionOpenFromSelected<CR>g@
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
# 
# " Remap keys for applying code actions at the cursor position
# nmap <leader>ac  <Plug>(coc-codeaction-cursor)
# " Remap keys for apply code actions affect whole buffer
# nmap <leader>as  <Plug>(coc-codeaction-source)
# " Apply the most preferred quickfix action to fix diagnostic on the current line
# nmap <leader>qf  <Plug>(coc-fix-current)
# 
# " Remap keys for applying refactor code actions
# nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
# xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
# nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
# 
# " Run the Code Lens action on the current line
# nmap <leader>cl  <Plug>(coc-codelens-action)
# 
# " Map function and class text objects
# " NOTE: Requires 'textDocument.documentSymbol' support from the language server
# xmap if <Plug>(coc-funcobj-i)
# omap if <Plug>(coc-funcobj-i)
# xmap af <Plug>(coc-funcobj-a)
# omap af <Plug>(coc-funcobj-a)
# xmap ic <Plug>(coc-classobj-i)
# omap ic <Plug>(coc-classobj-i)
# xmap ac <Plug>(coc-classobj-a)
# omap ac <Plug>(coc-classobj-a)
# 
# " Remap <C-f> and <C-b> to scroll float windows/popups
# if has('nvim-0.4.0') || has('patch-8.2.0750')
#   nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
#   nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
#   inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
#   inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
#   vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
#   vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
# endif
# 
# " Use CTRL-S for selections ranges
# " Requires 'textDocument/selectionRange' support of language server
# nmap <silent> <C-s> <Plug>(coc-range-select)
# xmap <silent> <C-s> <Plug>(coc-range-select)
# 
# " Add `:Format` command to format current buffer
# command! -nargs=0 Format :call CocActionAsync('format')
# 
# " Add `:Fold` command to fold current buffer
# command! -nargs=? Fold :call     CocAction('fold', <f-args>)
# 
# " Add `:OR` command for organize imports of the current buffer
# command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
# 
# " Add (Neo)Vim's native statusline support
# " NOTE: Please see `:h coc-status` for integrations with external plugins that
# " provide custom statusline: lightline.vim, vim-airline
# set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
# 
# " Mappings for CoCList
# " Show all diagnostics
# nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
# " Manage extensions
# nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
# " Show commands
# nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
# " Find symbol of current document
# nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
# " Search workspace symbols
# nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
# " Do default action for next item
# nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
# " Do default action for previous item
# nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
# " Resume latest coc list
# nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

# -----------------------------config.gutentags---------------------------------

# gutentags 搜索工程目录的标志，当前文件路径向上递归直到碰到这些文件/目录名
g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

# 所生成的数据文件的名称
g:gutentags_ctags_tagfile = '.tags'

# 同时开启 ctags 和 gtags 支持：
g:gutentags_modules = []
if executable('ctags')
	g:gutentags_modules += ['ctags']
endif
if executable('gtags-cscope') && executable('gtags')
	g:gutentags_modules += ['gtags_cscope']
endif

# 将自动生成的 ctags/gtags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
g:gutentags_cache_dir = expand('~/.cache/tags')

# 配置 ctags 的参数，老的 Exuberant-ctags 不能有 --extra=+q，注意
# g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
# g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
# g:gutentags_ctags_extra_args += ['--c-kinds=+px']

# 如果使用 universal ctags 需要增加下面一行，老的 Exuberant-ctags 不能加下一行
# g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

# 禁用 gutentags 自动加载 gtags 数据库的行为
g:gutentags_auto_add_gtags_cscope = 0

#------------------------------config.gtags-------------------------------------

#默认 C/C++/Java 等六种原生支持的代码直接使用 gtags 本地分析器，而其他语言使用 pygments 模块。
$GTAGSLABEL = 'native-pygments'
# 方便寻找 native-pygments 和 language map 的定义，
$GTAGSCONF = '/usr/local/share/gtags/gtags.conf'



# -----------------------------config.vim-auto-popmenu--------------------------
# 设定需要生效的文件类型，如果是 "*" 的话，代表所有类型
g:apc_enable_ft = {'text': '1', 'markdown': '1', 'php': '1', 's': '1', 'S': '1',
	'asm': '1', 'ld': '1'}

# 设定从字典文件以及当前打开的文件里收集补全单词，详情看 ':help cpt'
set cpt=.,k,w,b

# 不要自动选中第一个选项。
set completeopt=menu,menuone,noselect

# 禁止在下方显示一些啰嗦的提示
set shortmess+=c

# -------------------------------config.vim-rt-format--------------------------

# 默认在 INSERT 模式下按 ENTER 格式化当前代码行，将下面设置
# 成 1 的话，可以用 CTRL+ENTER 来格式化，ENTER 将保留原来的功能

g:rtf_ctrl_enter = 0

# 离开 INSERT 模式的时候再格式化一次

g:rtf_on_insert_leave = 1


# -------------------------------config.asyn---------------------------------

# 启用
g:asyncrun = 6


# 如何确定根目录
g:asyncrun_rootmarks = ['.git', '.svn', '.root', '.project', '.hg']


# 当output为终端时，在下方打开内置终端
g:asynctasks_term_pos = 'bottom'

# -------------------------------basic-------------------------------------------

# 关闭vi兼容性
set nocompatible
# 允许在自动缩进、换行符、插入开始位置退格
set backspace=indent,eol,start
# 开启行号和相对行号
set nu
set relativenumber
# 设置显示不可见字符及其颜色
set list lcs=tab:-->
hi TabSpace  guifg=darkgrey ctermfg=darkgrey
match TabSpace /\t\| /

syntax on

set showmode
set showcmd

# 开启鼠标
#set mouse=a
set mouse= 

# 开启自动缩进
set autoindent
#按下 Tab 键时，Vim 显示的空格数 
set tabstop=4
# 在文本上按下>>（增加一级缩进）、<<（取消一级缩进）或者==（取消全部缩进）时，每一级的字符数。
set shiftwidth=4

# 设置光标行高亮
set cursorline
# 行宽 80
set textwidth=80

# 开启自动折行并只在特殊符号时才折行
set wrap
set linebreak


# 显示状态栏。在状态栏显示光标的当前位置
set laststatus=2

set  ruler

# 高亮显示对应的括号
set showmatch


# 保留撤销历史记录 
set undofile

# Vim 需要记住多少次历史操作。
set history=1000

# 在编辑过程中文件发生外部改变（比如被别的编辑器编辑了），就会发出提示。
set autoread

# 命令模式下，底部操作指令按下 Tab 键自动补全。第一次按下 Tab，会显示所有匹配的操作指令的清单；第二次按下 Tab，会依次选择各个指令
set wildmenu
set wildmode=longest:list,full

# 自动切换工作目录
set autochdir

# 开启真彩色
set termguicolors

# ---------------maping------------------------------------------

g:mapleader = " "

nmap <leader>tt <cmd>NERDTreeToggle<CR>
nnoremap <silent> <leader>cl <cmd>CocList marketplace<CR>


nnoremap <silent> <leader>pi <cmd>PlugInstall<CR>
nnoremap <silent> <leader>pu <cmd>PlugUpdate<CR>
nnoremap <silent> <leader>pc <cmd>PlugClean<CR>


nnoremap <silent> <leader>fb <cmd>AsyncTask file-build <CR>

nnoremap <silent> <leader>fr <cmd>AsyncTask file-run <CR>

nnoremap <silent> <leader>pb <cmd>AsyncTask project-build <CR>

nnoremap <silent> <leader>pr <cmd>AsyncTask project-run <CR>

tnoremap <silent> <ESC>   <C-\><C-n>
nnoremap <silent> <leader>te :ter<CR>



nnoremap <silent> <leader>bd :bd<CR>
nnoremap <silent> <leader>bn :bn<CR>
nnoremap <silent> <leader>bp :bp<CR>
nnoremap <silent> <leader>bf :bf<CR>
nnoremap <silent> <leader>bl :bl<CR>
nnoremap <silent> <leader>1 :buffer 1<CR>
nnoremap <silent> <leader>2 :buffer 2<CR>
nnoremap <silent> <leader>3 :buffer 3<CR>
nnoremap <silent> <leader>4 :buffer 4<CR>
nnoremap <silent> <leader>5 :buffer 5<CR>
nnoremap <silent> <leader>6 :buffer 6<CR>
nnoremap <silent> <leader>7 :buffer 7<CR>
nnoremap <silent> <leader>8 :buffer 8<CR>
nnoremap <silent> <leader>9 :buffer 9<CR>


nnoremap <silent> <leader>tc :tabclose<CR>
nnoremap <silent> <leader>tn :tabnext<CR>
nnoremap <silent> <leader>tp :tabprevious<CR>
nnoremap <silent> <leader>t1 :tabnext 1<CR>
nnoremap <silent> <leader>t2 :tabnext 2<CR>
nnoremap <silent> <leader>t3 :tabnext 3<CR>
nnoremap <silent> <leader>t4 :tabnext 4<CR>
nnoremap <silent> <leader>t5 :tabnext 5<CR>
nnoremap <silent> <leader>t6 :tabnext 6<CR>
nnoremap <silent> <leader>t7 :tabnext 7<CR>
nnoremap <silent> <leader>t8 :tabnext 8<CR>
nnoremap <silent> <leader>t9 :tabnext 9<CR>

