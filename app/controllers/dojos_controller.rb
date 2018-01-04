class DojosController < ApplicationController

  def index
    puts "Object created? Params are: ", params
    @dojos=Dojo.all
  end

  def new
    puts "I'm in new method. Inspect params passed to create method: ", params.inspect
    puts "Still in new method. @new_dojo has following values: ", @new_dojo, @new_dojo.inspect  
    @new_dojo=Dojo.new
  end

  def create
    puts "Inspect params passed to create method: ", params.inspect
    puts "Inspect params passed to create method: ", request.params.inspect

    # Will always evaluate to True. But a nice checker, just in case..
    if params[:dojo] 
      # @new_dojo=Dojo.new(branch: params[:branch], street: params[:street], city: params[:city], state: params[:state])
      # @new_dojo=Dojo.new(params[:dojo])
      @new_dojo=Dojo.new(create_with_attributes)
      # @new_dojo=Dojo.new(create_with_attributes)

      puts "Does it pass Object Class Validations? ", @new_dojo.valid?
      if @new_dojo.save
        redirect_to '/dojos', notice: "Dojo created with success!" and return
        # <%= url_for(@workshop) %>
        # calls @workshop.to_param which by default returns the id of the object stored in the 
        # @workshop instance variable:
        # => /workshops/5
      else
#        flash[:new_survey_errors] = @user_survey.errors.full_messages
        flash[:alert] = "Did not pass Object Class Validations. The submitted data was: #{@new_dojo.inspect}."
        render :new
      end
    end
  end
  
  private
  def create_with_attributes
    params.require(:dojo).permit(:branch, :street, :city, :state)
  end
end