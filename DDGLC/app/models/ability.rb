class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      if user.admin?
        can :access, :rails_admin
        can :dashboard
        can :manage, :all

      elsif user.manager?
        can :index, User
        can :about, :lexicon
        can :manage, Lemma
        can :manage, Sublemma

        can :manage, LemmaComment, created_by_id: user.id
        can :manage, SublemmaComment, created_by_id: user.id

      elsif user.employee?
        can :about, :lexicon
        can :manage, Lemma
        cannot :destroy, Lemma
        can :manage, Sublemma
        cannot :destroy, Sublemma

        can :manage, LemmaComment, created_by_id: user.id
        can :manage, SublemmaComment, created_by_id: user.id


      elsif user.guest?
        can :index, Lemma
        can :show, Lemma
        can :index, Sublemma
        can :show, Sublemma

      end
    end

  end
end
