# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
admin = User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password', display_name: 'Admin')
admin.add_role :admin

w = World.create(name: 'Eros', user: admin)
m = MapLayer.create(title: 'Eros Antique', world: w, priority: 0)
m.image.attach(io: File.open('public/eros.jpg'), filename: 'eros.jpg' , content_type: 'image/jpeg')
%w[biome height temperature precipitation].each_with_index do |type, index|
  m = MapLayer.create(title: "Eros #{type}", world: w, priority: index + 1)
  m.image.attach(io: File.open("public/eros_#{type}.png"), filename: "eros_#{type}.png" , content_type: 'image/png')
end
state = State.create world: w, name: 'Zeon', primary_color: '#008000', secondary_color: '#808000'
c = Continent.create(title: 'Auson', parent: w, world: w)
s = Subcontinent.create(title: 'West Auson', parent: c, world: w)
r = Region.create(title: 'Weson', parent: s, world: w)
a = Area.create(title: 'Arcor', parent: r, world: w)
p = Province.create(title: 'Arriccar', parent: a, world: w)
h = Hex.create(world: w, x: 409, y: 274, parent: p, title: 'Arriccar', world: w, owner: state)
h = Hex.create(world: w, x: 408, y: 273, parent: p, title: 'Neoheim', world: w)
h = Hex.create(world: w, x: 409, y: 275, parent: p, title: 'North Arriccar', world: w)
c.update_geometry! [[0, 0], [8192, 0], [8192, 4096], [0, 4096]]
c.generate_hexes!
#
# puts 'Seeding hexes...'
# Hex.transaction do
#   (0..200).to_a.each do |x|
#     puts "Column #{x}"
#     hexes = (0..100).to_a.map do |y|
#       {
#         world: w,
#         x: x,
#         y: y,
#         parent: p,
#         title: "#{x},#{y}",
#         geometry: GeoLayer.hex_geometry(GeoLayer.draw_hex(GeoLayer.hex_to_point(x, y)), w.factory)
#       }
#     end
#     Hex.create hexes
#   end
# end
# puts 'done'

puts 'Seeding timeline...'
a1 = Age.create(title: 'First Age', abbreviation: 'FA', world: w)
d1 = WorldDate.create(age: a1, year: 1728, month: 6, day: 6)
a2 = Age.create(title: 'Second Age', abbreviation: 'SA', world: w, preceding_age: a1, start_date: d1)
d2 = WorldDate.create(age: a2, year: 87, month: 4, day: 15)
puts 'done'

factory = w.factory
pt1 = factory.point(0, 0)
pt2 = factory.point(2000, 0)
pt3 = factory.point(2000, 2000)
pt4 = factory.point(0, 2000)

pt5 = factory.point(0500, 0500)
pt6 = factory.point(1500, 0500)
pt7 = factory.point(1500, 1500)
pt8 = factory.point(0500, 1500)

pt9 = factory.point(3000, 3000)
pt10 = factory.point(4000, 3000)
pt11 = factory.point(4000, 4000)
pt12 = factory.point(3000, 4000)

outerring1 = factory.linear_ring([pt1, pt2, pt3, pt4, pt1])
innerring = factory.linear_ring([pt5, pt6, pt7, pt8, pt5])

square_with_hole = factory.polygon(outerring1, [innerring])

outerring2 = factory.linear_ring([pt9, pt10, pt11, pt12])
square = factory.polygon(outerring2)

multipolygon = factory.multi_polygon([square_with_hole, square])
c.geometry = factory.collection([multipolygon])
c.save

puts "Resetting geometry..."
GeoLayer.reset_geometry_for! w, except: [Hex]
puts "done"

##
# Earth
w = World.create(name: 'Earth', user: admin)
m = MapLayer.create(title: 'Natural Earth', world: w)
m.image.attach(io: File.open('public/natural_earth.jpg'), filename: 'natural_earth.jpg' , content_type: 'image/jpeg')
c = Continent.create(title: 'North America', parent: w, world: w)
s = Subcontinent.create(title: 'The South', parent: c, world: w)
r = Region.create(title: 'Tennessee', parent: s, world: w)
a = Area.create(title: 'West Tennessee', parent: r, world: w)
p = Province.create(title: 'Tipton County', parent: a, world: w)
h = Hex.create(world: w, x: 941, y: 840, parent: p, title: 'Covington', world: w)


# [
#   Province,
#   Area,
#   Region,
#   Subcontinent,
#   Continent
# ].each { |c| c.where(world: World.first).each &:reset_geometry! }

SEED_FILES = {
  building_types: BuildingType
}
def load_yaml(filename)
  file = Rails.root.join('db', 'seed', "#{filename}.yml")
  YAML::load_file(file)
end

building_types = load_yaml :building_types
upgrades = {}
building_types.each do |name, data|
  data[:name] = name.titleize
  data[:slug] = name
  upgrades[name] = data.delete 'upgrade' if data['upgrade']

  BuildingType.create data
end
upgrades.each do |from, to|
  bt = BuildingType.find_by_slug from
  bt.upgrade = BuildingType.find_by_slug to
  bt.save
end
