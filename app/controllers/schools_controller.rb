class SchoolsController < ApplicationController
  before_action :set_school, only: [:show, :edit, :update, :destroy]
  authorize_resource

  def index
    @schools = School.alphabetical.paginate(:page => params[:page]).per_page(7)
  end

  def new
    @school = School.new
  end

  def create
    @school = School.new(school_params)
    if @school.save
      session[:school_id] = @school.id
      # respond_to |format| do
      #   format.html { redirect_to schools_path, notice: "Successfully added a school to the system."}
      #   format.js
      # end
      redirect_to schools_path, notice: "Successfully added a school to the system."
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @school.update(school_params)
      redirect_to school_path(@school), notice: "Successfully updated #{@school.name}."
    else
      render action: 'edit'
    end
  end

  private
  def school_params
    params.require(:school).permit(:name, :street_1, :street_2, :city, :state, :zip, :min_grade, :max_grade, :active)
  end

  def set_school
    @school = School.find(params[:id])
  end

end
