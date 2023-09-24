# インストールについて

## diff-highlightコマンドの場所

diff-highlightは環境によって複数の場所に配置されている。

|環境|パス|
|:--:|:--|
|ubuntu|`/usr/share/doc/git/contrib/diff-highlight/diff-highlight`|
|WSL|`/usr/share/doc/git/contrib/diff-highlight/diff-highlight`|
|macOS(system)|`/usr/local/share/git-core/contrib/diff-highlight/diff-highlight`|
|macOS(brew)|`/usr/local/Cellar/git/{version}/share/git-core/contrib/diff-highlight/diff-highlight`|

## diff-highlightを実行する

gitを介してdiff-highlightを実行するが、`/usr`下はPATHに含まれていない。  
経穴する方法は２種類ある。

- 該当するパスを`$PATH`に加える
- 実行権限があるパスからアクセスできるようにする

### PATHに加える方法

diff-highlightディレクトリには以下のファイルが含まれている。  

```terminal
$ ll /usr/share/doc/git/contrib/diff-highlight/
total 40K
drwxr-xr-x 2 root root 4.0K 23-01-04 06:41:21 t/
-rw-r--r-- 1 root root 6.9K 21-11-25 04:29:21 DiffHighlight.pm
-rw-r--r-- 1 root root  395 21-11-25 04:29:21 Makefile
-rw-r--r-- 1 root root 7.9K 21-11-25 04:29:21 README
-rw-r--r-- 1 root root 7.2K 22-10-13 21:33:36 diff-highlight
-rw-r--r-- 1 root root  211 21-11-25 04:29:21 diff-highlight.perl
-rw-r--r-- 1 root root   16 22-10-13 21:33:36 shebang.perl
```

PATHに加えるということは、これらも実行可能になってしまう。

> 2023年、成果物は管理されなくなり、`make`が必要になってしまった。。。

### 実行権限のあるパスからアクセスできるようにする

方法としては、実ファイルをコピーするかシンボリックリンクを作成する。  
ただし、コピーにせよシンボリックリンクにせよ、その動作にwriteの権限が必要である。  
しかし、`/usr/local/bin/`にeveryoneのwrite権限を付与するのは危険である。

つまり、ホームディレクトリ下にユーザー限定の`bin`ディレクトリを作って解決することが多い。  
命名は`$HOME/bin`もしくは`$HOME/.local/bin`が多い。  
`$HOME/bin`はディストリビューションによってはデフォルトでパスに張っていることもあるらしい（ChatGPT談
