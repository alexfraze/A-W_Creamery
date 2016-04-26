class User < ActiveRecord::Base
  # get modules to help with some functionality
  include CreameryHelpers::Validations

  # Use built-in rails support for password protection
  has_secure_password

  # Relationships
  belongs_to :employee

  # Validations
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of :email, :with => /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i, :message => "is not a valid format"
  validate :employee_is_active_in_system, on: :update
  

  ROLES = [['admin', :admin],['manager', :manager],['employee', :member]]

  def role?(authorized_role)
    return false if self.employee.nil?
    return :guest if !self.employee.working?
    self.employee.role.to_sym == authorized_role
  end

  #authentication
  def self.authenticate(email,password)
    find_by_email(email).try(:authenticate, password)
  end


  private

  def employee_is_active_in_system
    is_active_in_system(:employee)
  end


end
