# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Shop.create!(name: 'CHAVATY', menu: "カフェラテ",area:"表参道", price:"500",review:"美味しかったです。",tag_list: "wi-fi", pictures_attributes:[{picture: open("#{Rails.root}/db/fixtures/S__180174850.jpg")},{picture:open("#{Rails.root}/db/fixtures/S__180174852.jpg")},{picture:open("#{Rails.root}/db/fixtures/S__180174853.jpg")},{picture:open("#{Rails.root}/db/fixtures/S__180174854.jpg")}])
#Review.create!(name: "COFFEE SHOP ギャラン",menu: "", area:"上野", review:"",price:"",picture: open("#{Rails.root}/db/fixtures/S__180174852.jpg"))
#Review.create!(name: "ブンブン喫茶店",menu: "", area:"鎌倉", price:"",review:"",picture: open("#{Rails.root}/db/fixtures/S__180174853.jpg"))
#Review.create!(name: "ゆりあぺむぺる", menu: "",area:"吉祥寺",price:"", review:"",picture: open("#{Rails.root}/db/fixtures/S__180174854.jpg"))
