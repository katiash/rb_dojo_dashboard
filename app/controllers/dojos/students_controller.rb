class Dojos::StudentsController < ApplicationController
 before_action :set_student, only: [:edit, :show, :update, :destroy]
 before_action :set_dojo, only: [:edit, :destroy, :update, :new, :show]
 
  def new
    @student=Student.new
    @dojos=Dojo.all
  end

  def create
    puts "In create method. Selected dojo is: ", student_params
    @student=Student.new(student_params)
    puts "Assigned id to new student object: ", @student.dojo_id
    if @student.save
      redirect_to '/', notice: "Successfully added/created a student for a Dojo Branch!"
    else
      @dojos=Dojo.all
      @dojo=Dojo.find(@student.dojo_id)
      render :new
    end
  end

  def show
    # fail
    puts @dojo.branch
    @students=Dojo.joins(:students).select("students.first_name", "students.last_name", "students.email").where("dojos.id = #{@dojo.id}" )
    # all_these_teams = Team.joins(:players).select("players.name",' teams.name as "Team\'s Name"').where('players.name LIKE "Z%"')


  end

  def edit
    # fail
  end

  def update
  end

  def destroy
    if @student.delete
      puts "Deleted student successfully."
      redirect_to dojo_path(@dojo)
    else
      puts "Not able to delete.."
      render controller: 'dojos', action: :show, id: @dojo.id
    end
    # fail
  end


  private
  def set_student
    @student = Student.find(params[:id])
  end

  def set_dojo
    @dojo = Dojo.find(params[:dojo_id])
  end
  
  def student_params
    params.require(:student).permit(:first_name, :last_name, :email, :dojo_id)
  end
end