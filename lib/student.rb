require_relative "../config/environment.rb"

class Student
	attr_accessor :name, :grade
	attr_reader :id
	def initialize(name=nil, grade=nil, id=nil)
		@id = id
		@name = name 
		@grade = grade
	end

	def save
		if !self.id 
			sql_add = "INSERT INTO students (name, grade) VALUES (?,?)"
			DB[:conn].execute(sql_add, @name, @grade)
			sql_get_id = "SELECT last_insert_rowid() FROM students"
			@id = DB[:conn].execute(sql_get_id).flatten[0]
		else 
			self.update
		end
		self
	end

	def update 
		sql_update = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
		DB[:conn].execute(sql_update, @name, @grade, @id)
	end

	def self.find_by_name(name)
		sql_find = "SELECT * FROM students WHERE name = ?"
		found = DB[:conn].execute(sql_find, name).flatten
		self.new_from_db(found)
	end

	def self.create_table
		sql_create = "CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, grade INTEGER);"
		DB[:conn].execute(sql_create)
	end

	def self.drop_table
		sql_delete = "DROP TABLE students"
		DB[:conn].execute(sql_delete)
	end

	def self.create(name, grade)
		new_student = Student.new(name, grade)
		new_student.save
	end 

	def self.new_from_db(row)
		new_student = Student.new(row[1], row[2], row[0])
		new_student
	end
end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


