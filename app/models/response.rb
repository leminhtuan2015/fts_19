class Response < ActiveRecord::Base
  belongs_to :exam
  belongs_to :question
  belongs_to :answer

  scope :with_question_id, ->question_id {where question_id: question_id}
end
