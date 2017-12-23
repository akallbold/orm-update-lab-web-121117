require_relative "../config/environment.rb"
require "pry"

class Student
  attr_accessor :name, :grade, :id

  def initialize (id = nil, name, grade)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT)
    SQL

    DB[:conn].execute(sql)
  end


  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
    SQL

    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      self.id = DB[:conn].execute("SELECT MAX(id) FROM students")[0][0]
    end
  end

  def update
    sql = <<-SQL
      UPDATE students
      SET name = ?, grade = ?
      WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.create(name, grade)
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql,name, grade)
  end

  def self.new_from_db(row)
    new_student = Student.new(row[0],row[1], row[2])
  end


  def self.find_by_name(name_argument)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name == ?
    SQL

    result = DB[:conn].execute(sql, name_argument)[0]
    new_from_db(result)
  end

end
