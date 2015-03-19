class StaticPagesController < ApplicationController
  def home
    if user_signed_in? 
      if current_user.admin?
        @exams = Exam.paginate page: params[:page], per_page: 10
      else
        @subjects = Subject.all
        @exam = Exam.new      
        @exams = current_user.exams.paginate page: params[:page], per_page: 10
      end
    end
  end
end