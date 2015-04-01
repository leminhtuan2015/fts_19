class Admin::SubjectsController < BaseController
  def index
    @subjects = Subject.paginate page: params[:page], per_page: 10
  end

  def show
    @subject = Subject.find params[:id]
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new subject_params
    if @subject.save
      flash[:success] = "Created new subject"
      redirect_to admin_subjects_url
    end
    render 'new'
  end

  def update
    @subject = Subject.find params[:id]
    if @subject.update_attributes subject_params
      flash[:success] = "Information changed"     
      redirect_to admin_subjects_url and return
    end
    render 'show'
  end
  
  def destroy
    Subject.find(params[:id]).destroy
    flash[:success] = "Subject deleted"
    redirect_to admin_subjects_url
  end

  private
  def subject_params
    params.require(:subject).permit(:name, :description, 
      questions_attributes: [:id, :content, :kind, :_destroy, 
        answers_attributes: [:id, :content, :correct, :_destroy]])
  end
end