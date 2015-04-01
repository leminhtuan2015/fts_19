class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
    else
      can :update, Exam do |exam|
        exam.new?
      end
    end
  end
end
