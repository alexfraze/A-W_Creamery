class Ability
    include CanCan::Ability

    def initialize(user)
        user ||= User.new # guest user (not logged in)
        if user.role? :admin
            can :manage, :all
        elsif user.role? :manager 
            if user.employee.working?
                can :read, [Store, Job, Flavor]
                can :read, Employee do |e|
                    e.working? && e.current_assignment.store == user.employee.current_assignment.store
                end
                can :incomplete_shifts, Shift 
                can :completed_shifts, Shift
                can :read, Assignment do |a|
                     a.store == user.employee.current_assignment.store
                end
                can :read, Shift do |s|
                     !s.employee.current_assignment.nil? && s.employee.current_assignment.store == user.employee.current_assignment.store
                end
                can :create, Shift do |s|
                  s.store == user.employee.current_assignment.store && s.employee.working? && s.employee.current_assignment.store == user.employee.current_assignment.store  
                end
                can [:update, :destroy], Shift do |s|
                	s.store == user.employee.current_assignment.store
                end
                can [:create, :destroy], ShiftJob do |sj|
                	sj.shift.store == user.employee.current_assignment.store
    			end
    			can [:create, :destroy], StoreFlavor do |sf|
    				sf.store == user.employee.current_assignment.store 
    			end
                can :create_this_week, Shift
                can :create_next_week, Shift 
            end
        elsif user.role? :employee
            can :incomplete_shifts, Shift 
            can :completed_shifts, Shift
            can :read, [Store, Job, Flavor] 
            can :read, [Assignment, User, Shift] do |x| #user, shift
            	x.employee == user.employee
            end
            can :read, Employee do |e|
            	e == user.employee
            end
            can :read, ShiftJob do |sj|
            	sj.shift.employee == user.employee
            end
            can :read, ShiftJob do |sj|
                sj.shift.employee == user.employee
            end
            can :start_now, Shift do |s|
                s.date == Date.today
            end
            can :end_now, Shift do |s|
                s.date == Date.today
            end
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
    