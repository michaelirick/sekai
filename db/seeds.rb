# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

w = World.create(name: 'Eros')
m = MapLayer.create(title: 'Eros Antique', world: w)
m.image.attach(io: File.open('public/eros.jpg'), filename: 'eros.jpg' , content_type: 'image/jpeg')
c = Continent.create(name: 'Auson', world: w)
s = Subcontinent.create(name: 'West Auson', continent: c)
r = Region.create(name: 'Weson', subcontinent: s)
a = Area.create(name: 'Arcor', region: r)
p = Province.create(name: 'Arriccar', area: a)
h = Hex.create(world: w, x: 941, y: 840, province: p, title: 'Arriccar')
h = Hex.create(world: w, x: 940, y: 840, province: p, title: 'Neoheim')
h = Hex.create(world: w, x: 941, y: 841, province: p, title: 'North Arriccar')

w = World.create(name: 'Earth')
m = MapLayer.create(title: 'Natural Earth', world: w)
m.image.attach(io: File.open('public/natural_earth.jpg'), filename: 'natural_earth.jpg' , content_type: 'image/jpeg')
c = Continent.create(name: 'North America', world: w)
s = Subcontinent.create(name: 'The South', continent: c)
r = Region.create(name: 'Tennessee', subcontinent: s)
a = Area.create(name: 'West Tennessee', region: r)
p = Province.create(name: 'Tipton County', area: a)
h = Hex.create(world: w, x: 941, y: 840, province: p, title: 'Covington')


