class ShiftsController < ApplicationController
  before_action :set_shift, only: [:show, :edit, :update, :destroy]
  #before_action :check_login
  #can can authorization
  authorize_resource

  def index
    # if user.role? :manager
    #   @upcoming_shifts = Shift.all.upcoming.select{|s| s.assignment.store == user.current_assignment.store}
    #   @past_shifts = Shift.all.past.select{|s| s.assignment.store == user.current_assignment.store}
    # else
    @todays_shifts = Shift.all.for_next_days(0).chronological.select{|s| can? :read, s}
    @upcoming_shifts = Shift.all.upcoming.chronological.select{|s| can? :read, s}#.paginate(page: params[:page]).per_page(10)
    @past_shifts = Shift.all.past.chronological.select{|s| can? :read, s}.reverse#.paginate(page: params[:page]).per_page(10)
    #end
    #@inactive_shifts = Shift.inactive.alphabetical.select{|e| can? :read, e}.paginate(page: params[:page], :per_page => 10)
    #@active_shifts = Shift.active.alphabetical.select{|e| can? :read, e}.paginate(page: params[:page], :per_page => 10)
  end

  def show
    # get the assignment history for this shift
    @jobs = @shift.jobs.chronological.paginate(page: params[:page]).per_page(5)
    # get upcoming shifts for this shift (later)  
  end

  def new
    @shift = Shift.new
    # puts current_user.role?(:manager)
    # if current_user.role? :manager
    #   @Assignments = Assignment.current.for_store(current_user.employee.current_assignment.store)
    #   @store = current_user.employee.current_assignment.store 
    # elsif current_user.role? :admin
    #   @Assignments = Assignment.current 
    #   @stores = Store.alphabetical 
    
  end

  def edit
  end

  def create
    @shift = Shift.new(shift_params)
    if @shift.save
      redirect_to shifts_path, notice: "Successfully created #{@shift.id}."
    else
      render action: 'new'
    end
  end

  def update
    if @shift.update(shift_params)
      redirect_to shift_paths(@shift), notice: "Successfully updated #{@shift.id}."
    else
      render action: 'edit'
    end
  end

  def destroy
    @shift.destroy
    redirect_to shifts_path, notice: "Successfully removed #{@shift.id} from the AMC system."
  end

  private
  def set_shift
    @shift = Shift.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:assignment_id, :date, :start_time, :end_time, :notes)
  end

end