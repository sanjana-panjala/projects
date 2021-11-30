class StudentApplicationController < ApplicationController
  def index
    @applications = StudentApplication.all
  end

  def new
    if current_user.student_application.present?
      redirect_to student_index_path, notice: "ERROR: You've already submitted an application."
    else
      @student_application = StudentApplication.new
    end
  end

  # Clear table, then refresh the page
  def clear_table(do_refresh=true)
    ActiveRecord::Base.connection.truncate(:student_applications)
    if do_refresh
      redirect_back(fallback_location: root_path)
    end
  end

  def create
    @student_application = StudentApplication.new(user_params.merge(user_id: current_user.id))
    if @student_application.save
      current_user.student_application = @student_application
      redirect_to student_index_path, notice: "Successfully Submitted Application"
    else
    render :new
    end
  end

  private
  def user_params
    params.require(:student_application).permit(:email, :name, :phone_number, :desired_courses, :taken_courses, :availability)
  end
end
