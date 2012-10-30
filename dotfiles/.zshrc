# exportexport LANG=ja_JP.UTF-8           # 日本語環境
export EDITOR=/usr/bin/vi
export LESS='-R'
export LESSOPEN='| /usr/local/Cellar/source-highlight/3.1.5/bin/src-hilite-lesspipe.sh %s'
export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
export GREP_OPTIONS="--color=auto"

# zsh
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}' # 大文字小文字を無視
zstyle ':completion:*' format '%BCompleting %d%b'
zstyle ':completion:*' group-name ''
autoload -U compinit              # 強力な補完機能
compinit -u                       # このあたりを使わないとzsh使ってる意味なし
setopt autopushd	          # cdの履歴を表示
setopt pushd_ignore_dups          # 同ディレクトリを履歴に追加しない
setopt auto_cd                    # 自動的にディレクトリ移動
setopt list_packed 		  # リストを詰めて表示
setopt list_types                 # 補完一覧ファイル種別表示
setopt noautomenu                 # タブで補完リストを順に表示しない
setopt no_beep                    # ビープ音を鳴らさないように
setopt magic_equal_subst          # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる

# history
HISTFILE=~/.zsh_history           # historyファイル
HISTSIZE=1000000                  # ファイルサイズ
SAVEHIST=1000000                  # saveする量
setopt hist_ignore_dups           # 重複を記録しない
setopt hist_reduce_blanks         # スペース排除
setopt share_history              # 履歴ファイルを共有
setopt EXTENDED_HISTORY           # zshの開始終了を記録
setopt append_history             # 履歴を追記

# alias
alias emacs='/usr/local/bin/emacs -nw'
alias ls='ls -G'
alias gosh='/usr/local/Cellar/gauche/0.9.2/bin/gosh-rl'
alias history='history -E 1'
alias heroku='/usr/bin/heroku'
alias top=/usr/local/Cellar/htop-osx/0.8.2/bin/htop

# git
alias git='/usr/local/Cellar/git/1.7.8.1/bin/git'
alias g='/usr/local/Cellar/git/1.7.8.1/bin/git'
source /usr/local/Cellar/git/1.7.8.1/etc/bash_completion.d/git-completion.bash

# prompt
local GREEN=$'%{\e[1;32m%}'
local DEFAULT=$'%{\e[m%}'
PROMPT=$GREEN'[${USER}@${HOST%%.*} %1~$(__git_ps1 " (%s)")]%(!.#.$) '$DEFAULT
RPROMPT="%T"                      # 右側に時間を表示する
setopt transient_rprompt          # 右側まで入力がきたら時間を消す
setopt prompt_subst               # 便利なプロント
bindkey -e                        # emacsライクなキーバインド

# ruby
export PATH="$HOME/.rbenv/bin:$PATH"
alias be='/Users/shiino.shunsuke/.rbenv/shims/bundle exec'
eval "$(rbenv init -)"
