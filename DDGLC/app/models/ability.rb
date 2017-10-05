class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      if user.admin?
        # can :access, :rails_admin
        can :manage, :all

      elsif user.manager?
        can :index, :User

      elsif user.employee?


      elsif user.guest?

      end
    end

  end
end
