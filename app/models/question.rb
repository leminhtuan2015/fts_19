class Question < ActiveRecord::Base
  belongs_to :subject

  has_many :answers, dependent: :destroy
  has_many :responses, dependent: :destroy
  has_many :exams, through: :responses

  accepts_nested_attributes_for :answers, allow_destroy: true

  validates :content,  presence: true
end
