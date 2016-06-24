#!/usr/bin/ruby

require 'csv'
require 'erb'

csv_name = ARGV[0].to_s
class Delivery
  attr_accessor :destination, :shipment, :crates, :money
  def initialize(destination, shipment, crates, money)
    @destination = destination
    @shipment = shipment
    @crates = crates
    @money = money
  end

#can I use group by and then compact and then reject?
# def self.planet_money(deliveries)
def self.money_by_planet(deliveries)
end



#attempt #2
  def self.group_by_planet(deliveries)
    planet_sales = []
    planet_hash = []
    planets = deliveries.collect{|delivery| delivery.destination}.uniq!
    planets.each do |x|
      planet_sales << {planet: x, sales: deliveries.select{|delivery| delivery.destination == x}.collect{|delivery| delivery.money}.inject(:+)}
    end
  return planet_sales
  end

#attempt #3
  # def self.group_by_planet(deliveries)
  #   bucket = []
  #   planet_group = deliveries.group_by{|delivery| delivery.destination}
  #   planet_group.each do |x|
  #      bucket inject{|sum, x| sum += x.each do |x| }
  #   end
  #   return bucket
  # end

  #
  #   deliveries.each do |delivery|
  #     if delivery.destination == "Earth"
  #        earth_deliveries << delivery
  #     elsif delivery.destination == "Moon"
  #           moon_deliveries << delivery
  #     elsif delivery.destination == "Mars"
  #        mars_deliveries << delivery
  #     elsif delivery.destination == "Uranus"
  #         uranus_deliveries << delivery
  #     elsif delivery.destination == "Saturn"
  #        saturn_deliveries << delivery
  #     elsif delivery.destination == "Jupiter"
  #         jupiter_deliveries << delivery
  #     elsif delivery.destination == "Pluto"
  #        pluto_deliveries << delivery
  #     elsif delivery.destination == "Jupiter"
  #         mercury_deliveries << mercury
  #     end
  #   end
  #   puts earth_deliveries.inspect
  #   earth_deliveries.collect{|x| x.money}.inject(:+)
  # end
  #method that returns array or hash with variables that say what each person gets
end




class Parse_data
  attr_accessor :parsed
  def initialize(x)
    @parsed = []
    CSV.foreach(x, headers: true, header_converters: :symbol) do |row|
      @parsed << Delivery.new(row[:destination], row[:shipment], row[:crates].to_s.to_i, row[:money].to_s.to_i)
      end
    end
end

parse1 = Parse_data.new(csv_name)


deliveries = parse1.parsed


puts deliveries
puts deliveries[0].inspect
puts deliveries[0].money
#Explorer #1: h1 with the total money we made this week
money_week = deliveries.inject(0){|sum, delivery| sum += delivery.money}
puts money_week
#Explorer #2:Table of all Shipments
all_shipments = deliveries.collect{|delivery| delivery.shipment}
#Explorer #3: Table of all employees and their number of trips and bonus

puts all_shipments

class Employee
  attr_accessor :name, :delivery_destination, :deliveries, :num_shipments, :bonus
  def initialize(name, delivery_objects)
    @name = name
    @delivery_destination = delivery_matcher(@name)
    @deliveries = delivery_objects.select{|delivery| @delivery_destination.include? delivery.destination}
    @bonus = @deliveries.inject(0){|sum, delivery| sum += delivery.money * 10 / 100 }
    @num_shipments = @deliveries.count
  end
  def delivery_matcher(a_name)
    @delivery_destination = ["Earth"] if a_name == "Fry"
    @delivery_destination = ["Mars"] if a_name == "Amy"
    @delivery_destination = ["Uranus"] if a_name == "Bender"
    @delivery_destination = ["Saturn", "Jupiter", "Mercury", "Pluto", "Moon"] if a_name == "Leela"
    @delivery_destination = [] if a_name != "Bender" || "Amy" || "Fry" || "Leela"
    end
end
employees = []

employees << Employee.new("Fry", deliveries)
employees << Employee.new("Amy", deliveries)
employees << Employee.new("Bender", deliveries)
employees<< Employee.new("Leela", deliveries)


puts employees[0].inspect
#
# new_file = File.open("report.html", "w+")
# new_file << ERB.new(File.read("report.erb")).result(binding)
# new_file.close
puts Delivery.group_by_planet(deliveries)
