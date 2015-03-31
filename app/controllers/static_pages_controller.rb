class StaticPagesController < ApplicationController

  def home
    if user_signed_in?
      @subjects = Subject.all
      if current_user.admin?        
        if params[:search].nil? && params[:search_remote].nil?
          @exams = Exam.paginate page: params[:page], per_page: 10
        elsif params[:search_remote].nil?
          search params[:search]
        elsif params[:search].nil?
          search params[:search_remote]
        end
      else
        @exam = Exam.new
        if params[:search].nil? && params[:search_remote].nil?
          @exams = current_user.exams.paginate page: params[:page], per_page: 10
        elsif params[:search_remote].nil?
          search params[:search]
        elsif params[:search].nil?
          search params[:search_remote]
        end
      end
    end
  end

  private
  def search(search_query)
    if search_query.empty?
      @exams = current_user.exams.paginate page: params[:page], per_page: 10
    else
      @exams = current_user.exams.search(search_query).paginate page: params[:page], per_page: 10
    end
  end
end