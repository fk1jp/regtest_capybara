require "rmagick"

# 保存先の設定
save_base_path = "screenshot/image_diff/"
# 引数がない場合の比較元
default_path = "screenshot/save/path/master"

# argvの整形
def folder_path(path)
  if path.slice(-1) != "/"
    return path + "/" 
  else
    return path 
  end
end

# 画像の変化率を計測
def image_diff_rate(image)
  i = 0.0
  black = Magick::Pixel.new(0, 0, 0)
  # イメージを1pxごとに黒色かどうか判定
  for y in 0...image.rows
    for x in 0...image.columns
      image_color = image.pixel_color(x, y)
      # 色が黒の場合
      if image_color == black
      else
        i = i + 1
      end
    end
  end
  if i == 0
    return "no_diff"
  end
  # ドット数で割って変化率を出す
  i = i / (image.rows * image.columns) * 100
  return i.round(2).to_s + "%"
end

def image_diff(path, composite_path, save_directory)
  k = 0
  file_count = Dir[ path + "**/*" ].length + 1
  # 差分のログファイルを作成する
  diff_log = "compared " + path + " and " + composite_path + "\n"
  diff_log = diff_log + "path\tdiff[%]\n"
  Dir::foreach(path) do |file|
    next if file.match("'/\.gif$|\.png$|\.jpg$|\.jpeg$|\.bmp$/i'").nil?
    k = k + 1
    # 元画像の読み込み
    image = Magick::ImageList.new(path + file)
    # 参照先のファイルが存在しない場合
    if !File.exist?(composite_path + file)
      diff_log += composite_path + file + " doesn't find\n" 
      p "(" + k.to_s + "/" + file_count.to_s + ") " + composite_path + file + " doesn't find"
      next
    end
    # 比較先の読み込み
    composite_image = Magick::ImageList.new(composite_path + file)
    # 比較
    save_image = image.composite(composite_image, 0, 0, Magick::DifferenceCompositeOp)
    save_path = save_directory + file
    # 差分のログを追記
    diff_rate = image_diff_rate(save_image)
    file_name_to_path = file.gsub(/__/, "/").gsub(/\.png/, "") 
    # 画像の保存
    unless diff_rate == "no_diff"
      save_image.write(save_path)
    end
    # 追記処理
    diff_log += file_name_to_path + "\t" + diff_rate + "\n" 
    p "(" + k.to_s + "/" + file_count.to_s + ") " + file_name_to_path + " " + diff_rate 
    File.write(save_directory + "log.csv", diff_log)
    # メモリ解放
    save_image.destroy!
  end
end

if ARGV[0].nil?
  p "argvの第一引数に参照先フォルダ、第二引数に参照元フォルダを入力してください"
  p "第二引数が存在しない場合は参照元フォルダ２に" + default_path + "が適応されます"
  return 
else 
  composite_path = folder_path(ARGV[0]) 
  if ARGV[1].nil?
    path = folder_path(default_path)
  else
    path = folder_path(ARGV[1])
  end
end
p "参照元: " + path 
p "参照先: " + composite_path
p "比較を開始します"

# argvで取得したスクリーンショットフォルダ名を取得
folder1 = File.basename(path)
folder2 = File.basename(composite_path)

if ARGV[1].nil?
  save_directory = save_base_path + folder2 + "/"
else
  save_directory = save_base_path + folder1 + "__vs__" + folder2 + "/"
end

# 保存先のフォルダがない場合作成する
FileUtils.mkdir_p(save_directory) unless FileTest.exist?(save_directory)
# 実行
image_diff(path, composite_path, save_directory)
