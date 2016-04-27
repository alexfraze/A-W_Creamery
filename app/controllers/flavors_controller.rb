class FlavorsController < ApplicationController
  before_action :set_flavor, only: [:show, :edit, :update, :destroy]
  #before_action :check_login
  #can can authorization
  authorize_resource

  def index
    # if user.role? :manager
    #   @upcoming_flavors = Flavor.all.upcoming.select{|s| s.assignment.store == user.current_assignment.store}
    #   @past_flavors = Flavor.all.past.select{|s| s.assignment.store == user.current_assignment.store}
    # else
    @active_flavors = Flavor.active.alphabetical
    @inactive_flavors = Flavor.inactive.alphabetical
    #end
    #@inactive_flavors = Flavor.inactive.alphabetical.select{|e| can? :read, e}.paginate(page: params[:page], :per_page => 10)
    #@active_flavors = Flavor.active.alphabetical.select{|e| can? :read, e}.paginate(page: params[:page], :per_page => 10)
  end

  def show
    # get the assignment history for this flavor
    # get upcoming flavors for this flavor (later)  
  end

  def new
    @flavor = Flavor.new
    #@flavor.user.build
    #@flavor.user.flavor_id = @flavor.id
  end

  def edit
  end

  def create
    @flavor = Flavor.new(flavor_params)
    if @flavor.save
      redirect_to flavors_path, notice: "Successfully created #{@flavor.proper_name}."
    else
      render action: 'new'
    end
  end

  def update
    if @flavor.update(flavor_params)
      redirect_to flavor_paths(@flavor), notice: "Successfully updated #{@flavor.proper_name}."
    else
      render action: 'edit'
    end
  end

  def destroy
    @flavor.destroy
    redirect_to flavors_path, notice: "Successfully removed #{@flavor.proper_name} from the AMC system."
  end

  private
  def set_flavor
    @flavor = Flavor.find(params[:id])
  end

  def flavor_params
    params.require(:flavor).permit(:name, :active)
  end

end