frontend regression test(get diffs)
==========================

## 使い方
画像のスクショを撮る方法
```bash
# PCスクショとスマホスクショ両方
bundle exec ruby capture.rb {tag} {protocol+domain} {filename_list}

# PCスクショのみ
bundle exec ruby capture_pc.rb {tag} {protocol+domain} {filename_list}

# スマホスクショのみ
bundle exec ruby capture_sp.rb {tag} {protocol+domain} {filename_list}

# サンプル(2019/01/06 動作確認)
bundle exec ruby capture.rb test_meti http://www.meti.go.jp lists/sample_meti.txt 
  # screenshot/test_meti/ に画像が保存されます。
```

画像の差分を確認する方法
```bash
bundle exec ruby diff.rb screenshot/{tag_1} screenshot/{tag_2}
```
以下ディレクトリに諸々置かれる。
screenshot/image_diff/{tag_1}__vs__{tag_2}
- log.csv(差分があるものは、どれくらい差分が出るか%で表示される。ないものはno_diffと表示される)
- 画像ファイル(差分が表示される)

## 事前準備(環境構築)
なお、今回はamazonlinux2を利用している。
色々、事前に依存パッケージが入っていた可能性もあるので、動かない場合は別途対応で。（もしくは連絡ください）

### install chrome
```bash
yum install https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
yum install ipa-gothic-fonts
```

### install chromedriver
```bash
cd /usr/local/src
wget http://chromedriver.storage.googleapis.com/2.45/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
ln -s /usr/local/src/chromedriver /usr/local/bin/
```

### install ruby
```bash
amazon-linux-extras install ruby2.4
yum install ruby ruby-devel libxml2-devel libxslt-devel rpm-build gcc-c++ ImageMagick ImageMagick-devel
```

### install gems
```bash
gem install rdoc
gem install bundler
```

### 適当なディレクトリにて
```bash
git clone https://github.com/fk1jp/regtest_capybara.git
cd regtest_capybara
bundle install
```

## 参考ページ
[リクルートさんの実装](https://tech.recruit-mp.co.jp/front-end/post-6786/)をパクりました。
ただ、[PhantomJSじゃなくseleniumがいいらしい](https://ohbarye.hatenablog.jp/entry/2018/03/10/232300)ので、その辺りの設定を変えました。
