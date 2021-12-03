class Student
  attr_accessor :name
  attr_writer :grade

  def initialize(n, g)
    @name = n
    @grade = g
  end

  def better_grade_than?(n)
    !(grade > n.grade)
  end

  protected

  def grade
    @grade
  end
end

joe = Student.new('Joe', 'A')
bob = Student.new('Bob', 'B')

puts 'Well Done!' if joe.better_grade_than?(bob)


