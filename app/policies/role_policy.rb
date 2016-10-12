class RolePolicy < ApplicationPolicy
  attr_accessor :user, :record

  def initialize(user, record)
    super
  end

  def rails_admin?(action)
    user.has_role?(:admin)
  end
end
