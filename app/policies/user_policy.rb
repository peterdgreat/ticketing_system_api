class UserPolicy
    attr_reader :user, :current_user

    def initialize(current_user, user)
      @current_user = current_user
      @user = user
    end

    def index?
      current_user.agent?
    end

    def show?
      current_user.agent? || current_user.id == user.id
    end

    def create?
      true
    end

    def update?
      current_user.agent? || current_user.id == user.id
    end

    class Scope
      def initialize(current_user, scope)
        @current_user  = current_user
        @scope = scope
      end

      def resolve
        if current_user.agent?
          scope.all
        else
          scope.where(id: current_user.id)
        end
      end
    end
end
