# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "yorisoiの温かいデータを準備しています..."

# --- ユーザー作成 ---
olivia = User.find_or_create_by!(email: "olivia@example.com") do |user|
  user.name = "オリビア@癒やし担当"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user1.jpg"), filename:"sample-user1.jpg")
end

james = User.find_or_create_by!(email: "james@example.com") do |user|
  user.name = "ジェームス｜話聞くよ"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user2.jpg"), filename:"sample-user2.jpg")
end

lucas = User.find_or_create_by!(email: "lucas@example.com") do |user|
  user.name = "ルーカス＠まったり中"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user3.jpg"), filename:"sample-user3.jpg")
end

Post.find_or_create_by!(title: "陽だまりの公園") do |post|
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post1.jpg"), filename:"sample-post1.jpg")
  post.body = "今日はここでお昼寝。悩み事も少し軽くなった気がします。" # caption ではなく body
  post.emotion_level = 5 # せっかくなので感情レベルも入れてみましょう
  post.user = olivia
end

Post.find_or_create_by!(title: "夕暮れの帰り道") do |post|
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post2.jpg"), filename:"sample-post2.jpg")
  post.body = "今日も一日お疲れ様。空が綺麗だったので、あなたにもお裾分け。"
  post.emotion_level = 4
  post.user = james
end

Post.find_or_create_by!(title: "いつもの喫茶店") do |post|
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post3.jpg"), filename:"sample-post3.jpg")
  post.body = '温かいココアを飲んで、自分に「ありがとう」を言う時間。'
  post.emotion_level = 3
  post.user = lucas
end

puts "「yorisoi」の世界に3人と3つの思い出が誕生しました！"