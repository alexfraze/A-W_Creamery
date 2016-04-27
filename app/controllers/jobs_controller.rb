class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  #before_action :check_login
  #can can authorization
  authorize_resource

  def index
    # if user.role? :manager
    #   @upcoming_jobs = Job.all.upcoming.select{|s| s.assignment.store == user.current_assignment.store}
    #   @past_jobs = Job.all.past.select{|s| s.assignment.store == user.current_assignment.store}
    # else
    @active_jobs = Job.active.alphabetical
    @inactive_jobs = Job.inactive.alphabetical
    #end
    #@inactive_jobs = Job.inactive.alphabetical.select{|e| can? :read, e}.paginate(page: params[:page], :per_page => 10)
    #@active_jobs = Job.active.alphabetical.select{|e| can? :read, e}.paginate(page: params[:page], :per_page => 10)
  end

  def show
  end

  def new
    @job = Job.new
  end

  def edit
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      redirect_to jobs_path, notice: "Successfully created #{@job.name}."
    else
      render action: 'new'
    end
  end

  def update
    if @job.update(job_params)
      redirect_to job_paths(@job), notice: "Successfully updated #{@job.proper_name}."
    else
      render action: 'edit'
    end
  end

  def destroy
    @job.destroy
    redirect_to jobs_path, notice: "Successfully removed #{@job.proper_name} from the AMC system."
  end

  private
  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:name, :description, :active)
  end

end