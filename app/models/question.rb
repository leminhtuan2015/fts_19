class Question < ActiveRecord::Base
  belongs_to :subject

  has_many :answers, dependent: :destroy
  has_many :responses, dependent: :destroy
  has_many :exams, through: :responses

  accepts_nested_attributes_for :answers, allow_destroy: true

  validates :content,  presence: true

  scope :quiz, ->{where('questions.id IN (select answers.question_id 
    from answers where answers.correct=?)', false)}
  scope :fill_text, ->{where('questions.id NOT IN (select answers.question_id 
    from answers where answers.correct=?)', false)}
end
