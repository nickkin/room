# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

i = 0

[
  [55.760963561706404,37.600806989257826],
  [55.69896803470183,37.477210797851576],
  [55.64153411288547,37.28906992871095],
  [55.590445000018875,36.61089481830123],
  [54.80289738614441,31.99537542206004]
].each do |location|
  i += 1
  price = Random.rand(990) + 10
  Ad.new(name: "Название #{i}", description: "Описание #{i}", price: price, location: location).save
end


-90.upto 90 do |i|
  -90.upto 90 do |ii|
    price = Random.rand(990) + 10
    Ad.new(name: "Название #{i}", description: "Описание #{i}", price: price, location: [i,ii]).save
  end
end