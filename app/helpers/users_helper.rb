module UsersHelper
  def admin_user
    unless current_user.admin?
      flash[:danger] = "Please log in by admin account."
      redirect_to root_url
    end   
  end
end