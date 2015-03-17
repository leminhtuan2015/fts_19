class Response < ActiveRecord::Base
  belongs_to :exam
  belongs_to :subject
  belongs_to :answer
end
