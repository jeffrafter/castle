# Area Codes
# Algarrobo Area Code - 35
# Ancua Area Code - 65
# Antofagasta Area Code - 58
# Arauco Area Code - 41
# Arica Area Code - 58

Factory.sequence :area do |n|
  "Area#{n}"
end

Factory.define :area, :class => 'area' do |area|
  area.name         { Factory.next :region }
  area.country_code { 56 }
  area.area_code    { 35 }
  area.region       {|region| region.association(:region) }
end