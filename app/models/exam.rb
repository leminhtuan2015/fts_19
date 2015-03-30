class Exam < ActiveRecord::Base
  extend FriendlyId
  belongs_to :user
  belongs_to :subject

  has_many :responses, dependent: :destroy
  has_many :questions, through: :responses
  has_many :answers, through: :responses

  accepts_nested_attributes_for :responses

  before_update :add_questions
  after_update :calculate_mark
  after_save :redis_del, :remind_do_exam

  scope :search, ->search {Exam.joins(:subject).where('subjects.name LIKE ?', "%#{search}%") if search}

  delegate :name, to: :subject
  delegate :email, to: :user

  friendly_id :slug_candidates, use: [:slugged, :finders]

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
    end
  end

  private
  def calculate_mark
    if self.mark.nil?
      @questions = self.questions
      @mark = 0    
      @questions.each_with_index do |question, index|
        unless question.id == @questions[index-1].id && index > 0
          if question.kind == 1
            @checked = self.responses.with_question_id question.id       
            @correct = self.answers.question_correct_answers question.id
            @answer_key = question.answers.correct_answers
            if @checked.count == @correct.count && @correct.count == @answer_key.count
              @mark += 1
            end
          else
            @filled = self.responses.with_question_id question.id
            @answer_key = question.answers
            @filled.each_with_index do |fill, i| 
              if fill.answer_content != @answer_key[i].content
                @mark -= 1
                break
              end
            end
            @mark += 1
          end
        end
      end      
      self.update_attributes mark: @mark
    end
  end

  def add_questions
    self.responses.each do |response|
      if response.answer_content.nil?
        response.update_attributes question_id: response.answer.question_id
      end
    end
  end

  def redis_del
    $redis.del(self.id, "doing")
  end

  def slug_candidates
    [
      :name,
      [:name, :updated_at]
    ]
  end

  def remind_do_exam
    remind = $redis.get(self.id.to_s+"remind").to_i
    $redis.set(self.id.to_s+"remind", (remind+1).to_s)
    if remind < 3
      UserMailer.remind_do_exam_email(self.email).deliver_now
      remind_do_exam
    else
      Exam.destroy self.id
    end
  end

   handle_asynchronously :remind_do_exam, run_at: Proc.new { 1.minutes.from_now }
end