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
m = MapLayer.create(title: 'Eros Antique', world: w)
m.image.attach(io: File.open('public/eros.jpg'), filename: 'eros.jpg' , content_type: 'image/jpeg')
state = State.create world: w, name: 'Zeon', primary_color: '#008000', secondary_color: '#808000'
c = Continent.create(title: 'Auson', parent: w, world: w)
s = Subcontinent.create(title: 'West Auson', parent: c, world: w)
r = Region.create(title: 'Weson', parent: s, world: w)
a = Area.create(title: 'Arcor', parent: r, world: w)
p = Province.create(title: 'Arriccar', parent: a, world: w)
h = Hex.create(world: w, x: 941, y: 840, parent: p, title: 'Arriccar', world: w, owner: state)
h = Hex.create(world: w, x: 940, y: 840, parent: p, title: 'Neoheim', world: w)
h = Hex.create(world: w, x: 941, y: 841, parent: p, title: 'North Arriccar', world: w)
a1 = Age.create(title: 'First Age', abbreviation: 'FA', world: w)
d1 = WorldDate.create(age: a1, year: 1728, month: 6, day: 6)
a2 = Age.create(title: 'Second Age', abbreviation: 'SA', world: w, preceding_age: a1, start_date: d1)
d2 = WorldDate.create(age: a2, year: 87, month: 4, day: 15)


w = World.create(name: 'Earth', user: admin)
m = MapLayer.create(title: 'Natural Earth', world: w)
m.image.attach(io: File.open('public/natural_earth.jpg'), filename: 'natural_earth.jpg' , content_type: 'image/jpeg')
c = Continent.create(title: 'North America', parent: w, world: w)
s = Subcontinent.create(title: 'The South', parent: c, world: w)
r = Region.create(title: 'Tennessee', parent: s, world: w)
a = Area.create(title: 'West Tennessee', parent: r, world: w)
p = Province.create(title: 'Tipton County', parent: a, world: w)
h = Hex.create(world: w, x: 941, y: 840, parent: p, title: 'Covington', world: w)

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
