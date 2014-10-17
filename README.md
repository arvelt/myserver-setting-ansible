Ansible for individual server studying
---

## Note  
###Sites.  

Repo.  
https://github.com/ansible/ansible

Examples.  
https://github.com/ansible/ansible-examples  

Tutorial in Japanese.  
http://yteraoka.github.io/ansible-tutorial/  

Reusable books.  
https://galaxy.ansible.com/  

Documents.  
http://docs.ansible.com/index.html

### Memo

- hostsというファイルにホスト名とそれらを束ねるグループ名を書いておいてカレントに置き、```ansible-playbook -i hosts site.yml```とやるのが基本

- デフォルトで接続しに行くユーザーは'root'。ユーザーの指定はhostsファイル、実行時の-uオプションで指定する。

- スゴイシェルと思って扱う。とりあえずModlueがあるかを探す。

- メジャーなアプリを入れるならGalaxyにあるかもしれないので探す
  1. ```ansible-galaxy install username.rolename --roles-path /path/to/dir```で任意の場所(rolesの下にあるのが楽だと思う)にインストーすることで使用できる。
  1. 使用時はsite.ymlのrolesで```- {role: username.rolname, variable: 123 }```みたいな感じ


- Book内にパスワード等記載したい場合のやり方。
  1. hash化した値を直接かく。ex( python -c 'import crypt; print crypt.crypt("hogehoge", "$1$SomeSalt$")' )
  1. ansible-vaultを使う。key-valueを記したファイルごと暗号化してくれる
  1. vars_promptで毎回入れる
  1. extra_varsで実行時に指定する。←当Bookで採用


- ansibleはopenssh5.6以前を使うと動作が比較的遅くなる。ひとまず早くするには```[Paramiko] record_host_keys=False```をansible.cfg内で指定する。  
  See http://chopl.in/blog/2014/07/26/set_record_host_keys_to_false.html

- registerを使うと実行した結果を変数として持っておけるのであとで使える

- bundle使うとき。sudoで実行するとエラーになるので、rootでやるとき以外ならおそらく一捻り必要。



## TODO
WIP
