module SessionsHelper
  def current_user?(user)
    user == current_user
  end
  
  def is_admin?
    current_user.admin?
  end

  def admin_user
    redirect_to root_path unless is_admin?
  end
end
