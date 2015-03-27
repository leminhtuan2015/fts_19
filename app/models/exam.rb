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

  after_save :redis_del

  scope :search, ->search {Exam.joins(:subject).where('subjects.name LIKE ?', "%#{search}%") if search}

  delegate :name, to: :subject

  friendly_id :slug_candidates, use: [:slugged, :finders]
  
  private
  def calculate_mark
    if self.mark.nil?
      @question1s = self.questions.quiz
      @question2s = self.questions.fill_text    
      @mark = 0    
      @question1s.each_with_index do |question, index|
        unless question.id == @question1s[index-1].id && index > 0
          @checked = self.responses.with_question_id question.id       
          @correct = self.answers.question_correct_answers question.id
          @answer_key = question.answers.correct_answers
          if @checked.count == @correct.count && @correct.count == @answer_key.count
            @mark += 1
          end
        end
      end
      @question2s.each_with_index do |question, index|
        unless question.id == @question2s[index-1].id && index > 0
          @filled = self.responses.with_question_id question.id
          @answer_key = question.answers.correct_answers        
          @correct = 0
          @filled.each_with_index do |fill, i| 
            if fill.answer_content == @answer_key[i].content
              @correct += 1
            end
          end
          if @correct == @answer_key.count
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
end