class Admin::SubjectsController < ApplicationController
  before_action :authenticate_user!, :admin_user

  def index
    @subjects = Subject.paginate page: params[:page], per_page: 10
  end

  def show
    @subject = Subject.find params[:id]
  end

  def update
    @subject = Subject.find params[:id]
    if @subject.update_attributes subject_params
      flash[:success] = "Information changed"     
      redirect_to admin_subjects_url
    else
      render 'show'
    end
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new subject_params
    if @subject.save
      flash[:success] = "Created new subject"
      redirect_to admin_subjects_url
    else
      render 'new'
    end
  end

  def destroy
    Subject.find(params[:id]).destroy
    flash[:success] = "Subject deleted"
    redirect_to admin_subjects_url
  end

  private
  def subject_params
    params.require(:subject).permit(:name, :description, 
      questions_attributes: [:id, :content, :_destroy, 
        answers_attributes: [:id, :content, :correct, :_destroy]])
  end

  def admin_user
    unless current_user.admin?
      flash[:danger] = "Please log in by admin account."
      redirect_to root_url
    end   
  end
end