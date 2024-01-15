### 使用vim-plug

# 推荐使用编译安装的方式安装最新版vim
`git clone https://github.com/vim/vim.git`

更新本地的vim为最新版
```
cd vim
git pull
```
构建和安装vim
```
cd vim/src
make distclean  # if you build Vim before
./configure --enable-python3interp=yes
make
sudo make install
```

# 前置

1.NERDFonts

[hasklig](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hasklig.zip)

2.nodejs >14

[教程](https://learn.microsoft.com/zh-cn/windows/dev-environment/javascript/nodejs-on-wsl)

3.gtags

推荐编译安装 [下载地址](https://ftp.gnu.org/pub/gnu/global/)

4.python模块

* Pygments

* autopep8


# 安装过程：

1. `git clone  https://github.com/nihaodekuangshang/vim.git  ~/.vim`
2. 执行`PlugInstall`

3. ```
   cd ~/.vim/plugged/coc.nvim/ 
   nvm ci
   ```


# 排查错误

1. gtags

   判断 gtags 为何失败，需进一步打开日志，查看 gtags 的错误输出：

   `let g:gutentags_define_advanced_commands = 1`

   先在 vimrc 中添加上面这一句话，允许 gutentags 打开一些高级命令和选项。然后打开你出错的源文件，运行 “:GutentagsToggleTrace”命令打开日志，它会将 ctags/gtags 命令的输出记录在 Vim 的 message 记录里。接着保存一下当前文件，触发 gtags 数据库更新，稍等片刻你应该能看到一些讨厌的日志输出，然后当你碰到问题时在 vim 里调用 ":messages" 命令列出所有消息记录，即可看到 gtags 的错误输出，方便你定位。



