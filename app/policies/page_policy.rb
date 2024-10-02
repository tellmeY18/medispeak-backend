class PagePolicy < ApplicationPolicy
  def show?
    TemplatePolicy.new(user, record.template).show?
  end

  def index?
    false
  end

  alias_method :preview?, :show?
end
