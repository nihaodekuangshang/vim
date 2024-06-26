vim9script
#======================================================================
#
# init-plugins.vim - 
#
# Created by skywind on 2018/05/31
# Last Modified: 2018/06/10 23:11
#
#======================================================================
# vim: set ts=4 sw=4 tw=78 noet :



#----------------------------------------------------------------------
# 默认情况下的分组，可以再前面覆盖之
#----------------------------------------------------------------------
if !exists('g:bundle_group')
	g:bundle_group = ['basic', 'tags', 'enhanced', 'filetypes', 'textobj']
	g:bundle_group += ['tags', 'airline', 'nerdtree', 'ale', 'echodoc']
	g:bundle_group += ['leaderf']
endif


#----------------------------------------------------------------------
# 计算当前 vim-init 的子路径
#----------------------------------------------------------------------
var home = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')

def  Path(path: string): string
	var path2 = expand( home .. '/' .. path )
	return substitute(path2, '\\', '/', 'g')
enddef


#----------------------------------------------------------------------
# 在 ~/.vim/bundles 下安装插件
#----------------------------------------------------------------------
call plug#begin(get(g:, 'bundle_home', '~/.vim/bundles'))


#----------------------------------------------------------------------
# 默认插件 
#----------------------------------------------------------------------

# 全文快速移动，<leader><leader>f{char} 即可触发
Plug 'easymotion/vim-easymotion'

# 文件浏览器，代替 netrw
Plug 'justinmk/vim-dirvish'

# 表格对齐，使用命令 Tabularize
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }

# Diff 增强，支持 histogram / patience 等更科学的 diff 算法
Plug 'chrisbra/vim-diff-enhanced'


