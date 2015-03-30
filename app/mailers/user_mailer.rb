class UserMailer < ApplicationMailer
 
  def remind_do_exam_email(email)
    mail to: email, subject: 'Remind'
  end
end
