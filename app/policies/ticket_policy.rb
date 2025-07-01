class TicketPolicy
  attr_reader :user, :ticket
  def initialize(user, ticket)
    @user = user
    @ticket = ticket
  end

  def index?
    user.present?
  end

  def create?
    return false unless user
    user.customer?
  end

  def show?
    user.agent? || (user.customer? && ticket.user_id == user.id)
  end

  def update?
    user.agent?
  end

  def close?
    user.agent?
  end

  class Scope
    attr_reader :user, :scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.agent?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end
end
