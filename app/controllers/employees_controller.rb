class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  authorize_resource

  def index
    user = current_user
    if user.role? :manager
      user = user.employee
      @active_employees = Employee.active.alphabetical.select{|e| e.working? && e.current_assignment.store == user.current_assignment.store}.paginate(:page => params[:page], :per_page => 10)
      @inactive_employees = Employee.inactive.alphabetical.select{|e| e.working? && e.current_assignment.store == user.current_assignment.store}.paginate(page: params[:page], :per_page => 10)
    elsif user.role? :admin
      @active_employees = Employee.active.alphabetical.paginate(page: params[:page]).per_page(10)
      @inactive_employees = Employee.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
    else
      @active_employees = [user.employee]
      @inactive_employees = []
    end
  end

  def show
    # get the assignment history for this employee
    @assignments = @employee.assignments.chronological.paginate(page: params[:page]).per_page(5)
    # get upcoming shifts for this employee (later)  
  end

  def new
    @employee = Employee.new
    @employee.build_user
    #@employee.user.employee_id = @employee.id
  end

  def edit
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      redirect_to employee_path(@employee), notice: "Successfully created #{@employee.proper_name}."
    else
      render action: 'new'
    end
  end

  def update
    if @employee.update(employee_params)
      redirect_to employee_path(@employee), notice: "Successfully updated #{@employee.proper_name}."
    else
      render action: 'edit'
    end
  end

  def destroy
    @employee.destroy
    redirect_to employees_path, notice: "Successfully removed #{@employee.proper_name} from the AMC system."
  end

  private
  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :ssn, :date_of_birth, :role, :phone, :active, user_attributes: [:email, :password, :password_confirmation, :_destroy])
  end

end