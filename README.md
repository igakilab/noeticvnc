# noeticvnc
- ROS1-noeticとVNC
- ROS及びWindowsホスト-コンテナ内ROS間通信がうまくいくことか未確認

## 準備
- このリポジトリ全体のReadme.mdをみて，WSL2とDockerのセットアップを行うこと

### コンテナのビルド及び実行
- Windows Terminalでnoeticcvncにcdし，下記コマンドを実行する
```sh
$ cd noeticvnc
$ docker-compose build
```
- かなり時間がかかります
- 本番ではビルドしたものをDocker Hubにアップロードして使えるようにする予定
- ビルドが成功したら下記コマンドでコンテナを実行する

```sh
$ docker-compose up
```
- バックグラウンド起動したい場合は `-d` をつける

### アクセス方法
- コンテナ実行した後，http://localhost:8000 にブラウザでアクセスする
  - ubuntuのデスクトップにアクセスできるので，Terminalを起動して必要な処理を呼び出す
- localhost:5900 を対象に通常のVNCクライアントでもアクセスできる
  - RealVNCで動作検証済み．コピペ等も問題なくできるっぽい
  - https://www.realvnc.com/en/connect/download/viewer/
- VNCクライアントが無い場合，`docker exec -it melodicvnc bash` でubuntuユーザでbashでログインできる
- vscodeのRemote Containersプラグインを利用して/home/ubuntu にアクセス可能．

## 動作確認

### stage_rosの確認
- 下記参照
  - https://github.com/KMiyawaki/oit_stage_ros
- うまくいくとrvizでstage_rosのrobotを動かせます
  - https://www.dropbox.com/s/dfyomeleswnx8y5/2021-02-19%2011-46-16.mp4?dl=0

### ToDo
- novncのデフォルト設定をLocalScalingにしたい
- 画像処理等その他のテーマについての実装環境をどうするか
- コピペがnovncのClip BoardUIを介さないとだめっぽいのが何とかならないか．．->コピペ等したい場合はVNCクライアントで5900にアクセスすればいける
- 起動後にnovncの設定で Scaling Modeを `Local Scaling` に変更するとブラウザサイズに合わせて画面サイズが変更される．解像度設定を確認しておく

### Done
- Timezoneの設定をどうするか検討
  - docker-compose.ymlを修正するだけでいけることを確認した
- vscodeとの連携
  - Windows側にvscodeをインストールして，Remote Developmentで接続して実装する方法を試す
  - vscodeからymlを指定してコンテナにアクセスする方法だと，コンテナ内のファイルへのアクセスに失敗した．`docker-compose up` でコンテナを起動してからそれを選択する方法だといけた
    - こちらでいけることは確認できた．vscodeのターミナルがrootにログインしてしまうのもubuntuをデフォルトにすることで対応済み
- ~localhost:2000でsshdがListenしているので，sshクライアントでubuntu:ubuntuにアクセスできる．~
  - Remote Containersではssh不要なのでsshdもインストールしないことにした
- `docker exec -it --user ubuntu noeticvnc bash` でubuntuユーザでbashでログインできる
  - デフォルトをubuntuユーザになるように変更したので，--userは不要になった
- ~eclipse Theiaの導入~(重くなりすぎるのでひとまず導入しない方向で）
  -   - https://qiita.com/yosuke@github/items/328dbd778047499828f2#%E3%81%AF%E3%81%98%E3%82%81%E3%81%AB
- ~/catkin_ws を永続化し，初期化するように修正してみた
  - ボリュームの中身を一度全部消したい場合は `docker-compose down --rmi local --volumes --remove-orphans` このあたりでvolume削除すればOK


This software includes the work that is distributed in the Apache License 2.0.

このソフトウェアは、 Apache 2.0ライセンスで配布されている製作物が含まれています。
