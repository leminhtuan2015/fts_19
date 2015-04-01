class Answer < ActiveRecord::Base
  belongs_to :question

  has_many :responses, dependent: :destroy

  scope :correct_answers, ->{where correct: true}
  scope :question_correct_answers, ->question_id {where question_id: question_id, correct: true}

  validates :content,  presence: true
end
