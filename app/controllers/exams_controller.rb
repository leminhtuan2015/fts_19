class ExamsController < BaseController
  load_and_authorize_resource only: [:update]

  def show
    @exam = Exam.find params[:id]
    @questions = @exam.subject.questions
    respond_to do |format|
      format.html
      format.csv
    end
  end

  def new
    @exam = Exam.new
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
      if @exam.mark.nil?
        $redis.set(@exam.id, "doing")
      end
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
      redirect_to root_url
    else
      flash[:danger] = "Error"
      redirect_to root_url
    end
  end

  private
  def exam_params
    params.require(:exam).permit :user_id, :subject_id
  end

  def sheet_params
    params.require(:exam).permit(answer_ids: [], responses_attributes: 
      [:id, :question_id, :answer_id, :answer_content])
  end
end