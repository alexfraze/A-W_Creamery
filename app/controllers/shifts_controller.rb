class ShiftsController < ApplicationController
  before_action :set_shift, only: [:show, :edit, :update, :destroy, :start_now, :end_now]
  #before_action :check_login
  #can can authorization
  authorize_resource

  def index
    e = current_user.employee
    curr_a = e.current_assignment
    if current_user.role? :manager
      @todays_shifts = Shift.for_next_days(0).chronological.select{|s| s.assignment.store == curr_a.store}#.paginate(:page => params[:page], :per_page => 10)
      @this_weeks_shifts = Shift.for_next_days(5).chronological.select{|s| s.assignment.store == curr_a.store}#.paginate(:page => params[:page], :per_page => 10)
      @past_weeks_shifts = Shift.for_past_days(5).chronological.select{|s| s.assignment.store == curr_a.store}#.paginate(:page => params[:page], :per_page => 10)
    elsif current_user.role? :admin
      @todays_shifts = Shift.for_next_days(0).chronological#.paginate(:page => params[:page], :per_page => 10)
      @this_weeks_shifts = Shift.for_next_days(5).chronological#.paginate(:page => params[:page], :per_page => 10)
      @past_weeks_shifts = Shift.for_past_days(5).chronological#.paginate(:page => params[:page], :per_page => 10)
    else
      @todays_shifts = Shift.for_employee(e.id).for_next_days(0)
      @this_weeks_shifts = Shift.for_employee(e.id).for_next_days(7)
      @past_weeks_shifts = Shift.for_employee(e.id).for_past_days(7)
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

def create_next_week
  e = current_user.employee
  curr_a = e.current_assignment
  if current_user.role? :manager
      @this_weeks_shifts = Shift.for_next_days(5).chronological.select{|s| s.assignment.store == curr_a.store}#.paginate(:page => params[:page], :per_page => 10)
    else current_user.role? :admin
    @this_weeks_shifts = Shift.for_next_days(10).chronological#.paginate(:page => params[:page], :per_page => 10)
  end
  @this_weeks_shifts_copy = @this_weeks_shifts.map do |e| e.dup end 
    @create_next_week = @this_weeks_shifts_copy.each{|s| s.date = (s.date + 7) }
    @create_next_week.each{|s| s.save!}
    redirect_to shifts_path
  end

  def create_this_week
    e = current_user.employee
    curr_a = e.current_assignment
    if current_user.role? :manager
      @past_weeks_shifts = Shift.for_past_days(7).chronological.select{|s| s.assignment.store == curr_a.store}#.paginate(:page => params[:page], :per_page => 10)
    else current_user.role? :admin
      @this_weeks_shifts = Shift.for_past_days(7).chronological#.paginate(:page => params[:page], :per_page => 10)
    end
    @last_weeks_shifts_copy = @last_weeks_shifts.map do |e| e.dup end 
    @create_this_week = @last_weeks_shifts_copy.each{|s| s.date = (s.date + 7) }
    @create_this_week.each{|s| s.save!}
    redirect_to shifts_path
  end

    def start_now
      @shift.start_now
      redirect_to home_path, notice: "started shift"
    end

    def end_now
      @shift.end_now
      redirect_to home_path, notice: "ended shift"
    end


    def edit
      if current_user.role? :manager
       @assignments = Assignment.current.for_store(current_user.employee.current_assignment.store.id).by_employee
     else
      @assignments = Assignment.current.by_employee
    end
    @jobs = Job.active.alphabetical
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

  def completed_shifts
    if current_user.role? :manager
     @completed_shifts = Shift.completed.for_store(current_user.employee.current_assignment.store)
   elsif current_user.role? :employee
      @completed_shifts = Shift.completed.for_employee(current_user.employee)
   else 
      @completed_shifts = Shift.completed
   
   end
  end

  def incomplete_shifts
    if current_user.role? :manager
     @incomplete_shifts = Shift.incomplete.for_store(current_user.employee.current_assignment.store)
    elsif current_user.role? :employee
      @incomplete_shifts = Shift.incomplete.for_employee(current_user.employee)
   else 
      @incomplete_shifts = Shift.incomplete
   end
  end


  private
  def set_shift
    @shift = Shift.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:assignment_id, :date, :start_time, :end_time, :notes, :job_ids => [])
  end


end