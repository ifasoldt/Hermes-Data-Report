require 'csv'
require 'erb'

class Delivery
  attr_accessor :destination, :shipment, :crates, :money
  def initialize(destination, shipment, crates, money)
    @destination = destination
    @shipment = shipment
    @crates = crates
    @money = money
  end
  #method that returns array or hash with variables that say what each person gets
end

deliveries = []
CSV.foreach("planet_express_logs.csv", headers: true, header_converters: :symbol) do |row|
deliveries << Delivery.new(row[:destination], row[:shipment], row[:crates].to_s.to_i, row[:money].to_s.to_i)
end
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
    if @name == "Fry"
      @delivery_destination = ["Earth"]
    elsif @name == "Amy"
      @delivery_destination = ["Mars"]
    elsif @name == "Bender"
      @delivery_destination = ["Uranus"]
    else
      @name == ["Leela"]
      @delivery_destination = ["Saturn", "Jupiter", "Mercury", "Pluto", "Moon"]
    end
    @deliveries = delivery_objects.select{|delivery| @delivery_destination.include? delivery.destination}
    @bonus = @deliveries.inject(0){|sum, delivery| sum += delivery.money * 10 / 100 }
    @num_shipments = @deliveries.count
  end
end
employees = []

employees << Employee.new("Fry", deliveries)
employees << Employee.new("Amy", deliveries)
employees << Employee.new("Bender", deliveries)
employees<< Employee.new("Leela", deliveries)


puts employees[0].inspect

new_file = File.open("report.html", "w+")
new_file << ERB.new(File.read("report.erb")).result(binding)
new_file.close
