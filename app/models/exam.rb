class Exam < ActiveRecord::Base
  extend FriendlyId
  
  belongs_to :user
  belongs_to :subject

  has_many :responses, dependent: :destroy
  has_many :answers, through: :responses
  has_many :approvals, dependent: :destroy
  has_many :questions, through: :approvals

  accepts_nested_attributes_for :responses
  accepts_nested_attributes_for :approvals

  before_update :add_questions
  after_update :update_approvals
  after_update :calculate_mark
  after_save :redis_del, :add_to_remind_list

  scope :search, ->search {Exam.joins(:subject).where('subjects.name LIKE ?', "%#{search}%") if search}

  delegate :name, to: :subject
  delegate :email, to: :user

  friendly_id :slug_candidates, use: [:slugged, :finders]

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
    end
  end

  def checked?
    self.status == 2
  end

  def done?
    self.status == 1
  end

  def new?
    self.status == 0
  end

  private
  def calculate_mark
    if self.checked?
      @mark = 0    
      self.approvals.each do |approval|        
        @mark += 1  if approval.correct?
      end
      self.status = 3
      self.update_attributes mark: @mark      
    end
  end

  def update_approvals
    if self.done?
      self.questions.each_with_index do |question, index|
        if question.kind == 1
          @checked = self.responses.with_question_id question.id       
          @correct = self.answers.question_correct_answers question.id
          @answer_key = question.answers.correct_answers
          if @checked.count == @correct.count && @correct.count == @answer_key.count
            self.approvals.with_question_id(question.id)[0]
            .update_attributes correct: true
          else
            self.approvals.with_question_id(question.id)[0]
            .update_attributes correct: false
          end
        end
      end
    end
  end

  def add_questions     
    if self.new?
      self.responses.each do |response|
        if response.answer_content.nil?
          response.update_attributes question_id: response.answer.question_id
        end
      end
      self.questions << self.subject.questions
      self.status = 1
    end
  end

  def redis_del
    $redis.del self.id, "doing"
  end

  def slug_candidates
    [
      :name,
      [:name, :updated_at]
    ]
  end

  def add_to_remind_list
    data = {exam_id: self.id, email: self.email, remind_time: 0, remind_last: ""}
    $db["exam"].insert data
  end

  def self.remind
    $redis.set "time", Time.now
    UserMailer.delay.send_mail_remind
  end
end
