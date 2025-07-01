class AttachmentPolicy
  attr_reader :user, :attachment

  def initialize(user, attachment)
    @user = user
    @attachment = attachment
  end

  def create?
    user.agent? || (user.customer? && attachment.ticket.user_id == user.id)
  end

  def show?
    user.agent? || (user.customer? && attachment.ticket.user_id == user.id)
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
        scope.joins(:ticket).where(tickets: { user_id: user.id })
      end
    end
  end
end
