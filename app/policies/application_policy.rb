class ApplicationPolicy
  attr_reader :user, :is_api, :record

  def initialize(user, record)
    @user = user
    @is_api = user.class.to_s == "Api"
    @record = record.is_a?(Array) ? record.last : record
  end

  def index?
    user
  end

  def show?
    scope.where(:id => record.id).exists? && user
  end

  def create?
    index?
  end

  def new?
    index?
  end

  def update?
    index?
  end

  def edit?
    index?
  end

  def destroy?
    index?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
  
end
