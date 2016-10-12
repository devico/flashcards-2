class CardPolicy < ApplicationPolicy
  attr_accessor :user, :record

  def initialize(user, record)
    super
  end

  def rails_admin?(action)
    case action
    when :destroy
      user.has_role?(:admin)
    else
      super
    end
  end
end
