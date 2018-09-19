class Admin::ApplicationPolicyV2 < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record.is_a?(Array) ? record.last : record
  end

  def show?
    scope.where(:id => record.id).exists? && user.admin
  end

  def create?
    user.admin
  end

  def new?
    show?
  end

  def update?
    show?
  end

  def edit?
    show?
  end

  def destroy?
    show?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if user.admin
        scope.all
      end
    end
  end

end
