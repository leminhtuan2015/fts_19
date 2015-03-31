class Admin::ExamsController < BaseController
  before_action :admin_user

  def index
    @exams = Exam.paginate page: params[:page], per_page: 10
  end

  def edit
    @exam = Exam.find params[:id]
  end

  def update
    @exam = Exam.find params[:id]
    @exam.status = 2
    if @exam.update_attributes exam_params
      flash[:success] = 'Examination updated'      
      redirect_to admin_exams_url
    else
      flash[:danger] = "Error"
      render 'edit'
    end
  end

  private
  def exam_params
    params.require(:exam).permit(approvals_attributes: 
      [:id, :question_id, :correct])
  end
end