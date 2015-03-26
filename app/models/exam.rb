class Exam < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject

  has_many :responses, dependent: :destroy
  has_many :questions, through: :responses
  has_many :answers, through: :responses

  before_update :add_questions, :calculate_mark

  after_save :redis_del

  scope :search, ->search {Exam.joins(:subject).where('subjects.name LIKE ?', "%#{search}%") if search}

  private
  def calculate_mark
    @questions = self.questions
    @mark = 0    
    @questions.each_with_index do |question, index|
      unless question.id == @questions[index-1].id
        @checked = self.responses.question_answers question.id       
        @correct = self.answers.question_correct_answers question.id
        @answer_key = question.answers.correct_answers
        if @checked.count == @correct.count && @correct.count == @answer_key.count
          @mark += 1
        end
      end
    end
    self.mark = @mark
  end

  def add_questions
    self.responses.each do |response|
      response.update_attributes question_id: response.answer.question_id
    end
  end

  def redis_del
    $redis.del(self.id, "doing")
  end
end