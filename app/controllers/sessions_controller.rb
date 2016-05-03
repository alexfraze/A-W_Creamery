  class SessionsController < ApplicationController
    def new
    end

    def create
      user = User.find_by_email(params[:email])
      if user && User.authenticate(params[:email], params[:password])
        session[:user_id] = user.id
        if (current_user.role? :employee or current_user.role? :manager)
          if(!current_user.employee.nil?) then x = current_user.employee.shifts.for_next_days(0)
            if x.empty? 
              redirect_to shifts_path, notice: "Logged in!"
            else 
              redirect_to shift_path(x.first), notice: "Logged in!"
            end
          end
        elsif current_user.role? :admin or current_user.role? :guest
          redirect_to home_path, notice: "Logged in!"
        else
          flash.now.alert = "Email or password is invalid"
          render "new"
        end
      end
    end

    def destroy
      session[:user_id] = nil
      redirect_to home_path, notice: "Logged out!"
    end
  end