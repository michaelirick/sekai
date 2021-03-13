# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

w = World.create(name: 'Eros')
c = Continent.create(name: 'Auson', world: w)
s = Subcontinent.create(name: 'West Auson', continent: c)
r = Region.create(name: 'Weson', subcontinent: s)
a = Area.create(name: 'Arcor', region: r)
p = Province.create(name: 'Arriccar', area: a)
h = Hex.create(x: 123, y: 123, province: p)
