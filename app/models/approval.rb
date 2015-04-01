class Approval < ActiveRecord::Base
  belongs_to :exam
  belongs_to :question

  scope :with_question_id, ->question_id {where question_id: question_id}
end
