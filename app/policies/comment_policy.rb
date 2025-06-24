class CommentPolicy
  attr_reader :user, :comment

  def initialize(user, comment)
    @user = user
    @comment = comment
  end

  def create?
    comment.ticket.can_comment?(user)
  end

  def show?
    user.agent? || (user.customer? && comment.ticket.user_id == user.id)
  end

  class Scope
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
