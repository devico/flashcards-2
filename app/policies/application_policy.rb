class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def rails_admin?(action)
    user.has_role?(:admin) || user.has_role?(:moderator)
  end
end
