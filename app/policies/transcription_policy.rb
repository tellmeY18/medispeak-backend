class TranscriptionPolicy < ApplicationPolicy
  def index?
    true
  end

  class Scope < Scope
    def resolve
      user.transcriptions
    end
  end
end
