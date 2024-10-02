class TemplatePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def find_by_domain?
    true
  end

  class Scope < Scope
    def resolve
      Template.all
    end
  end
end
