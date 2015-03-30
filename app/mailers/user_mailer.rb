class UserMailer < ApplicationMailer
  
  def send_mail_remind
    p 'sending' 
    $db["exam"].find.each do |exam|
      if Exam.find(exam["exam_id"]).mark.nil?
        email = exam["email"]
        p "sending to"
        p email
        p exam["exam_id"]
        mail to: email, subject: 'Remind'
        update_remind_time exam
      end
    end
    remove_exam
  end

  def update_remind_time(exam)
    $db["exam"].update({exam_id: exam["exam_id"]}, {"$set" => {remind_time: exam["remind_time"].to_i+1}})
  end

  def remove_exam
    p 'removing'
    $db["exam"].find.each do |exam|
      $db["exam"].remove({"remind_time" => 4}) 
    end
    p 'done'
  end
end