class User < ActiveRecord::Base
  mount_uploader :avatar, PhotoUploader
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :exams, dependent: :destroy
end
