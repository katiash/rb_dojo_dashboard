class DojosController < ApplicationController
  layout "application", only: [:new, :index, :edit, :show] #This is default behaviour for all views actually...
 # only the index and the new action will be loaded through app/views/layouts/dojos.html.erb
 # layout "dojos", only: [:new, :index, :edit, :show]

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

  def destroy
    #fail
    delete_dojo=Dojo.find(params[:id])
    puts delete_dojo
    delete_dojo.destroy
    puts delete_dojo
    redirect_to ('/')
  end  

  def edit
    if Dojo.exists?(params[:id])
      @dojo=Dojo.find(params[:id])
      # @students=@dojo.students
    else
      redirect_to '/'
    end
  end

  def update
    @dojo=Dojo.find(params[:id])
    if @dojo.update(create_with_attributes)
      puts "I am in update method. My params are: ", params
      return redirect_to edit_dojo_path(@dojo) , notice: "You have successfully updated this Dojo's information."
    else
      flash[:alert] = "Your updates did not pass Object Class Validations. The submitted data was: #{params[:dojo].inspect}."
      flash[:errors] = @dojo.errors.full_messages # DON'T FORGET TO DISPLAY THESE INSTEAD OF WHAT IS ON EDIT VIEW NOW
      puts "What is now in @dojo", @dojo
      # @dojo=Dojo.find(params[:id]) # DON'T FORGET TO UNCOMMENT, ALONG WITH THE ABOVE LINE
      # IN EDIT VIEW, REMOVE THE 'HIDDEN' assignment RIGHT BEFORE THE EDIT FORM. You Won't Need It Now. :)
      render action: :edit
    end
  end

  def show
    if Dojo.exists?(params[:id]) 
     @dojo=Dojo.find(params[:id]) 
     @students=@dojo.students
    else
      redirect_to '/'
    end
  end

  # THIS IS ONLY FOR EXAMPLE OF USING LAYOUTS (ROUTES HAVE NOT BE ADDED FOR THIS METHOD YET.)
  def hello_world
    render layout: "application"
     # renders with app/views/layouts/application.html.erb
  end

  private
  def create_with_attributes
    params.require(:dojo).permit(:branch, :street, :city, :state)
  end
end