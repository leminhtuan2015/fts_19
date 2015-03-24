class ExamsController < BaseController
  def show
    @exam = Exam.find params[:id]
    @questions = @exam.subject.questions
  end

  def new
    @exam = Exam.new
  end

  def create
    @exam = Exam.new exam_params
    if @exam.save      
      flash[:success] = "Created new examination"
      redirect_to root_url
    end
    flash[:success] = "Error"
  end

  def edit
    @exam = Exam.find params[:id]
    @questions = @exam.subject.questions
  end

  def update
    @exam = Exam.find params[:id]
    @time = Time.at(params[:exam][:time].to_f / 100).utc.strftime("%H:%M:%S")
    @exam.time = DateTime.strptime(@time, '%H:%M:%S')
    if @exam.update_attributes sheet_params
      flash[:success] = 'Examination updated'      
      redirect_to root_url
    else
      flash[:success] = "Error"
      redirect_to root_url
    end
  end

  private
  def exam_params
    params.require(:exam).permit :user_id, :subject_id, :time
  end

  def sheet_params
    params.require(:exam).permit answer_ids: []
  end
end