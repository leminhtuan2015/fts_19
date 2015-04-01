class ExamsController < ApplicationController
  load_and_authorize_resource only: [:update]
  before_action :authenticate_user!

  def show
    @exam = Exam.find params[:id]
    @questions = @exam.subject.questions
    respond_to do |format|
      format.html
      format.csv
    end
  end

  def create
    @exam = Exam.new exam_params
    if @exam.save  
      flash[:success] = "Created new examination"
      redirect_to root_url and return
    end    
    flash[:danger] = "Error"
  end

  def edit
    @exam = Exam.friendly.find params[:id]
    if $redis.get(@exam.id).nil?
      @questions = @exam.subject.questions
      $redis.set(@exam.id, "doing") if @exam.new?
    else
      flash[:danger] = "Just doing it on other device"
      redirect_to root_path
    end
  end

  def update
    @exam = Exam.friendly.find params[:id]
    @time = Time.at(params[:exam][:time].to_f / 100).utc.strftime("%H:%M:%S")
    @exam.time = DateTime.strptime(@time, '%H:%M:%S')
    if @exam.update_attributes sheet_params
      flash[:success] = 'Examination updated'      
    else
      flash[:danger] = "Error"
    end
    redirect_to root_url
  end

  private
  def exam_params
    params.require(:exam).permit :user_id, :subject_id, :status
  end

  def sheet_params
    params.require(:exam).permit(answer_ids: [], responses_attributes: 
      [:id, :question_id, :answer_id, :answer_content])
  end
end