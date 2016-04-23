class Ability
    include CanCan::Ability

    def initialize(user)
        user ||= User.new # guest user (not logged in)
        if user.role? :admin
            can :manage, :all
        elsif user.role? :manager
            can :read, [Store, Job, Flavor]
            can :read, Employee do |e|
                e.working? && user.employee.working? && e.current_assignment.store == user.employee.current_assignment.store
            end
            can :read, Assignment do |a|
                !user.employee.store.nil? && a.store == user.employee.cuurent_assignment.store
            end
        elsif user.role? :employee
           # can 
        else
        can :read, Store
    end
end


end



    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    