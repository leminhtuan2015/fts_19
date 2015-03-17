class Subject < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :exams, dependent: :destroy

  accepts_nested_attributes_for :answers, allow_destroy: true

  validates :name,  presence: true, length: {maximum: 50}
  validates :description,  presence: true
end
