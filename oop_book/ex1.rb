module Towable
  def  can_tow?(lbs)
    lbs < 2000 ? true : false
  end
end

class Vehicle
  attr_accessor :color, :speed, :model
  attr_reader :year
  @@num_of_objects = 0

  def initialize(y, c, m)
    @year = y
    @color = c
    @model = m
    @speed = 0
    @@num_of_objects += 1
  end

  def speed_up(num)
    @speed += num
    "Accelerating...."
  end

  def brake(num)
    @speed -= num
    "Breaking..."
  end

  def shut_off
    @speed = 0
    'The car is off'
  end

  def current_speed
    "You're going #{speed} mph"
  end

  def spray_paint(new_color)
    self.color = new_color
  end

  def self.gas_milage(g, m)
    puts "#{m/g} miles per gallon of gas"
  end

  def self.num_of_objects
    @@num_of_objects
  end

  def age
    "#{model} is #{how_old} years old"
  end

  private

  def how_old
    Time.now.year - year
  end
end

class MyCar < Vehicle
  DOORS = 2

  def to_s
    "My car is #{year} #{color} #{model}"
  end
end

class MyTruck < Vehicle
  include Towable

  DOORS = 4

  def to_s
    "My truck is #{year} #{color} #{model}"
  end
end

my_car = MyCar.new(2011, 'grey', 'Toy')
my_truck = MyTruck.new(2011, 'white', 'Ford')
p my_car.year
p my_truck.year
p my_car.color
p my_truck.color
my_car.color = 'Red'
my_truck.color = 'Black'
p my_car.color
p my_truck.color
p my_car.current_speed
p my_truck.current_speed
p my_car.speed_up(20)
p my_truck.speed_up(30)
p my_car.current_speed
p my_truck.current_speed
p my_car.brake(my_car.speed)
p my_car.current_speed
p my_car.shut_off
my_car.spray_paint 'Blue' 
p my_car.color
p my_truck.age
p my_car.age

MyCar.gas_milage(5, 200)
puts my_car

p Vehicle.num_of_objects