#----------------------------------------------------------------------
# Dirvish 设置：自动排序并隐藏文件，同时定位到相关文件
# 这个排序函数可以将目录排在前面，文件排在后面，并且按照字母顺序排序
# 比默认的纯按照字母排序更友好点。
#----------------------------------------------------------------------
def  Setup_dirvish()
	if &buftype != 'nofile' && &filetype != 'dirvish'
		return
	endif
	if has('nvim')
		return
	endif
	# 取得光标所在行的文本（当前选中的文件名）
	let text = getline('.')
	if ! get(g:, 'dirvish_hide_visible', 0)
		exec 'silent keeppatterns g@\v[\/]\.[^\/]+[\/]?$@d _'
	endif
	# 排序文件名
	exec 'sort ,^.*[\/],'
	let name = '^' . escape(text, '.*[]~\') . '[/*|@=|\\*]\=\%($\|\s\+\)'
	# 定位到之前光标处的文件
	call search(name, 'wc')
	noremap <silent><buffer> ~ :Dirvish ~<cr>
	noremap <buffer> % :e %
enddef

augroup MyPluginSetup
	autocmd!
	autocmd FileType dirvish call  Setup_dirvish()
augroup END


#----------------------------------------------------------------------
# 基础插件
#----------------------------------------------------------------------
if index(g:bundle_group, 'basic') >= 0

	# 展示开始画面，显示最近编辑过的文件
	Plug 'mhinz/vim-startify'

	# 一次性安装一大堆 colorscheme
	Plug 'flazz/vim-colorschemes'

	# 支持库，给其他插件用的函数库
	Plug 'xolox/vim-misc'

	# 用于在侧边符号栏显示 marks （ma-mz 记录的位置）
	Plug 'kshenoy/vim-signature'

	# 用于在侧边符号栏显示 git/svn 的 diff
	Plug 'mhinz/vim-signify'

	# 根据 quickfix 中匹配到的错误信息，高亮对应文件的错误行
	# 使用 :RemoveErrorMarkers 命令或者 <space>ha 清除错误
	Plug 'mh21/errormarker.vim'

	# 使用 ALT+e 会在不同窗口/标签上显示 A/B/C 等编号，然后字母直接跳转
	Plug 't9md/vim-choosewin'

	# 提供基于 TAGS 的定义预览，函数参数预览，quickfix 预览
	Plug 'skywind3000/vim-preview'

	# Git 支持
	Plug 'tpope/vim-fugitive'

	# 使用 ALT+E 来选择窗口
	nmap <m-e> <Plug>(choosewin)

	# 默认不显示 startify
	g:startify_disable_at_vimenter = 1
	g:startify_session_dir = '~/.vim/session'

	# 使用 <space>ha 清除 errormarker 标注的错误
	noremap <silent><space>ha :RemoveErrorMarkers<cr>

	# signify 调优
	g:signify_vcs_list = ['git', 'svn']
	g:signify_sign_add               = '+'
	g:signify_sign_delete            = '_'
	g:signify_sign_delete_first_line = '‾'
	g:signify_sign_change            = '~'
	g:signify_sign_changedelete      = g:signify_sign_change

	# git 仓库使用 histogram 算法进行 diff
	g:signify_vcs_cmds = {
			 'git': 'git diff --no-color --diff-algorithm=histogram --no-ext-diff -U0 -- %f',
			}
endif


#----------------------------------------------------------------------
# 增强插件
#----------------------------------------------------------------------
if index(g:bundle_group, 'enhanced') >= 0

	# 用 v 选中一个区域后，ALT_+/- 按分隔符扩大/缩小选区
	Plug 'terryma/vim-expand-region'

	# 快速文件搜索
	Plug 'junegunn/fzf'

	# 给不同语言提供字典补全，插入模式下 c-x c-k 触发
	Plug 'asins/vim-dict'

	# 使用 :FlyGrep 命令进行实时 grep
	Plug 'wsdjeg/FlyGrep.vim'

	# 使用 :CtrlSF 命令进行模仿 sublime 的 grep
	Plug 'dyng/ctrlsf.vim'

	# 配对括号和引号自动补全
	Plug 'Raimondi/delimitMate'

	# 提供 gist 接口
	Plug 'lambdalisue/vim-gista', { 'on': 'Gista' }
	
	# ALT_+/- 用于按分隔符扩大缩小 v 选区
	map <m-=> <Plug>(expand_region_expand)
	map <m--> <Plug>(expand_region_shrink)
endif


#----------------------------------------------------------------------
# 自动生成 ctags/gtags，并提供自动索引功能
# 不在 git/svn 内的项目，需要在项目根目录 touch 一个空的 .root 文件
# 详细用法见：http //zhuanlan.zhihu.com/p/36279445
#----------------------------------------------------------------------
if index(g:bundle_group, 'tags') >= 0

	# 提供 ctags/gtags 后台数据库自动更新功能
	Plug 'skywind3000/vim-gutentags'

	# 提供 GscopeFind 命令并自动处理好 gtags 数据库切换
	# 支持光标移动到符号名上：<leader>cg 查看定义，<leader>cs 查看引用
	Plug 'skywind3000/gutentags_plus'

	# 设定项目目录标志：除了 .git/.svn 外，还有 .root 文件
	g:gutentags_project_root = ['.root']
	g:gutentags_ctags_tagfile = '.tags'

	# 默认生成的数据文件集中到 ~/.cache/tags 避免污染项目目录，好清理
	g:gutentags_cache_dir = expand('~/.cache/tags')

	# 默认禁用自动生成
	g:gutentags_modules = [] 

	# 如果有 ctags 可执行就允许动态生成 ctags 文件
	if executable('ctags')
		g:gutentags_modules += ['ctags']
	endif

	# 如果有 gtags 可执行就允许动态生成 gtags 数据库
	if executable('gtags') && executable('gtags-cscope')
		g:gutentags_modules += ['gtags_cscope']
	endif

	# 设置 ctags 的参数
	g:gutentags_ctags_extra_args = []
	g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
	g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
	g:gutentags_ctags_extra_args += ['--c-kinds=+px']

	# 使用 universal-ctags 的话需要下面这行，请反注释
	# g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

	# 禁止 gutentags 自动链接 gtags 数据库
	g:gutentags_auto_add_gtags_cscope = 0
endif


#----------------------------------------------------------------------
# 文本对象：textobj 全家桶
#----------------------------------------------------------------------
if index(g:bundle_group, 'textobj') >= 0

	# 基础插件：提供让用户方便的自定义文本对象的接口
	Plug 'kana/vim-textobj-user'

	# indent 文本对象：ii/ai 表示当前缩进，vii 选中当缩进，cii 改写缩进
	Plug 'kana/vim-textobj-indent'

	# 语法文本对象：iy/ay 基于语法的文本对象
	Plug 'kana/vim-textobj-syntax'

	# 函数文本对象：if/af 支持 c/c++/vim/java
	Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim', 'java'] }

	# 参数文本对象：i,/a, 包括参数或者列表元素
	Plug 'sgur/vim-textobj-parameter'

	# 提供 python 相关文本对象，if/af 表示函数，ic/ac 表示类
	Plug 'bps/vim-textobj-python', {'for': 'python'}

	# 提供 uri/url 的文本对象，iu/au 表示
	Plug 'jceb/vim-textobj-uri'
endif


#----------------------------------------------------------------------
# 文件类型扩展
#----------------------------------------------------------------------
if index(g:bundle_group, 'filetypes') >= 0

	# powershell 脚本文件的语法高亮
	Plug 'pprovost/vim-ps1', { 'for': 'ps1' }

	# lua 语法高亮增强
	Plug 'tbastos/vim-lua', { 'for': 'lua' }

	# C++ 语法高亮增强，支持 11/14/17 标准
	Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }

	# 额外语法文件
	Plug 'justinmk/vim-syntax-extra', { 'for': ['c', 'bison', 'flex', 'cpp'] }

	# python 语法文件增强
	Plug 'vim-python/python-syntax', { 'for': ['python'] }

	# rust 语法增强
	Plug 'rust-lang/rust.vim', { 'for': 'rust' }

	# vim org-mode 
	Plug 'jceb/vim-orgmode', { 'for': 'org' }
endif


#----------------------------------------------------------------------
# airline
#----------------------------------------------------------------------
if index(g:bundle_group, 'airline') >= 0
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	g:airline_left_sep = ''
	g:airline_left_alt_sep = ''
	g:airline_right_sep = ''
	g:airline_right_alt_sep = ''
	g:airline_powerline_fonts = 0
	g:airline_exclude_preview = 1
	g:airline_section_b = '%n'
	g:airline_theme = 'deus'
	g:airline#extensions#branch#enabled = 0
	g:airline#extensions#syntastic#enabled = 0
	g:airline#extensions#fugitiveline#enabled = 0
	g:airline#extensions#csv#enabled = 0
	g:airline#extensions#vimagit#enabled = 0
endif


#----------------------------------------------------------------------
# NERDTree
#----------------------------------------------------------------------
if index(g:bundle_group, 'nerdtree') >= 0
	Plug 'scrooloose/nerdtree', {'on': ['NERDTree', 'NERDTreeFocus', 'NERDTreeToggle', 'NERDTreeCWD', 'NERDTreeFind'] }
	Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
	g:NERDTreeMinimalUI = 1
	g:NERDTreeDirArrows = 1
	g:NERDTreeHijackNetrw = 0
	noremap <space>nn :NERDTree<cr>
	noremap <space>no :NERDTreeFocus<cr>
	noremap <space>nm :NERDTreeMirror<cr>
	noremap <space>nt :NERDTreeToggle<cr>
endif


#----------------------------------------------------------------------
# LanguageTool 语法检查
#----------------------------------------------------------------------
if index(g:bundle_group, 'grammer') >= 0
	Plug 'rhysd/vim-grammarous'
	noremap <space>rg :GrammarousCheck --lang=en-US --no-move-to-first-error --no-preview<cr>
	map <space>rr <Plug>(grammarous-open-info-window)
	map <space>rv <Plug>(grammarous-move-to-info-window)
	map <space>rs <Plug>(grammarous-reset)
	map <space>rx <Plug>(grammarous-close-info-window)
	map <space>rm <Plug>(grammarous-remove-error)
	map <space>rd <Plug>(grammarous-disable-rule)
	map <space>rn <Plug>(grammarous-move-to-next-error)
	map <space>rp <Plug>(grammarous-move-to-previous-error)
endif


#----------------------------------------------------------------------
# ale：动态语法检查
#----------------------------------------------------------------------
if index(g:bundle_group, 'ale') >= 0
	Plug 'w0rp/ale'

	# 设定延迟和提示信息
	g:ale_completion_delay = 500
	g:ale_echo_delay = 20
	g:ale_lint_delay = 500
	g:ale_echo_msg_format = '[%linter%] %code: %%s'

	# 设定检测的时机：normal 模式文字改变，或者离开 insert模式
	# 禁用默认 INSERT 模式下改变文字也触发的设置，太频繁外，还会让补全窗闪烁
	g:ale_lint_on_text_changed = 'normal'
	g:ale_lint_on_insert_leave = 1

	# 在 linux/mac 下降低语法检查程序的进程优先级（不要卡到前台进程）
	if has('win32') == 0 && has('win64') == 0 && has('win32unix') == 0
		g:ale_command_wrapper = 'nice -n5'
	endif

	# 允许 airline 集成
	g:airline#extensions#ale#enabled = 1

	# 编辑不同文件类型需要的语法检查器
	g:ale_linters = {
				\ 'c': ['gcc', 'cppcheck'], 
				\ 'cpp': ['gcc', 'cppcheck'], 
				\ 'python': ['flake8', 'pylint'], 
				\ 'lua': ['luac'], 
				\ 'go': ['go build', 'gofmt'],
				\ 'java': ['javac'],
				\ 'javascript': ['eslint'], 
				\ }


	# 获取 pylint, flake8 的配置文件，在 vim-init/tools/conf 下面
	def  Lintcfg(name: string): string
		var conf =  Path('tools/conf/')
		var path1 = conf .. name
		var path2 = expand('~/.vim/linter/' .. name)
		if filereadable(path2)
			return path2
		endif
		return shellescape(filereadable(path2) ? path2 : path1)
	enddef

	# 设置 flake8/pylint 的参数
	g:ale_python_flake8_options = '--conf=' ..  Lintcfg('flake8.conf')
	g:ale_python_pylint_options = '--rcfile=' .. Lintcfg('pylint.conf')
	g:ale_python_pylint_options ..= ' --disable=W'
	g:ale_c_gcc_options = '-Wall -O2 -std=c99'
	g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
	g:ale_c_cppcheck_options = ''
	g:ale_cpp_cppcheck_options = ''

	g:ale_linters.text = ['textlint', 'write-good', 'languagetool']

	# 如果没有 gcc 只有 clang 时（FreeBSD）
	if executable('gcc') == 0 && executable('clang')
		g:ale_linters.c += ['clang']
		g:ale_linters.cpp += ['clang']
	endif
endif


#----------------------------------------------------------------------
# echodoc：搭配 YCM/deoplete 在底部显示函数参数
#----------------------------------------------------------------------
if index(g:bundle_group, 'echodoc') >= 0
	Plug 'Shougo/echodoc.vim'
	set noshowmode
	g:echodoc#enable_at_startup = 1
endif


#----------------------------------------------------------------------
# LeaderF：CtrlP / FZF 的超级代替者，文件模糊匹配，tags/函数名 选择
#----------------------------------------------------------------------
if index(g:bundle_group, 'leaderf') >= 0
	# 如果 vim 支持 python 则启用  Leaderf
	if has('python') || has('python3')
		Plug 'Yggdroot/LeaderF'

		# CTRL+p 打开文件模糊匹配
		g:Lf_ShortcutF = '<c-p>'

		# ALT+n 打开 buffer 模糊匹配
		g:Lf_ShortcutB = '<m-n>'

		# CTRL+n 打开最近使用的文件 MRU，进行模糊匹配
		noremap <c-n> :LeaderfMru<cr>

		# ALT+p 打开函数列表，按 i 进入模糊匹配，ESC 退出
		noremap <m-p> :Leaderffunction<cr>

		# ALT+SHIFT+p 打开 tag 列表，i 进入模糊匹配，ESC退出
		noremap <m-P> :LeaderfBufTag!<cr>

		# ALT+n 打开 buffer 列表进行模糊匹配
		noremap <m-n> :LeaderfBuffer<cr>

		# ALT+m 全局 tags 模糊匹配
		noremap <m-m> :LeaderfTag<cr>

		# 最大历史文件保存 2048 个
		g:Lf_MruMaxFiles = 2048

		# ui 定制
		g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }

		# 如何识别项目目录，从当前文件目录向父目录递归知道碰到下面的文件/目录
		g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
		g:Lf_WorkingDirectoryMode = 'Ac'
		g:Lf_WindowHeight = 0.30
		g:Lf_CacheDirectory = expand('~/.vim/cache')

		# 显示绝对路径
		g:Lf_ShowRelativePath = 0

		# 隐藏帮助
		g:Lf_HideHelp = 1

		# 模糊匹配忽略扩展名
		g:Lf_WildIgnore = {
					 'dir': ['.svn', '.git', '.hg'],
					 'file': ['*.sw?', '~$*', '*.bak', '*.exe', '*.o', '*.so', '*.py[co]']
					 }

		# MRU 文件忽略扩展名
		g:Lf_MruFileExclude = ['*.so', '*.exe', '*.py[co]', '*.sw?', '~$*', '*.bak', '*.tmp', '*.dll']
		g:Lf_StlColorscheme = 'powerline'

		# 禁用 function/buftag 的预览功能，可以手动用 p 预览
		g:Lf_PreviewResult = {'Function': 0, 'BufTag': 0}

		# 使用 ESC 键可以直接退出 leaderf 的 normal 模式
		g:Lf_NormalMap = {
				\ "File":   [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
				\ "Buffer": [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<cr>']],
				\ "Mru": [["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<cr>']],
				\ "Tag": [["<ESC>", ':exec g:Lf_py "tagExplManager.quit()"<cr>']],
				\ "BufTag": [["<ESC>", ':exec g:Lf_py "bufTagExplManager.quit()"<cr>']],
				\ "Function": [["<ESC>", ':exec g:Lf_py "functionExplManager.quit()"<cr>']],
				\ }

	else
		# 不支持 python ，使用 CtrlP 代替
		Plug 'ctrlpvim/ctrlp.vim'

		# 显示函数列表的扩展插件
		Plug 'tacahiroy/ctrlp-funky'

		# 忽略默认键位
		g:ctrlp_map = ''

		# 模糊匹配忽略
		g:ctrlp_custom_ignore = {
		  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
		  \ 'file': '\v\.(exe|so|dll|mp3|wav|sdf|suo|mht)$',
		  \ 'link': 'some_bad_symbolic_links',
		  \ }

		# 项目标志
		g:ctrlp_root_markers = ['.project', '.root', '.svn', '.git']
		g:ctrlp_working_path = 0

		# CTRL+p 打开文件模糊匹配
		noremap <c-p> :CtrlP<cr>

		# CTRL+n 打开最近访问过的文件的匹配
		noremap <c-n> :CtrlPMRUFiles<cr>

		# ALT+p 显示当前文件的函数列表
		noremap <m-p> :CtrlPFunky<cr>

		# ALT+n 匹配 buffer
		noremap <m-n> :CtrlPBuffer<cr>
	endif
endif

#----------------------------------------------------------------------
# 按键提示
#----------------------------------------------------------------------
Plug 'liuchengxu/vim-which-key'

#----------------------------------------------------------------------
#  为语言提供补全
#----------------------------------------------------------------------
Plug 'neoclide/coc.nvim' , {'branch': 'release'}

#----------------------------------------------------------------------
#  为c系语言提供补全
#----------------------------------------------------------------------

# Plug 'ycm-core/YouCompleteMe'


#----------------------------------------------------------------------
# 结束插件安装
#----------------------------------------------------------------------
call plug#end()



#----------------------------------------------------------------------
# YouCompleteMe 默认设置：YCM 需要你另外手动编译安装
#----------------------------------------------------------------------

# 禁用预览功能：扰乱视听
g:ycm_add_preview_to_completeopt = 0

# 禁用诊断功能：我们用前面更好用的 ALE 代替
g:ycm_show_diagnostics_ui = 0
g:ycm_server_log_level = 'info'
g:ycm_min_num_identifier_candidate_chars = 2
g:ycm_collect_identifiers_from_comments_and_strings = 1
g:ycm_complete_in_strings = 1
g:ycm_key_invoke_completion = '<c-z>'
set completeopt=menu,menuone,noselect

# noremap <c-z> <NOP>

# 两个字符自动触发语义补全
g:ycm_semantic_triggers =  {
			 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
			 'cs,lua,javascript': ['re!\w{2}'],
			 }


#----------------------------------------------------------------------
# Ycm 白名单（非名单内文件不启用 YCM），避免打开个 1MB 的 txt 分析半天
#----------------------------------------------------------------------
g:ycm_filetype_whitelist = { 
			 "c": 1,
			 "cpp": 1, 
			 "objc": 1,
			 "objcpp": 1,
			 "python": 1,
			 "java": 1,
			 "javascript": 1,
			 "coffee": 1,
			 "vim": 1, 
			 "go": 1,
			 "cs": 1,
			 "lua": 1,
			 "perl": 1,
			 "perl6": 1,
			 "php": 1,
			 "ruby": 1,
			 "rust": 1,
			 "erlang": 1,
			 "asm": 1,
			 "nasm": 1,
			 "masm": 1,
			 "tasm": 1,
			 "asm68k": 1,
			 "asmh8300": 1,
			 "asciidoc": 1,
			 "basic": 1,
			 "vb": 1,
			 "make": 1,
			 "cmake": 1,
			 "html": 1,
			 "css": 1,
			 "less": 1,
			 "json": 1,
			 "cson": 1,
			 "typedscript": 1,
			 "haskell": 1,
			 "lhaskell": 1,
			 "lisp": 1,
			 "scheme": 1,
			 "sdl": 1,
			 "sh": 1,
			 "zsh": 1,
			 "bash": 1,
			 "man": 1,
			 "markdown": 1,
			 "matlab": 1,
			 "maxima": 1,
			 "dosini": 1,
			 "conf": 1,
			 "config": 1,
			 "zimbu": 1,
			 "ps1": 1,
			 }


# -----------------------------config.coc--------------------------------------

g:coc_global_extensions = [
	'coc-clangd',
	'coc-marketplace', 
	'coc-vimlsp',
	'coc-json',
	'coc-rust-analyzer',
	'coc-toml',
	'coc-sh',
	'coc-deno',
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



#----------------------------------------------------------------------
# WhichKey 配置
#----------------------------------------------------------------------

#-----------------------------------------------------------------------
# 基础配置
#-----------------------------------------------------------------------


# By default timeoutlen is 1000 ms
set timeoutlen=500

# 启用
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

#-----------------------------------------------------------------------
#配置提示词
#-----------------------------------------------------------------------
g:which_key_map = {}
g:which_key_map['b'] = {
       'name': '+buffer',
       '1': [':buffer 1', 'open buffer 1'],
       '2': [':buffer 2', 'open buffer 2'],
       '3': [':buffer 3', 'open buffer 3'],
       '4': [':buffer 4', 'open buffer 4'],
       '5': [':buffer 5', 'open buffer 5'],
       '6': [':buffer 6', 'open buffer 6'],
       '7': [':buffer 7', 'open buffer 7'],
       '8': [':buffer 8', 'open buffer 8'],
       '9': [':buffer 9', 'open buffer 9'],
       'n': [':bn', 'open next buffer'],
       'p': [':bp', 'open previous buffer'],
       'f': [':bf', 'open first buffer'],
       'l': [':bl', 'open latest buffer'],
       'd': [':bd', 'delete buffer'],
       }
g:which_key_map['c'] = {
       'name': '+tags coc',
       'l': ['<cmd>CocList marketplace<CR>',  'open coc marketplace'],
       }

g:which_key_map['g'] = {
       'name': '+Goto code',
       'p': ['<Plug>(coc-diagnostic-prev)',  'goto previous error'],
       'n': ['<Plug>(coc-diagnostic-next)',  'goto next error'],
       'd': ['<Plug>(coc-definition)',  'goto symbol definition'],
       'y': ['<Plug>(coc-type-definition)',  'goto type definition'],
       'i': ['<Plug>(coc-implementation)',  'goto implementation'],
       'r': ['<Plug>(coc-references)',  'goto symbol references'],
       }
g:which_key_map['n'] = {
       'name': '+nerdtree',
       'n': [':NERDTree<cr>',  'Opens a fresh NERDTree.'],
       'o': [':NERDTreeFocus<cr>',  'open visible NERDTree,if already open move curse this NERDTree'],
       'm': [':NERDTreeMirror<cr>',  'in currently tab,shares NERDTree from another tab.Changes is sync'],
	   't': [':NERDTreeToggle<cr>',  'if exists,open;else,new'],
       }
g:which_key_map['t'] = {
       'name': '+tab +terminal +tree',
       '1': [':tabnext 1', 'open tab 1'],
       '2': [':tabnext 2', 'open tab 2'],
       '3': [':tabnext 3', 'open tab 3'],
       '4': [':tabnext 4', 'open tab 4'],
       '5': [':tabnext 5', 'open tab 5'],
       '6': [':tabnext 6', 'open tab 6'],
       '7': [':tabnext 7', 'open tab 7'],
       '8': [':tabnext 8', 'open tab 8'],
       '9': [':tabnext 9', 'open tab 9'],
       'n': [':tabnext', 'open next tab'],
       'p': [':tabprevious', 'open previous tab'],
       'c': [':tabclose', 'close tab'],
       'e': [':ter', 'open terminal'],
       }
g:which_key_map['p'] = {
       'name': '+plug +project',
       'i': ['<cmd>PlugInstall<CR>', 'install plugin'],
       'u': ['<cmd>PlugUpdate<CR>', 'update plug'],
       'c': ['<cmd>PlugClean<CR>', 'clean plug'],
       'b': ['<cmd>AsyncTask project-build <CR', 'build with glob config'],
       'r': ['<cmd>AsyncTask project-run <CR>',  'run with glob config']
       }
g:which_key_map['f'] = {
       'name': '+file',
       'b': ['<cmd>AsyncTask file-build <CR', 'build with project config'],
       'r': ['<cmd>AsyncTask file-run <CR>',  'run with project config'],
       'e': ['<cmd>AsyncTaskEdit <CR>',  'edit the project config']
       }
which_key#register('<Space>', "g:which_key_map")
