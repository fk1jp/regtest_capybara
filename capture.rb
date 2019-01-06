# 先ほどのファイルをインポート
require "./spec/spec_helper"

# 保存先ディレクトリにコミットIDでフォルダを作ってスクリーンショットを保存する
#commit_id = `git rev-parse HEAD`.chomp
commit_id = "#{ ARGV[0] || "hoge" }"
save_path = "screenshot/" + commit_id + "/"

session = Capybara::Session.new(:selenium)
session_sp = Capybara::Session.new(:selenium_sp)

# getでアクセスで表示したいページのurl配列
# pages = [
#   "pickup/6309115",
#   "pickup/6309141"
# ]
# 
pages = [
  ""
]

pages = File.open(ARGV[2]).read.split("\n") || pages 

# スクショ済みページをスキップする
skip_exist_pagees_pc = []
skip_exist_pagees_sp = []

Dir::glob(save_path+"*").each {|f|
  next if f.match("'/\.gif$|\.png$|\.jpg$|\.jpeg$|\.bmp$/i'").nil?
  file_name = File.basename(f)
  # file名をpathに変更
  path = file_name.gsub(/__/, "/").gsub(/\.png/, "")

  # sp判定
  if path.start_with?("sp")
    path = path.gsub(/sp\//, "")
    skip_exist_pagees_sp.push(path)
    next
  end

  skip_exist_pagees_pc.push(path)
}

# スキップされるページを表示
p "skipped pc pages"
p skip_exist_pagees_pc
p "skipped sp pages"
p skip_exist_pagees_sp

pages_pc = pages - skip_exist_pagees_pc
pages_sp = pages - skip_exist_pagees_sp

# 実際にスクリーンショットされるページを表示
p "these pc pages will be captured"
p pages_pc
p "these sp pages will be captured"
p pages_sp

pages_pc.each do |url|
  Capybara.current_driver = :selenium
  session.visit(url)
  # 画面のフルサイズを取得
  width = session.execute_script("return Math.max(document.body.scrollWidth, document.body.offsetWidth, document.documentElement.clientWidth, document.documentElement.scrollWidth, document.documentElement.offsetWidth);")
  height = session.execute_script("return Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight);")
  window = session.driver.browser.manage.window
  window.resize_to(width+100, height+100)

  # urlをファイル名に変換する("/" => "__")
  img_path = save_path + url.gsub(/\//, "__") + ".png"
  session.save_screenshot(img_path, full: true)
end

pages_sp.each do |url|
  Capybara.current_driver = :selenium_sp
  session_sp.visit(url)
  # 画面のフルサイズを取得
  width = session_sp.execute_script("return Math.max(document.body.scrollWidth, document.body.offsetWidth, document.documentElement.clientWidth, document.documentElement.scrollWidth, document.documentElement.offsetWidth);")
  height = session_sp.execute_script("return Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight);")
  window = session_sp.driver.browser.manage.window
  window.resize_to(width+100, height+100)

  # urlをファイル名に変換する("/" => "__")
  img_path = save_path + "sp__" + url.gsub(/\//, "__") + ".png"
  session_sp.save_screenshot(img_path, full: true)
end
