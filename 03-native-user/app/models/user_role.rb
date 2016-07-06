class UserRole < ActiveRecord::Base
  include HasOwner

  belongs_to :user

  enum role: [:administrator, :moderator]

  validates_presence_of :user_id, :role
  validates_uniqueness_of :role, scope: [:user_id]

  # @param [User] user
  # @param [Array] suitable_roles
  def self.user_has_role?(user, *suitable_roles)
    available_roles, result = [], false
    suitable_roles.each { |role| available_roles << self.roles[role] if self.role_exists? role }
    result = self.exists? user: user, role: available_roles if available_roles.any?
    result
  end

  # @param [Symbol] role
  def self.role_exists?(role)
    self.roles.has_key? role
  end
end
