class FormFieldPolicy < ApplicationPolicy
  def show?
    PagePolicy.new(user, record.page).show?
  end

  alias_method :create?, :show?
  alias_method :update?, :show?
  alias_method :new?, :show?
  alias_method :edit?, :show?
  alias_method :destroy?, :show?

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
