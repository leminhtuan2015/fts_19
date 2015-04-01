class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @subjects = Subject.all
      if current_user.admin?
        if params[:search].nil?
          @exams = Exam.paginate page: params[:page], per_page: 10
        else
          search params[:search]
        end
      else
        @exam = Exam.new
        if params[:search].nil?
          @exams = current_user.exams.paginate page: params[:page], per_page: 10
        else
          search params[:search]
        end
      end
    end
  end

  private
  def search(search_query)
    @exams = current_user.exams.search(search_query).paginate page: params[:page], per_page: 10
  end
end