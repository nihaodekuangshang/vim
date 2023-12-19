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
make
sudo make install
```

# 前置

1.NERDFonts

2.nodejs >14

3.gtags

4.Pygments

`pip install Pygments`


# 安装过程：

1. `git clone  https://github.com/nihaodekuangshang/vim.git  ~/.vim`
2. 执行`PlugInstall`

3. ```
   cd ~/.vim/plugged/coc.nvim/ 
   nvm ci
   ```
