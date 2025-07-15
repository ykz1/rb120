class Student
  attr_accessor :name

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(other_student)
    grade > other_student.grade
  end

  protected

  attr_accessor :grade

end

jon = Student.new('jon', '86')
bob = Student.new('bob', '85')

p 'Good job Jon!' if jon.better_grade_than?(bob)