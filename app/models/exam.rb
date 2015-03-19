class Exam < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject

  has_many :responses, dependent: :destroy
  has_many :questions, through: :responses
  has_many :answers, through: :responses

  before_update :calculate_mark
  after_update :add_questions

  private
  def calculate_mark
    @mark = self.answers.correct_answers.count
    self.mark = @mark
  end

  def add_questions
    unless self.mark.nil?
      self.responses.each do |response|
        response.update_attributes question_id: response.answer.question_id
      end
    end
  end
end
