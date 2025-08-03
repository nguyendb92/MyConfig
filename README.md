## Here is config for vscode + vim
- vscode folder: contain config for vscode and vim extension
- vim folder: config for vim and automation script for install and config vim

# install

- run command:
```sh
  git clone https://github.com/nguyendb92/MyConfig.git
  cd MyConfig
  chmod +x setup_vim.sh
  ./setup_vim.sh
```
- source config:
  > source ~/.vimrc
- install plugin:
  > :PlugInstall
- set colors:
  > :colorscheme molokai

```
    nnoremap – Allows you to map keys in normal mode.
    inoremap – Allows you to map keys in insert mode.
    vnoremap – Allows you to map keys in visual mode.
```

- Auto install and config for new machine:
```sh
  git clone https://github.com/nguyendb92/MyConfig.git
  cd MyConfig
  chmod +x auto_setup.sh
  ./auto_setup.sh.sh
```