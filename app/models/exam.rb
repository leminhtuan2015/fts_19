class Exam < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject

  has_many :responses, dependent: :destroy
end
