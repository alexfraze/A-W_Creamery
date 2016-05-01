class ShiftsController < ApplicationController
  before_action :set_shift, only: [:show, :edit, :update, :destroy]
  #before_action :check_login
  #can can authorization
  authorize_resource

  def index
   if current_user.role? :manager
    e = current_user.employee
    curr_a = e.current_assignment
      @todays_shifts = Shift.all.for_next_days(0).chronological.select{|s| s.assignment.store == curr_a.store}#.paginate(:page => params[:page], :per_page => 10)
      @this_weeks_shifts = Shift.all.for_next_days(3).chronological.select{|s| s.assignment.store == curr_a.store}#.paginate(:page => params[:page], :per_page => 10)
      @past_weeks_shifts = Shift.all.for_past_days(4).chronological.select{|s| s.assignment.store == curr_a.store}#.paginate(:page => params[:page], :per_page => 10)
    else
      @todays_shifts = Shift.all.for_next_days(0).chronological#.paginate(:page => params[:page], :per_page => 10)
      @this_weeks_shifts = Shift.all.for_next_days(3).chronological#.paginate(:page => params[:page], :per_page => 10)
      @past_weeks_shifts = Shift.all.for_past_days(4).chronological#.paginate(:page => params[:page], :per_page => 10)
    end
  end

  def show
    @jobs = @shift.jobs.alphabetical.paginate(page: params[:page]).per_page(5)
  end

  def new
    @shift = Shift.new
    if current_user.role? :manager
     @assignments = Assignment.current.for_store(current_user.employee.current_assignment.store.id).by_employee
    else
      @assignments = Assignment.current.by_employee
    end
    @jobs = Job.active.alphabetical
  end

def edit
end

def create
  @shift = Shift.new(shift_params)
  authorize! :create, @shift
  if @shift.save
    redirect_to shifts_path , notice: "Successfully created shift for #{@shift.assignment.employee.name}."
  else
    render action: 'new'
  end
end

def update
  if @shift.update(shift_params)
    redirect_to shift_path(@shift), notice: "Successfully updated #{@shift.id}."
  else
    render action: 'edit'
  end
end

def destroy
  @shift.destroy
  redirect_to shifts_path, notice: "Successfully removed #{@shift.id} from the AMC system."
end

def past_shifts
  if current_user.role? :manager
   @past_shifts = Shift.all.past.select{|s| s.assignment.store == current_user.employee.current_assignment.store}.reverse
 else 
      @past_shifts = Shift.all.past.chronological.reverse#.paginate(page: params[:page]).per_page(10)
    end
  end

  def future_shifts
    if current_user.role? :manager
     @future_shifts = Shift.all.upcoming.select{|s| s.assignment.store == current_user.employee.current_assignment.store}
   else
      @future_shifts = Shift.all.upcoming.chronological#.paginate(page: params[:page]).per_page(10)
    end
  end


  private
  def set_shift
    @shift = Shift.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:assignment_id, :date, :start_time, :end_time, :notes, shift_jobs_attributes: [:shift_id, :job_id, :_destroy])
  end


end