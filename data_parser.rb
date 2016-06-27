require 'csv'
require 'erb'

# csv_name = ARGV[0].to_s
# Delivery Class iterations are objects
# of the rows of the CSV file being brought in.

class Delivery
  attr_accessor :destination, :shipment, :crates, :money, :pilot
  def initialize(hash)
    @destination = hash[:destination]
    @shipment = hash[:shipment]
    @crates = hash[:crates]
    @money = hash[:money]
    @pilot = pilot_matcher[destination]
  end

  def pilot_matcher
    destp = { "Earth" => "Fry", "Mars" => "Amy", "Uranus" => "Bender"}
    destp.default = "Leela"
    destp
  end
  # attempt #2
  # def self.group_by_planet(deliveries)
  #   planet_sales = []
  #   planet_hash = []
  #   planets = deliveries.collect{|delivery| delivery.destination}.uniq!
  #   planets.each do |x|
  #   planet_sales << {planet: x, sales: deliveries.select{|delivery| delivery.destination == x}.collect{|delivery| delivery.money}.inject(:+)}
  #   end
  # return planet_sales
  # end

  def self.group_by_planet(deliveries)
    revenue_by_planet = []
    planet_group = deliveries.group_by(&:destination)
    planet_group.each do |planet_g|
      revenue_by_planet << {
        planet: planet_g[0],
        revenue: planet_g[1].collect(&:money).inject(:+)
      }
    end
    revenue_by_planet
  end

end

deliveries = CSV.read("planet_express_logs.csv", headers: true, header_converters: :symbol, converters: :numeric).map{|x| Delivery.new(x)}

# Explorer #1: h1 with the total money we made this week
money_week = deliveries.inject(0) { |sum, delivery| sum + delivery.money }
# Explorer #2:Table of all Shipments
all_shipments = deliveries.collect(&:shipment)
# Explorer #3: Table of all employees and their number of trips and bonus

# Class objects will organize that CSV data around each employee.
class Employee
  attr_accessor :name,
                :delivery_destination,
                :deliveries,
                :num_shipments,
                :bonus
  def initialize(name, delivery_objects)
    @name = name
    @deliveries = delivery_objects.select { |delivery| delivery.pilot == name}
    @bonus = @deliveries.inject(0) { |sum, delivery| sum + delivery.money / 10.0 }
    @num_shipments = @deliveries.count
  end
end


roster = ['Fry', 'Amy', 'Bender', 'Leela']
employees = roster.map{|name| Employee.new(name, deliveries)}

new_file = File.open('report.html', 'w+')
new_file << ERB.new(File.read('report.erb')).result(binding)
new_file.close
