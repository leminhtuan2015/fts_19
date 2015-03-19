class Answer < ActiveRecord::Base
  belongs_to :question

  has_many :responses, dependent: :destroy

  scope :correct_answers, ->{where(correct: true)}

  validates :content,  presence: true
end
